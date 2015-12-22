module kernel (
	input clk,
	input [15:0] in_data,
	input in_valid,
	output [15:0] out_data,
	output reg out_valid
);

reg [10:0] counter;
reg [15:0] result;

assign out_data = result;

always @(posedge clk) begin
	if (in_valid && counter == 0) begin
		result <= in_data;
		counter <= counter + 1;
		out_valid <= 0;
	end
	else if (in_valid && counter < 1025) begin
		result <= result + (result >> 3);
		counter <= counter + 1;
		out_valid <= 0;
	end
	else if (in_valid && counter == 1025) begin
		out_valid <= 1;
	end
	else if (~in_valid) begin
		counter <= 0;
		out_valid <= 0;
	end
end

endmodule
