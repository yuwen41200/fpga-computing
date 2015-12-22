module xillydemo (
	input PCIE_REFCLK_N,
	input PCIE_REFCLK_P,
	input PCIE_PERST_B_LS,
	input PCIE_RX0_N,
	input PCIE_RX0_P,
	output [7:0] GPIO_LED,
	output PCIE_TX0_N,
	output PCIE_TX0_P
);

/**
 * Xillybus PCIe Interface Signals
 */

wire        bus_clk;                   // Output - The PCIe clock.
wire        quiesce;                   // Output - The host does not load Xillybus.

wire        user_r_read_32_rden;       // Output - Read data from FIFO.
wire        user_r_read_32_empty;      // Input  - The FIFO is empty, stop reading.
wire [31:0] user_r_read_32_data;       // Input  - The data to be read.
wire        user_r_read_32_eof;        // Input  - End of file is reached, stop reading.
wire        user_r_read_32_open;       // Output - The host opens the device file with read mode.

wire        user_w_write_32_wren;      // Output - Write data to FIFO.
wire        user_w_write_32_full;      // Input  - The FIFO is full, stop writing.
wire [31:0] user_w_write_32_data;      // Output - The data to be write.
wire        user_w_write_32_open;      // Output - The host opens the device file with write mode.

/**
 * Finite State Machine Signals
 */

parameter [3:0] IDLE_STATE = 4'b0001;
parameter [3:0] RECV_STATE = 4'b0010;
parameter [3:0] EXEC_STATE = 4'b0100;
parameter [3:0] SEND_STATE = 4'b1000;

reg [3:0] curr_state;
reg [3:0] next_state;

wire exec_done;

/**
 * Receiving State Signals
 */

reg  [8:0]  recv_counter;
wire        recv_enabled;
wire [31:0] recv_data;
wire        recv_valid;

integer iterator;

/**
 * Sending State Signals
 */

reg  [8:0]  send_counter;
wire        send_enabled;
wire [31:0] send_data;
wire        send_full;

/**
 * Executing State Signals
 */

reg  [15:0] in_data   [0:511];
reg         in_valid  [0:511];
wire [15:0] out_data  [0:511];
wire        out_valid [0:511];

/**
 * Xillybus PCIe Interface Logic
 */

xillybus xillybus_ins (
	.user_r_read_32_rden(user_r_read_32_rden),
	.user_r_read_32_empty(user_r_read_32_empty),
	.user_r_read_32_data(user_r_read_32_data),
	.user_r_read_32_eof(user_r_read_32_eof),
	.user_r_read_32_open(user_r_read_32_open),

	.user_w_write_32_wren(user_w_write_32_wren),
	.user_w_write_32_full(user_w_write_32_full),
	.user_w_write_32_data(user_w_write_32_data),
	.user_w_write_32_open(user_w_write_32_open),

	.PCIE_REFCLK_N(PCIE_REFCLK_N),
	.PCIE_REFCLK_P(PCIE_REFCLK_P),
	.PCIE_PERST_B_LS(PCIE_PERST_B_LS),
	.PCIE_RX0_N(PCIE_RX0_N),
	.PCIE_RX0_P(PCIE_RX0_P),
	.GPIO_LED(GPIO_LED[3:0]),
	.PCIE_TX0_N(PCIE_TX0_N),
	.PCIE_TX0_P(PCIE_TX0_P),

	.bus_clk(bus_clk),
	.quiesce(quiesce)
);

fifo_32x512 fifo_out (
	.clk(bus_clk),                     // Input
	.srst(~user_w_write_32_open),      // Input

	.wr_en(user_w_write_32_wren),      // Input
	.din(user_w_write_32_data),        // Input
	.full(user_w_write_32_full),       // Output
	.almost_full(),                    // Output

	.rd_en(recv_enabled),              // Input
	.dout(recv_data),                  // Output
	.empty(),                          // Output
	.valid(recv_valid)                 // Output
);

fifo_32x512 fifo_in (
	.clk(bus_clk),                     // Input
	.srst(~user_r_read_32_open),       // Input

	.wr_en(send_enabled),              // Input
	.din(send_data),                   // Input
	.full(),                           // Output
	.almost_full(send_full),           // Output

	.rd_en(user_r_read_32_rden),       // Input
	.dout(user_r_read_32_data),        // Output
	.empty(user_r_read_32_empty),      // Output
	.valid()                           // Output
);

assign user_r_read_32_eof = 0;

/**
 * Finite State Machine Logic
 */

assign GPIO_LED[7:4] = curr_state;
assign exec_done = out_valid[511];

always @(posedge bus_clk) begin
	if (quiesce || ~user_w_write_32_open || ~user_r_read_32_open)
		curr_state <= IDLE_STATE;
	else
		curr_state <= next_state;
end

always @(*) begin
	case (curr_state)
		IDLE_STATE:
			if (user_w_write_32_open && user_r_read_32_open)
				next_state = RECV_STATE;
			else
				next_state = IDLE_STATE;
		RECV_STATE:
			if (recv_counter == 510)
				next_state = EXEC_STATE;
			else
				next_state = RECV_STATE;
		EXEC_STATE:
			if (exec_done)
				next_state = SEND_STATE;
			else
				next_state = EXEC_STATE;
		SEND_STATE:
			if (send_counter == 510)
				next_state = IDLE_STATE;
			else
				next_state = SEND_STATE;
	endcase
end

/**
 * Receiving State Logic
 */

assign recv_enabled = (curr_state == RECV_STATE) ? 1 : 0;

always @(posedge bus_clk) begin
	if (curr_state == RECV_STATE) begin
		if (recv_valid) begin
			in_data[recv_counter]    <= recv_data[15:0];
			in_data[recv_counter+1]  <= recv_data[31:16];
			in_valid[recv_counter]   <= 1;
			in_valid[recv_counter+1] <= 1;
			recv_counter <= recv_counter + 2;
		end
	end
	else begin
		for (iterator = 0; iterator < 512; iterator = iterator + 1) begin
			in_valid[iterator] <= 0;
		end
		recv_counter <= 0;
	end
end

/**
 * Sending State Logic
 */

assign send_enabled = (curr_state == SEND_STATE) ? 1 : 0;
assign send_data[15:0]  = out_data[send_counter];
assign send_data[31:16] = out_data[send_counter+1];

always @(posedge bus_clk) begin
	if (curr_state == SEND_STATE)
		if (~send_full)
			send_counter <= send_counter + 2;
	else
		send_counter <= 0;
end

/**
 * Executing State Logic
 */

generate
	genvar thread_no;
	for (thread_no = 0; thread_no < 512; thread_no = thread_no + 1) begin:warp
		kernel kernel_ins (
			.clk(bus_clk),
			.in_data(in_data[thread_no]),
			.in_valid(in_valid[thread_no]),
			.out_data(out_data[thread_no]),
			.out_valid(out_valid[thread_no])
		);
	end
endgenerate

endmodule
