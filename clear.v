module clearCards(reset_n,clk,in,x0, y0, x, y, colour, next);
	input reset_n, clk,in;
	input [7:0] x0;
	input [6:0] y0;
	output [7:0] x;
	output [6:0] y;
	output[2:0] colour;
	output reg next;
	
	assign colour = 3'b000;
	addtoxy xy(.x(x0), .y(y0),.in(in), .reset_n(reset_n) ,.clk(clk), .x_out(x), .y_out(y));

	always @(*)
	begin
			if(x == (x0 + 15) && y == (y0 + 15)) 
				next <= 1;
			if(x == (x0 + 3) && y == (y0 + 3)) 
				next <= 0;
	end
	
	always @(*)
	begin
		if (!reset_n)
			next = 0;
	end
endmodule

module addtoxy(x, y, in, reset_n, clk, x_out, y_out);
	input [7:0] x;
	input [6:0] y;
	input reset_n, in;
	input clk;
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	
	reg[7:0] count;
	
	always @(posedge clk)
	begin
		count <= count + 1;
	end
	
	always @(posedge in or negedge reset_n)begin
			x_out <= 0;
			y_out <= 0;
			count <= 0;
	end
	
	always @(*)
	begin
		if(in) begin
			x_out = x + count[3:0];
			y_out = y + count[7:4];
		end
	end
endmodule

