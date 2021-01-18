module top(
	input [7:0] data,
	input [5:0] addr,
	input wr,
	input clk,
	output [7:0] q
);

reg [7:0] ram[63:0];	// declare ram
reg [5:0] addr_reg;		// addr register

always@( posedge clk )
begin
	if (wr)
		ram[addr] <= data;
		addr_reg <= addr;
end

	assign q = ram[addr_reg];	// read data
// end
endmodule
