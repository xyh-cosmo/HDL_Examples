//////////////////////////////////////////////////////////////////////////////////
// Company: ALINX黑金
// Engineer: 老梅
// 
// Create Date: 2016/11/17 10:27:06
// Design Name: 
// Module Name: mem_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//	======================================================
//  2020/11/26:使用PL_KEY1-4来控制PL的工作过程.
//	KEY1:复位整个PL系统
//	KEY2:写一次burst数据
//	KEY3:读一次burst数据
//	KEY4:读写地址递增128 (AXI Master会mask掉低3位的地址)	
//	备注:起始地址设为0x02000_0000;所有KEY都是低电平有效,也就是说在不按下的时候都处于高电位,
//	因此它们所控制的这些"动作"都是在KEY的"下降沿"开始
//////////////////////////////////////////////////////////////////////////////////

module mem_test
#(
	parameter MEM_DATA_BITS = 64,
	parameter ADDR_BITS = 32
)
(
	input rst,                                 			/*复位*/
    input mem_clk,                               		/*接口时钟*/
    output reg rd_burst_req,                          	/*读请求*/
    output reg wr_burst_req,                         	/*写请求*/
    output reg[9:0] rd_burst_len,                     	/*读数据长度*/
    output reg[9:0] wr_burst_len,                     	/*写数据长度*/
    output reg[ADDR_BITS - 1:0] rd_burst_addr,        	/*读首地址*/
    output reg[ADDR_BITS - 1:0] wr_burst_addr,        	/*写首地址*/
    input rd_burst_data_valid,                  		/*读出数据有效*/
    input wr_burst_data_req,                    		/*写数据信号*/
    input[MEM_DATA_BITS - 1:0] rd_burst_data,   		/*读出的数据*/
    output[MEM_DATA_BITS - 1:0] wr_burst_data,    		/*写入的数据*/
    input rd_burst_finish,                      		/*读完成*/
    input wr_burst_finish,                      		/*写完成*/

	output [2:0] state_debug,		//	debug info
	input pl_key1,
	input pl_key2,
	input pl_key3,
	input pl_key4,
	
    output reg error
);

parameter IDLE 		= 3'd0;
parameter MEM_READ 	= 3'd1;
parameter MEM_WRITE = 3'd2;
parameter MEM_ADDR	= 3'd3;
parameter BURST_LEN = 128;

parameter INI_ADDR	= 32'b0;

reg[2:0] state;
assign state_debug = state;


reg[7:0] wr_cnt;
reg[MEM_DATA_BITS - 1:0] wr_burst_data_reg;
assign wr_burst_data = wr_burst_data_reg;
reg[7:0] rd_cnt;
reg[31:0] write_read_len;
//assign error = (state == MEM_READ) && rd_burst_data_valid && (rd_burst_data != {(MEM_DATA_BITS/8){rd_cnt}});


// 判断读回的数据是否与之前写入的数据相同
 always@(posedge mem_clk or posedge rst)
 begin
 	if(rst)
 		error <= 1'b0;
 //	else if(state == MEM_READ && rd_burst_data_valid && rd_burst_data != {(MEM_DATA_BITS/8){rd_cnt}})
// 	else if(state == MEM_READ && rd_burst_data_valid && rd_burst_data != wr_burst_data)
// 		error <= 1'b1;
 end

// always@(posedge mem_clk or posedge rst)
// begin
// 	if(rst)
// 	begin
// 		wr_burst_data_reg <= {MEM_DATA_BITS{1'b0}};
// 		wr_cnt <= 8'd0;
// 	end
// 	else if(state == MEM_WRITE)
// 	begin
// 		if(wr_burst_data_req)
// 			begin
// 				wr_burst_data_reg <= wr_burst_addr;
// 				wr_cnt <= wr_cnt + 8'd1;
// 			end
// 		else if(wr_burst_finish)
// 			wr_cnt <= 8'd0;
// 	end
// end

 //	=== 此处处理读数据过程 ===
// always@(posedge mem_clk or posedge rst)
// begin
// 	if(rst)
// 	begin
// 		rd_cnt <= 8'd0;
// 	end
// 	else if(state == MEM_READ)
// 	begin
// 		if(rd_burst_data_valid)
// 			begin
// 				rd_cnt <= rd_cnt + 8'd1;
// 			end
// 		else if(rd_burst_finish)
// 			rd_cnt <= 8'd0;
// 	end
// 	else

// 		rd_cnt <= 8'd0;
// end

always@(posedge mem_clk or posedge rst )
begin
	if( rst ) begin
		state <= IDLE;
		wr_burst_req <= 1'b0;
		rd_burst_req <= 1'b0;
		rd_burst_len <= BURST_LEN;
		wr_burst_len <= 128;
		// rd_burst_addr <= 'h2000000;
		// wr_burst_addr <= 'h2000000;
		rd_burst_addr <= INI_ADDR;
		wr_burst_addr <= INI_ADDR;
		write_read_len <= 32'd0;	// 这个测试例子中没有用到这个参数
		wr_burst_data_reg <= {MEM_DATA_BITS{1'b0}};
		error <= 1'b0;
	end
end

////////////////////////////////////////////////////////
//	根据PL按键来确定工作状态
////////////////////////////////////////////////////////
always@(posedge mem_clk or negedge pl_key1 or negedge pl_key2 or negedge pl_key3 or negedge pl_key4)
begin
	if( !pl_key1 ) begin
		state <= IDLE;
		wr_burst_req <= 1'b0;
		rd_burst_req <= 1'b0;
		rd_burst_len <= BURST_LEN;
		wr_burst_len <= BURST_LEN;
		rd_burst_addr <= INI_ADDR;
		wr_burst_addr <= INI_ADDR;
		write_read_len <= 32'd0;
		wr_burst_data_reg <= {MEM_DATA_BITS{1'b0}};
		error <= 1'b0;
	end
	
	 if(!pl_key2) begin
	 	state <= MEM_WRITE;
	 	wr_burst_req <= 1'b1;
	 	rd_burst_req <= 1'b0;
	 end
	
	 if(!pl_key3) begin
	 	state <= MEM_READ;
	 	rd_burst_addr <= wr_burst_addr;
	 	wr_burst_req <= 1'b0;
	 	rd_burst_req <= 1'b1;
	 end
	
	 if(!pl_key4) begin
	 	state <= MEM_ADDR;
//	 	wr_burst_addr <= wr_burst_addr + BURST_LEN;
//	 	wr_burst_addr <= wr_burst_addr + 1;
	 end
end


//	PL_KEY2:写数据,将地址作为数据写入
always@(posedge mem_clk)
begin
	if( (state == MEM_WRITE) && wr_burst_data_req )
	begin
//		wr_burst_req <= 1'b1;
		wr_burst_len <= BURST_LEN;
		rd_burst_req <= 1'b0;
//		wr_burst_data_reg <= {(MEM_DATA_BITS/8){wr_cnt}};
		wr_burst_data_reg <= {(2){wr_burst_addr}};
	end
end

//	PL_KEY3:读数据,将之前写入的数据读出
always@(posedge mem_clk)
begin
	if( state == MEM_READ && rd_burst_data_valid )
	begin
		wr_burst_req <= 1'b0;
//		rd_burst_req <= 1'b1;
		if( rd_burst_data != wr_burst_data )	// 判断读回的数与之前的数是否相同(这里wr_burst_data由tb文件中传入）
			error <= 1'b1;
	end
end

//	PL_KEY4:地址递增（这里假设1位、1位地递增）
always@(posedge pl_key4 )
begin
	wr_burst_addr <= wr_burst_addr + 1;
end

endmodule
