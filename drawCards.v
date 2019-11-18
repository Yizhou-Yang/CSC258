module drawCards(reset_n, clk, x, y, colour, writeEn, next);
	input reset_n, clk;
	output [7:0] x;
	output [6:0] y;
	output reg [2:0] colour;
	output reg writeEn;
//	output reg[1:0] next;
	output reg next;
	
	always @(*)
	begin
		if(reset_n == 1'b0)
			colour = 3'b000;
		else
			assign colour = 3'b111;
	end
	
//	wire [1:0] rand;
//	randomGenerate2bits(.clk(clk), .reset_n(reset_n), .rand(rand));

	wire [7:0] counter_out;
	wire counter_carryout;
	counter8bit counter0(.in(1'b1), .clock(clk), .clear_b(reset_n), .out(counter_out), .carryout(counter_carryout));
	reg [7:0] x0 = 8'd50;
	reg [6:0] y0 = 8'd30;
	addtoxy xy(.x(x0), .y(y0), .add(counter_out), .x_out(x), .y_out(y));

	always @(posedge clk)
	begin
		if(x == 8'd65 && y == 7'd45)
		begin
			x0 <= 8'd70;
			y0 <= 7'd30;
			writeEn <= 1;
			next <= 0;
		end
		if(x == 8'd85 && y == 7'd45)
		begin
			x0 <= 8'd90;
			y0 <= 7'd30;
			writeEn <= 1;
			next <= 0;
		end
		if(x == 8'd105 && y == 7'd45)
		begin
			x0 <= 8'd50;
			y0 <= 7'd50;
			writeEn <= 1;
			next <= 0;
		end
		
		if(x == 8'd65 && y == 7'd65)
		begin
			x0 <= 8'd70;
			y0 <= 7'd50;
			writeEn <= 1;
			next <= 0;
		end
		if(x == 8'd85 && y == 7'd65)
		begin
			x0 <= 8'd90;
			y0 <= 7'd50;
			writeEn <= 1;
			next <= 0;
		end
		if(x == 8'd105 && y == 7'd65)
		begin
			x0 <= 8'd50;
			y0 <= 7'd70;
			writeEn <= 1;
			next <= 0;
		end
		
		if(x == 8'd65 && y == 7'd85)
		begin
			x0 <= 8'd70;
			y0 <= 7'd70;
			writeEn <= 1;
			next <= 0;
		end
		if(x == 8'd85 && y == 7'd85)
		begin
			x0 <= 8'd90;
			y0 <= 7'd70;
			writeEn <= 1;
			next <= 0;
		end
		if(x == 8'd105 && y == 7'd85)
		begin
			x0 <= 8'd50;
			y0 <= 7'd30;
			writeEn <= 0;
//				next <= rand
			next <= 1;
		end
	end
endmodule

module addtoxy(x, y, add, x_out, y_out);
	input [7:0] x;
	input [6:0] y;
	input [7:0] add;
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	
	always @(*)
	begin
		if(x + add[3:0] > 8'd159)
			x_out = x;
		else
			x_out = x + add[3:0];
		if(x + add[7:4] > 7'd119)
			y_out = y;
		else
			y_out = y + add[7:4];
	end
endmodule

module counter8bit(in, clock, clear_b, out, carryout);
	input in, clock, clear_b;
	output [7:0] out;
	output carryout;
	
	wire in1, in2, in3,in4,in5,in6,in7,in8;
	wire [8:0] q;
	
	assign in1 = in & q[0];
	assign in2 = in1 & q[1];
	assign in3 = in2 & q[2];
	assign in4 = in3 & q[3];
	assign in5 = in4 & q[4];
	assign in6 = in5 & q[5];
	assign in7 = in6 & q[6];
	assign in8 = in7 & q[7];
	
	
	flipflop ff0(.in(in), .clock(clock), .reset_n(clear_b && in), .out(q[0]));
	flipflop ff1(.in(in1), .clock(clock), .reset_n(clear_b && in), .out(q[1]));
	flipflop ff2(.in(in2), .clock(clock), .reset_n(clear_b && in), .out(q[2]));
	flipflop ff3(.in(in3), .clock(clock), .reset_n(clear_b && in), .out(q[3]));
	flipflop ff4(.in(in4), .clock(clock), .reset_n(clear_b && in), .out(q[4]));
	flipflop ff5(.in(in5), .clock(clock), .reset_n(clear_b && in), .out(q[5]));
	flipflop ff6(.in(in6), .clock(clock), .reset_n(clear_b && in), .out(q[6]));
	flipflop ff7(.in(in7), .clock(clock), .reset_n(clear_b && in), .out(q[7]));
	flipflop ff8(.in(in8), .clock(clock), .reset_n(clear_b && in), .out(q[8]));
	
	assign out = q[7:0];
	assign carryout = q[8];
endmodule

module flipflop(in, clock, reset_n, out);
	input in, clock, reset_n;
	output reg out;
	
	always @(posedge clock or negedge reset_n)
	begin
		if(reset_n == 1'b0)
			out <= 0;
		else
			if(in == 1'b1)
				out <= ~out;
			else
				out <= out;
	end
endmodule
