//采用SPI模式0：上升沿采样数据，下降沿切换数据
module SPI_MasterToSlave(CLK_50M,RST_N,SCK,CS,MOSI);
    input CLK_50M;
    input RST_N;
    output reg SCK;
    output reg CS;
    output reg MOSI;
reg[7:0] Send_Data = 8'hA5;//所要发送的数据
/*构造状态机*/
reg[3:0] Data_State = 4'd0;
parameter D7_State = 4'd0;//发送最高位数据-状态
parameter D6_State = 4'd2;
parameter D5_State = 4'd4;
parameter D4_State = 4'd6;
parameter D3_State = 4'd8;
parameter D2_State = 4'd10;
parameter D1_State = 4'd12;
parameter D0_State = 4'd14;//发送最低位数据-状态
always@(posedge CLK_50M or negedge RST_N)
begin
    if(RST_N == 0)//复位
    begin
        SCK <= 1'b0;    //SCK初始电平为低
        CS <= 1'b1;     //CS初始电平为高
        MOSI <= 1'b0;   //MOSI初始电平为低
    end
    else//产生SPI时序
    begin
       CS <= 0;//CS拉低准备数据传输
       case(Data_State)
       4'd1,4'd3,4'd5,4'd7,4'd9,4'd11,4'd13,4'd15://每次放置数据完毕后 在此拉高时钟线，便于下次的下降沿产生
       begin
          SCK <= 1'b1;//准备在下降沿放置数据，提前将SCK拉高
          Data_State <= Data_State + 4'd1;//切换为数据放置状态(每发完1bit数据进入此一次，将时钟线拉高)
       end
        D7_State://第7位数据发送状态
        begin
            MOSI <= Send_Data[7];//D7数据
            SCK <= 1'b0;//在下降沿放置数据
            Data_State <= Data_State + 4'd1;//切换状态
        end
        D6_State://第6位数据发送状态
        begin
             MOSI <= Send_Data[6];//D6数据
             SCK <= 1'b0;//在下降沿放置数据
             Data_State <= Data_State + 4'd1;//切换状态
        end
        D5_State://第5位数据发送状态
        begin
             MOSI <= Send_Data[5];//D5数据
             SCK <= 1'b0;//在下降沿放置数据
             Data_State <= Data_State + 4'd1;//切换状态
        end
        D4_State://第4位数据发送状态
        begin
             MOSI <= Send_Data[4];//D4数据
             SCK <= 1'b0;//在下降沿放置数据
             Data_State <= Data_State + 4'd1;//切换状态
        end
        D3_State://第3位数据发送状态
        begin
             MOSI <= Send_Data[3];//D3数据
             SCK <= 1'b0;//在下降沿放置数据
             Data_State <= Data_State + 4'd1;//切换状态
        end
        D2_State://第2位数据发送状态
        begin
             MOSI <= Send_Data[2];//D2数据
             SCK <= 1'b0;//在下降沿放置数据
             Data_State <= Data_State + 4'd1;//切换状态
        end
        D1_State://第1位数据发送状态
        begin
             MOSI <= Send_Data[1];//D1数据
             SCK <= 1'b0;//在下降沿放置数据
             Data_State <= Data_State + 4'd1;//切换状态
        end
        D0_State://第0位数据发送状态
        begin
             MOSI <= Send_Data[0];//D0数据
             SCK <= 1'b0;//在下降沿放置数据
             Data_State <= Data_State + 4'd1;//切换状态
        end
        default: Data_State <= D7_State;
         endcase
    end
end
/*链接从机模块*/
SlaveGetMaster u2
(
    .CLK_50M(CLK_50M),
    .RST_N(RST_N),
    .MOSI(MOSI),
    .CS(CS),
    .SCK(SCK)
);
endmodule

