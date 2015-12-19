module xillydemo (
	input PCIE_REFCLK_N,
	input PCIE_REFCLK_P,
	input PCIE_PERST_B_LS,
	input PCIE_RX0_N,
	input PCIE_RX0_P,
	output [3:0] GPIO_LED,
	output PCIE_TX0_N,
	output PCIE_TX0_P
);

wire        bus_clk;                   // Output - The PCIe clock.
wire        quiesce;                   // Output - The host does not load Xillybus.

reg  [7:0]  demoarray [0:31];          // Internal memory array.

wire        user_r_mem_8_rden;         // Output - Read data from FIFO.
wire        user_r_mem_8_empty;        // Input  - The FIFO is empty, stop reading.
reg  [7:0]  user_r_mem_8_data;         // Input  - The data to be read.
wire        user_r_mem_8_eof;          // Input  - End of file is reached, stop reading.
wire        user_r_mem_8_open;         // Output - The host opens the device file with read mode.
wire        user_w_mem_8_wren;         // Output - Write data to FIFO.
wire        user_w_mem_8_full;         // Input  - The FIFO is full, stop writing.
wire [7:0]  user_w_mem_8_data;         // Output - The data to be write.
wire        user_w_mem_8_open;         // Output - The host opens the device file with write mode.
wire [4:0]  user_mem_8_addr;           // Output - The address to read or write.
wire        user_mem_8_addr_update;    // Output - The host seeks the device file.

wire        user_r_read_32_rden;       // The meanings of the following wires are same as above.
wire        user_r_read_32_empty;
wire [31:0] user_r_read_32_data;
wire        user_r_read_32_eof;
wire        user_r_read_32_open;

wire        user_r_read_8_rden;
wire        user_r_read_8_empty;
wire [7:0]  user_r_read_8_data;
wire        user_r_read_8_eof;
wire        user_r_read_8_open;

wire        user_w_write_32_wren;
wire        user_w_write_32_full;
wire [31:0] user_w_write_32_data;
wire        user_w_write_32_open;

wire        user_w_write_8_wren;
wire        user_w_write_8_full;
wire [7:0]  user_w_write_8_data;
wire        user_w_write_8_open;

xillybus xillybus_ins (
	// Ports related to /dev/xillybus_mem_8
	.user_r_mem_8_rden(user_r_mem_8_rden),
	.user_r_mem_8_empty(user_r_mem_8_empty),
	.user_r_mem_8_data(user_r_mem_8_data),
	.user_r_mem_8_eof(user_r_mem_8_eof),
	.user_r_mem_8_open(user_r_mem_8_open),
	.user_w_mem_8_wren(user_w_mem_8_wren),
	.user_w_mem_8_full(user_w_mem_8_full),
	.user_w_mem_8_data(user_w_mem_8_data),
	.user_w_mem_8_open(user_w_mem_8_open),
	.user_mem_8_addr(user_mem_8_addr),
	.user_mem_8_addr_update(user_mem_8_addr_update),

	// Ports related to /dev/xillybus_read_32
	.user_r_read_32_rden(user_r_read_32_rden),
	.user_r_read_32_empty(user_r_read_32_empty),
	.user_r_read_32_data(user_r_read_32_data),
	.user_r_read_32_eof(user_r_read_32_eof),
	.user_r_read_32_open(user_r_read_32_open),

	// Ports related to /dev/xillybus_write_32
	.user_w_write_32_wren(user_w_write_32_wren),
	.user_w_write_32_full(user_w_write_32_full),
	.user_w_write_32_data(user_w_write_32_data),
	.user_w_write_32_open(user_w_write_32_open),

	// Ports related to /dev/xillybus_read_8
	.user_r_read_8_rden(user_r_read_8_rden),
	.user_r_read_8_empty(user_r_read_8_empty),
	.user_r_read_8_data(user_r_read_8_data),
	.user_r_read_8_eof(user_r_read_8_eof),
	.user_r_read_8_open(user_r_read_8_open),

	// Ports related to /dev/xillybus_write_8
	.user_w_write_8_wren(user_w_write_8_wren),
	.user_w_write_8_full(user_w_write_8_full),
	.user_w_write_8_data(user_w_write_8_data),
	.user_w_write_8_open(user_w_write_8_open),

	// Signals to top level
	.PCIE_REFCLK_N(PCIE_REFCLK_N),
	.PCIE_REFCLK_P(PCIE_REFCLK_P),
	.PCIE_PERST_B_LS(PCIE_PERST_B_LS),
	.PCIE_RX0_N(PCIE_RX0_N),
	.PCIE_RX0_P(PCIE_RX0_P),
	.GPIO_LED(GPIO_LED),
	.PCIE_TX0_N(PCIE_TX0_N),
	.PCIE_TX0_P(PCIE_TX0_P),
	.bus_clk(bus_clk),
	.quiesce(quiesce)
);

// A simple inferred RAM
always @(posedge bus_clk) begin
	if (user_w_mem_8_wren)
		demoarray[user_mem_8_addr] <= user_w_mem_8_data;
	if (user_r_mem_8_rden)
		user_r_mem_8_data <= demoarray[user_mem_8_addr];	  
end

assign user_r_mem_8_empty = 0;
assign user_r_mem_8_eof   = 0;
assign user_w_mem_8_full  = 0;

// 32-bit loopback
fifo_32x512 fifo_32 (
	.clk(bus_clk),
	.srst(!user_w_write_32_open && !user_r_read_32_open),
	.din(user_w_write_32_data),
	.wr_en(user_w_write_32_wren),
	.rd_en(user_r_read_32_rden),
	.dout(user_r_read_32_data),
	.full(user_w_write_32_full),
	.empty(user_r_read_32_empty)
);

assign user_r_read_32_eof = 0;

// 8-bit loopback
fifo_8x2048 fifo_8 (
	.clk(bus_clk),
	.srst(!user_w_write_8_open && !user_r_read_8_open),
	.din(user_w_write_8_data),
	.wr_en(user_w_write_8_wren),
	.rd_en(user_r_read_8_rden),
	.dout(user_r_read_8_data),
	.full(user_w_write_8_full),
	.empty(user_r_read_8_empty)
);

assign user_r_read_8_eof = 0;
	
endmodule
