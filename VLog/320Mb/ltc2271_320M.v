// 模拟从LTC2271以320Mb/s的速度采样，4通道（ch0...3)输入。
// 模块内部将串行输入的4个通道数据组合成32*4大小的dout作为输出

//`define _DEBUG_320M_
`include "defs.v"

module ltc2271_320M#(
parameter BUF_SIZE=128
)    
(
	input rst,
	input clk_sys,
	input clk_320m,
	input ch0,
	input ch1,
	input ch2,
	input ch3,
`ifdef _DEBUG_320M_
	output [BUF_SIZE-1:0] dout,
	output [4:0] debug_cnt,
	output debug_f_clk,
	output debug_p_clk,
	output debug_push
`else
	output [BUF_SIZE-1:0] dout
`endif
);

reg [4:0] cnt;
assign debug_cnt = cnt;

wire f_clk;
wire p_clk;

//	ch0
reg [15:0] px10;
reg [15:0] px20;

//	ch1
reg [15:0] px11;
reg [15:0] px21;

//	ch2
reg [15:0] px12;
reg [15:0] px22;

//	ch3
reg [15:0] px13;
reg [15:0] px23;

assign f_clk = ~(cnt[3]);
assign p_clk = cnt[4];

`ifdef _DEBUG_320M_
assign debug_f_clk = f_clk;
assign debug_p_clk = p_clk;
`endif

assign dout[127:112] = px10;
assign dout[111:96]  = px20;
assign dout[95:80]   = px11;
assign dout[79:64]   = px21;
assign dout[63:48]   = px12;
assign dout[47:32]   = px22;
assign dout[31:16]   = px13;
assign dout[15:0]    = px23;

//	RESET
always@( posedge clk_320m or posedge rst )
begin
	if(rst)
	begin
		cnt  <= 5'b0;

		px10 <= 16'b0;
		px11 <= 16'b0;
		px12 <= 16'b0;
		px13 <= 16'b0;
		px20 <= 16'b0;
		px21 <= 16'b0;
		px22 <= 16'b0;
		px23 <= 16'b0;
	end
end

	
//always@( posedge clk_320m or posedge rst or ch0 or ch1 or ch2 )
always@( posedge clk_320m or posedge rst)
begin
	if(!rst)
	begin
		if(!p_clk) begin// handle the first 16 bits
			px10 <= (px10 << 1) + {15'b0,ch0};
			px11 <= (px11 << 1) + {15'b0,ch1};
			px12 <= (px12 << 1) + {15'b0,ch2};
			px13 <= (px13 << 1) + {15'b0,ch3};
			cnt <= cnt + 5'b1;
		end
		else begin // handle the rest 16 bits
			px20 <= (px20 << 1) + {15'b0,ch0};
			px21 <= (px21 << 1) + {15'b0,ch1};
			px22 <= (px22 << 1) + {15'b0,ch2};
			px23 <= (px23 << 1) + {15'b0,ch3};
			cnt <= cnt + 5'b1;
		end
	end
end

//	using "case" gives same simulation results
//always@( posedge clk_320m or posedge rst )
//begin
//	if(!rst)
//	begin
//		case (p_clk) 
//			0:
//			begin
//				px10 <= (px10 << 1) + {15'b0,ch0};
//				px11 <= (px11 << 1) + {15'b0,ch1};
//				px12 <= (px12 << 1) + {15'b0,ch2};
//				px13 <= (px13 << 1) + {15'b0,ch3};
//				cnt <= cnt + 5'b1;
//			end
//			1:
//			begin
//				px20 <= (px20 << 1) + {15'b0,ch0};
//				px21 <= (px21 << 1) + {15'b0,ch1};
//				px22 <= (px22 << 1) + {15'b0,ch2};
//				px23 <= (px23 << 1) + {15'b0,ch3};
//				cnt <= cnt + 5'b1;
//			end
//		endcase
//	end
//end

endmodule
