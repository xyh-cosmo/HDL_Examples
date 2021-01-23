`timescale 1ns/1ps


module tb;

//localparam ADDR_BITS = 32;
//localparam MEM_DATA_BITS = 64;

reg rst;                           				/*复位*/
reg mem_clk;                           			/*接口时钟*/

wire rd_burst_req;                          	/*读请求*/
wire wr_burst_req;                         		/*写请求*/
wire[9:0] rd_burst_len;                     	/*读数据长度*/
wire[9:0] wr_burst_len;                     	/*写数据长度*/
wire[31:0] rd_burst_addr;        				/*读首地址*/
wire[31:0] wr_burst_addr;    					/*写首地址*/
reg rd_burst_data_valid;                  		/*读出数据有效*/
reg wr_burst_data_req;                    		/*写数据信号*/
reg[63:0] rd_burst_data;   						/*读出的数据*/
wire[63:0] wr_burst_data;    					/*写入的数据*/
reg rd_burst_finish;                      		/*读完成*/
reg wr_burst_finish;                      		/*写完成*/

reg pl_key1;
reg pl_key2;
reg pl_key3;
reg pl_key4;

wire [2:0] state;

wire error;

parameter IDLE = 3'd0;
parameter MEM_READ = 3'd1;
parameter MEM_WRITE  = 3'd2;
parameter BURST_LEN = 128;

//  =======================================================

mem_test m_test(
.rst(rst),
.mem_clk(mem_clk),
.rd_burst_req(rd_burst_req),
.wr_burst_req(wr_burst_req),
.rd_burst_len(rd_burst_len),
.wr_burst_len(wr_burst_len),
.rd_burst_addr(rd_burst_addr),
.wr_burst_addr(wr_burst_addr),
.rd_burst_data_valid(rd_burst_data_valid),
.wr_burst_data_req(wr_burst_data_req),
.rd_burst_data(rd_burst_data),
.wr_burst_data(wr_burst_data),
.rd_burst_finish(rd_burst_finish),
.wr_burst_finish(wr_burst_finish),
.state_debug(state),
.pl_key1(pl_key1),
.pl_key2(pl_key2),
.pl_key3(pl_key3),
.pl_key4(pl_key4),
.error(error)
);

//  =======================================================
//  initialized the status of the system
initial begin
    rst                 = 0;
    mem_clk             = 1;
    rd_burst_data_valid = 0;    // set to 1 as default
    wr_burst_data_req   = 0;
    rd_burst_data       <= 32'b0;
    rd_burst_finish     = 0;    // set to 1 as default
    wr_burst_finish     = 0;    // set to 1 as default

    pl_key1             = 1;
    pl_key2             = 1;
    pl_key3             = 1;
    pl_key4             = 1;
end

//  generate memory clock
always mem_clk = #1 ~mem_clk;

//  setup simulation time domain
//initial begin
//    #1000;
//    $finish;
//end

//  setup output file
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
end

//  trun simulation part:
integer i;

initial begin
	#5;
	rst = 1;
	#1;
	rst = 0;

    #5;
    pl_key1 <= 0;
    #2;
    pl_key1 <= 1;
    
    for( i=0; i<40; i=i+1 ) begin
		#5 pl_key2 <= 0;
		wr_burst_data_req <= 1;
		rd_burst_finish <= 0;
		wr_burst_finish <= 0;
		#2 pl_key2 <= 1;
		#2 wr_burst_data_req <= 0;
		
		#2 pl_key3 <= 0;
		rd_burst_data_valid <= 1;
		rd_burst_data <= {2{i}}; // mem_test中将地址作为数据写入ddr，首地址假设为0，且连续递增（这与实际情况不符，此处只是为了验证时序逻辑而做了简化）
		#2 pl_key3 <= 1;
		#2 rd_burst_data_valid <= 0;
		
		#10 pl_key4 <= 0;
		#2;
		pl_key4 <= 1;
		
    end

	#5;
    $finish;
end


endmodule
