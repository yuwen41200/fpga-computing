`timescale 10ns / 1ps

module xillydemo_tb;

reg bus_clk;
reg quiesce;
reg user_r_read_32_rden;
reg user_r_read_32_open;
reg user_w_write_32_wren;
reg [31:0] user_w_write_32_data;
reg user_w_write_32_open;
wire user_r_read_32_empty;
wire [31:0] user_r_read_32_data;
wire user_w_write_32_full;
integer i;

xillydemo uut (
	.bus_clk(bus_clk), 
	.quiesce(quiesce), 
	.user_r_read_32_rden(user_r_read_32_rden), 
	.user_r_read_32_empty(user_r_read_32_empty), 
	.user_r_read_32_data(user_r_read_32_data), 
	.user_r_read_32_open(user_r_read_32_open), 
	.user_w_write_32_wren(user_w_write_32_wren), 
	.user_w_write_32_full(user_w_write_32_full), 
	.user_w_write_32_data(user_w_write_32_data), 
	.user_w_write_32_open(user_w_write_32_open)
);

always #1 bus_clk = ~bus_clk;

initial begin
	bus_clk = 0;
	quiesce = 1;
	user_r_read_32_rden = 0;
	user_r_read_32_open = 0;
	user_w_write_32_wren = 0;
	user_w_write_32_data = 0;
	user_w_write_32_open = 0;
	#10;
	quiesce = 0;
	user_r_read_32_open = 1;
	user_w_write_32_open = 1;
	#10;
	user_r_read_32_rden = 1;
	user_w_write_32_wren = 1;
	for (i = 0; i < 2048; i = i + 1) begin
		user_w_write_32_data = i;
		#2;
	end
	$finish;
end

endmodule
