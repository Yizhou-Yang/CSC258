module cancelCards(reset_n,clk,in,data_in, xout, yout, colour, next);
	input reset_n,clk,in;
	input [8:0] data_in;
	output reg[:0] xout;
	output reg[:0] yout;
	output reg[2:0] colour;
	output reg next;
	
	wire[2:0]data1,data2,data3;
	assign data1 = data_in[2:0];
	assign data2 = data_in[5:3];
	assign data3 = data_in[8:6];
		
	clearCards c1(.reset_n(reset_n),.clk(clk),.x0(x0), .y0(y0), .x(xout), .y(yout), .colour(colour), .next(next));

endmodule
