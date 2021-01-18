module add_top(
    input clk,
    input rst,
    output[3:0] out
);

reg[3:0] tmp;
// assign out[0] = tmp[0];
// assign out[1] = tmp[1];
// assign out[2] = tmp[2];
// assign out[3] = tmp[3];
assign out = tmp;

always@(posedge clk or negedge rst)
begin
  if(!rst)
  begin
    tmp <= 4'b0;
  end
end

always@(posedge clk)
begin
  if(!rst)
  begin
    tmp <= tmp + 1'b1;
  end
end

endmodule