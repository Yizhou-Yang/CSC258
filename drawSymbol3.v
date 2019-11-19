module drawSymbol3(clk, reset_n, in, x, y, xout, yout, colour, next);
	input clk, reset_n, in;
	input [7:0] x;
	input [6:0] y;
	output reg [7:0] xout;
	output reg [6:0] yout;
	output reg [2:0] colour;
	output next;
	
	always @(*)
	begin
		if(reset_n == 1'b0)
			colour = 3'b000;
		else
			colour = 3'b101;
	end
	
	wire [5:0] counter_out;
	counter3 c0(.in(in), .clock(clk), .clear_b(reset_n), .out(counter_out), .carryout(next));
	reg [3:0] xadd, yadd;
	always @(*)
	begin
		case (counter_out)
			6'b000001: begin
				xadd = 4'd1;
				yadd = 4'd1;
			end
			6'b000010: begin
				xadd = 4'd2;
				yadd = 4'd2;
			end
			6'b000011: begin
				xadd = 4'd3;
				yadd = 4'd3;
			end
			6'b000100: begin
				xadd = 4'd4;
				yadd = 4'd4;
			end
			6'b000101: begin
				xadd = 4'd5;
				yadd = 4'd5;
			end
			6'b000110: begin
				xadd = 4'd6;
				yadd = 4'd6;
			end
			6'b000111: begin
				xadd = 4'd7;
				yadd = 4'd7;
			end
			6'b001000: begin
				xadd = 4'd8;
				yadd = 4'd8;
			end
			6'b001001: begin
				xadd = 4'd9;
				yadd = 4'd9;
			end
			6'b001010: begin
				xadd = 4'd10;
				yadd = 4'd10;
			end
			6'b001011: begin
				xadd = 4'd11;
				yadd = 4'd11;
			end
			6'b001100: begin
				xadd = 4'd12;
				yadd = 4'd12;
			end
			6'b001101: begin
				xadd = 4'd13;
				yadd = 4'd13;
			end
			6'b001110: begin
				xadd = 4'd14;
				yadd = 4'd14;
			end
			6'b001111: begin
				xadd = 4'd15;
				yadd = 4'd15;
			end
			6'b010000: begin
				xadd = 4'd15;
				yadd = 4'd0;
			end
			6'b010001: begin
				xadd = 4'd14;
				yadd = 4'd1;
			end
			6'b010010: begin
				xadd = 4'd13;
				yadd = 4'd2;
			end
			6'b010011: begin
				xadd = 4'd12;
				yadd = 4'd3;
			end
			6'b010100: begin
				xadd = 4'd11;
				yadd = 4'd4;
			end
			6'b010101: begin
				xadd = 4'd10;
				yadd = 4'd5;
			end
			6'b010110: begin
				xadd = 4'd9;
				yadd = 4'd6;
			end
			6'b010111: begin
				xadd = 4'd8;
				yadd = 4'd7;
			end
			6'b011000: begin
				xadd = 4'd7;
				yadd = 4'd8;
			end
			6'b011001: begin
				xadd = 4'd6;
				yadd = 4'd9;
			end
			6'b011010: begin
				xadd = 4'd5;
				yadd = 4'd10;
			end
			6'b011011: begin
				xadd = 4'd4;
				yadd = 4'd11;
			end
			6'b011100: begin
				xadd = 4'd3;
				yadd = 4'd12;
			end
			6'b011101: begin
				xadd = 4'd2;
				yadd = 4'd13;
			end
			6'b011110: begin
				xadd = 4'd1;
				yadd = 4'd14;
			end
			6'b011111: begin
				xadd = 4'd0;
				yadd = 4'd15;
			end
			6'b100000: begin
				xadd = 4'd0;
				yadd = 4'd0;
			end
			default: begin
				xadd = 4'd0;
				yadd = 4'd0;
			end
		endcase
	end
	
	always @(posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)
		begin
			xout <= x;
			yout <= y;
		end
		else
		begin
			xout <= x + xadd;
			yout <= y + yadd;
		end
	end
	
endmodule

module counter3(in, clock, clear_b, out, carryout);
	input in, clock, clear_b;
	output [5:0] out;
	output reg carryout;
	
	wire in1, in2, in3,in4,in5;
	wire [5:0] q;
	
	assign in1 = in & q[0];
	assign in2 = in1 & q[1];
	assign in3 = in2 & q[2];
	assign in4 = in3 & q[3];
	assign in5 = in4 & q[4];
	
	flipflop2 ff0(.in(in), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[0]));
	flipflop2 ff1(.in(in1), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[1]));
	flipflop2 ff2(.in(in2), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[2]));
	flipflop2 ff3(.in(in3), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[3]));
	flipflop2 ff4(.in(in4), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[4]));
	flipflop2 ff5(.in(in5), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[5]));
	
	assign out = q[5:0];
	
	always @(*)
	begin
		if(q == 6'b110011)
			carryout = 1;
		else
			carryout = 0;
	end
endmodule
