module FSM(
	input sys_clk,
	input rst,	// active_high
	
	input wr_en,	// write enable
	input rd_en,	// read enable
	
	input key1,		// active_low
	input key2,		// active_low
	input key3,		// active_low
	input key4		// active_low
);

parameter IDLE		= 3'd1;
parameter MEM_WRITE	= 3'd2;
parameter MEM_READ	= 3'd3;
parameter MEM_ADDR	= 3'd4;

reg [7:0] addr;
reg [7:0] wr_cnt;
reg [7:0] rd_cnt;


reg [2:0] state;

reg key_state1 = 1'b0; 
reg key_state2 = 1'b0; 
reg key_state3 = 1'b0; 
reg key_state4 = 1'b0; 

reg key_state1_bk = 1'b0; 
reg key_state2_bk = 1'b0; 
reg key_state3_bk = 1'b0; 
reg key_state4_bk = 1'b0; 

//	判断按键状态：
always@( posedge key1 )
begin
	key_state1 <= ~key_state1;
end

always@( posedge key2 )
begin
	key_state2 <= ~key_state2;
end

always@( posedge key3 )
begin
	key_state3 <= ~key_state3;
end

//	key4按下后，地址后移4个字节（32bit）
always@( posedge key4 )
begin
	key_state4 <= ~key_state4;
end

always@( posedge sys_clk or posedge rst )
begin

	if(rst) 
		begin
			state 	<= IDLE;
			addr   	<= 8'd0;
			wr_cnt 	<= 8'd0;
			rd_cnt 	<= 8'd0;
		end
	else 
	begin
		case(state)
			IDLE:
			begin
				if( key_state1 != key_state1_bk )
					state <= IDLE;
				else if( key_state2 != key_state2_bk )
					state <= MEM_WRITE;
				else if( key_state3 != key_state3_bk )
					state <= MEM_READ;
				else if( key_state4 != key_state4_bk )
					state <= MEM_ADDR;
				else
					state <= IDLE;
			end
			
			MEM_WRITE: // 不管是否“写数据”成功，都会返回到IDLE状态
			begin
				if(wr_en) begin
					wr_cnt <= wr_cnt + 8'd1;
					key_state2_bk <= ~key_state2_bk;
				end
				state <= IDLE;
			end
			
			MEM_READ: // 不管是否“读数据”成功，都会返回到IDLE状态
			begin
				if(rd_en) begin
					rd_cnt <= rd_cnt + 8'd1;
					key_state3_bk <= ~key_state3_bk;
				end
				state <= IDLE;
			end
			
			MEM_ADDR:
			begin
				addr <= addr + 8'd4;
				state <= IDLE;
			end
			
//			default:
//			begin
//				begin
//					state <= IDLE;
//				end
//			end
		endcase
	end
	
	
end

endmodule
