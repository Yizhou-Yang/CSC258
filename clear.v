module clearCards(reset_n,clk,in,x0, y0, x, y, colour, next);
	input reset_n, clk,in;
	input [7:0] x0;
	input [6:0] y0;
	output [7:0] x;
	output [6:0] y;
	output[2:0] colour;
	output reg next;
	//
	wire [7:0] count;
	//
	assign colour = 3'b000;
	

	add a1(.x(x0), .y(y0),.in(in), .reset_n(reset_n) ,.clk(clk), .x_out(x), .y_out(y),.count(count));

	always @(*)
	begin
			if(!reset_n)
					next <= 0;
			else if(x == (x0 + 8'd15) && y == (y0 + 7'd15)) begin
				if(count == 0)
					next <= 1;
			end
			else if(count == 8'd3)  
					next <= 0;
	end
endmodule

module add(x, y, in, reset_n, clk, x_out, y_out,count);
	input [7:0] x;
	input [6:0] y;
	input reset_n, in;
	input clk;
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	//
	output reg[7:0] count;
	//
	reg lock;
	
	always @(posedge clk or negedge in)begin
		if((!reset_n)||(!in))begin
			count <= 0;
			lock <= 0;
		end
		else if(in&&lock ==0)
			lock <= 1;
		else if(in&&lock == 1)
			count <= count + 1;
	end
	
	always @(*)
	begin
		if (!reset_n)begin
			x_out = 0;
			y_out = 0;
		end
		else if(in) begin
			x_out = x + count[3:0];
			y_out = y + count[7:4];
		end
	end
endmodule

