`timescale 1ns/1ps

module test_fsm;

reg sys_clk;
reg rst;		// active_high

reg wr_en;	// write enable
reg rd_en;	// read enable

reg key1;		// active_low
reg key2;		// active_low
reg key3;		// active_low
reg key4;		// active_low

integer i;

FSM fsm(
	.sys_clk(sys_clk),
	.rst(rst),
	.wr_en(wr_en),
	.rd_en(rd_en),
	.key1(key1),
	.key2(key2),
	.key3(key3),
	.key4(key4)
);

//	initial
initial begin
	sys_clk = 0;
	rst		= 0;
	wr_en	= 0;
	rd_en	= 0;
	key1	= 1;
	key2	= 1;
	key3	= 1;
	key4	= 1;
end

//	simulation output settings
initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0,test_fsm);
end

//	clock
always sys_clk = #1 ~sys_clk;


//	Real test part;

initial begin
	#5;
	
	rst <= 1;
	#1;
	rst <= 0;
	
	#5;
	key1 <= 0;
	#1;
	key1 <= 1;
	#4;
	
	#5;
	key2 <= 0;
	#1;
	key2 <= 1;
	#4;
	
	#5;
	key3 <= 0;
	#1;
	key3 <= 1;
	#4;
	
	#5;
	key4 <= 0;
	#1;
	key4 <= 1;
	#4;
	
	rst <= 1;
	#1;
	rst <= 0;
	
	wr_en <= 1;
	rd_en <= 1;

	
	for( i=0; i<20; i=i+1)
		begin
			
//			if( i>5 && i <= 10 ) begin
//				wr_en <= 0;
//				rd_en <= 1;
//			end
			
//			if( i>10 ) begin
//				wr_en <= 1;
//				rd_en <= 0;
//			end
		
			key1 <= 0;
			#1;
			key1 <= 1;
			#4;
			
			key2 <= 0;
			#1;
			key2 <= 1;
			#4;
			
			key3 <= 0;
			#1;
			key3 <= 1;
			#4;
			
			key4 <= 0;
			#1;
			key4 <= 1;
			#4;
		end
	
	
	$finish;

end

endmodule
