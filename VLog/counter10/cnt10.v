module counter10(
	input		rstn,
	input		clk,
	output[3:0]	cnt,
	output		cout
);

reg[3:0]	cnt_tmp;
always@( posedge clk or negedge rstn )
begin
	if(!rstn) begin
		cnt_tmp <= 4'b0;
	end
	else if (cnt_tmp == 4'd9) begin
		cnt_tmp <= 4'b000;
	end
	else begin
		cnt_tmp <= cnt_tmp + 1'b1;
	end
end

assign cout = (cnt_tmp == 4'd9);
assign cnt = cnt_tmp;

endmodule
