module drawScore(clk, reset_n, in, x, y, xout, yout, colour, next);
	input clk, reset_n;
	output reg [7:0] xout;
	output reg [6:0] yout;
	output reg [2:0] colour;
	output next;
	
	wire finish;
	reg[1:0] rand;
	
	always @(*)
	begin
		if(reset_n == 1'b0)
			colour = 3'b000;
		else
			colour = 3'b111;
	end
	wire [5:0] counter_out;
	counter1 c0(.in(in), .clock(clk), .clear_b(reset_n), .out(counter_out), .carryout(next));
	reg [3:0] xadd, yadd;
	always @(*)
	begin
		case (counter_out)
			7'b0000001: begin
				xadd = 4'd0;
				yadd = 4'd2;
			end
			7'b0000010: begin
				xadd = 4'd0;
				yadd = 4'd3;
			end
			7'b0000011: begin
				xadd = 4'd0;
				yadd = 4'd6;
			end
			7'b0000100: begin
				xadd = 4'd1;
				yadd = 4'd1;
			end
			7'b0000101: begin
				xadd = 4'd1;
				yadd = 4'd4;
			end
			7'b0000110: begin
				xadd = 4'd1;
				yadd = 4'd7;
			end
			7'b0000111: begin
				xadd = 4'd2;
				yadd = 4'd1;
			end
			7'b0001000: begin
				xadd = 4'd2;
				yadd = 4'd4;
			end
			7'b0001001: begin
				xadd = 4'd2;
				yadd = 4'd7;
			end
			7'b0001010: begin
				xadd = 4'd3;
				yadd = 4'd1;
			end
			7'b0001011: begin
				xadd = 4'd3;
				yadd = 4'd4;
			end
			7'b0001100: begin
				xadd = 4'd3;
				yadd = 4'd7;
			end
			7'b0001101: begin
				xadd = 4'd4;
				yadd = 4'd2;
			end
			7'b0001110: begin
				xadd = 4'd4;
				yadd = 4'd5;
			end
			7'b0001111: begin
				xadd = 4'd4;
				yadd = 4'd6;
			end
			7'b0010000: begin
				xadd = 4'd6;
				yadd = 4'd2;
			end
			7'b0010001: begin
				xadd = 4'd6;
				yadd = 4'd3;
			end
			7'b0010010: begin
				xadd = 4'd6;
				yadd = 4'd4;
			end
			7'b0010011: begin
				xadd = 4'd6;
				yadd = 4'd5;
			end
			7'b0010100: begin
				xadd = 4'd6;
				yadd = 4'd6;
			end
			7'b0010101: begin
				xadd = 4'd7;
				yadd = 4'd1;
			end
			7'b0010110: begin
				xadd = 4'd7;
				yadd = 4'd7;
			end
			7'b0010111: begin
				xadd = 4'd8;
				yadd = 4'd1;
			end
			7'b0011000: begin
				xadd = 4'd8;
				yadd = 4'd7;
			end
			7'b0011001: begin
				xadd = 4'd8;
				yadd = 4'd1;
			end
			7'b0011010: begin
				xadd = 4'd8;
				yadd = 4'd7;
			end
			7'b0011011: begin
				xadd = 4'd10;
				yadd = 4'd2;
			end
			7'b0011100: begin
				xadd = 4'd10;
				yadd = 4'd6;
			end
			7'b0011101: begin
				xadd = 4'd12;
				yadd = 4'd2;
			end
			7'b0011110: begin
				xadd = 4'd12;
				yadd = 4'd3;
			end
			7'b0011111: begin
				xadd = 4'd12;
				yadd = 4'd4;
			end
			7'b0100000: begin
				xadd = 4'd12;
				yadd = 4'd5;
			end
			7'b0100001: begin
				xadd = 4'd12;
				yadd = 4'd6;
			end
			7'b0100010: begin
				xadd = 4'd13;
				yadd = 4'd1;
			end
			7'b0100011: begin
				xadd = 4'd13;
				yadd = 4'd7;
			end
			7'b0100100: begin
				xadd = 4'd14;
				yadd = 4'd1;
			end
			7'b0100101: begin
				xadd = 4'd14;
				yadd = 4'd7;
			end
			7'b0100110: begin
				xadd = 4'd15;
				yadd = 4'd1;
			end
			7'b0100111: begin
				xadd = 4'd15;
				yadd = 4'd7;
			end
			7'b0101000: begin
				xadd = 4'd16;
				yadd = 4'd2;
			end
			7'b0101001: begin
				xadd = 4'd16;
				yadd = 4'd3;
			end
			7'b0101010: begin
				xadd = 4'd16;
				yadd = 4'd4;
			end
			7'b0101011: begin
				xadd = 4'd16;
				yadd = 4'd5;
			end
			7'b0101100: begin
				xadd = 4'd16;
				yadd = 4'd6;
			end
			7'b0101101: begin
				xadd = 4'd18;
				yadd = 4'd1;
			end
			7'b0101110: begin
				xadd = 4'd18;
				yadd = 4'd2;
			end
			7'b0101111: begin
				xadd = 4'd18;
				yadd = 4'd3;
			end
			7'b0110000: begin
				xadd = 4'd18;
				yadd = 4'd4;
			end
			7'b0110001: begin
				xadd = 4'd18;
				yadd = 4'd5;
			end
			7'b0110010: begin
				xadd = 4'd18;
				yadd = 4'd6;
			end
			7'b0110011: begin
				xadd = 4'd18;
				yadd = 4'd7;
			end
			7'b0110100: begin
				xadd = 4'd19;
				yadd = 4'd1;
			end
			7'b0110101: begin
				xadd = 4'd19;
				yadd = 4'd4;
			end
			7'b0110110: begin
				xadd = 4'd20;
				yadd = 4'd1;
			end
			7'b0110111: begin
				xadd = 4'd20;
				yadd = 4'd4;
			end
			7'b0111000: begin
				xadd = 4'd20;
				yadd = 4'd5;
			end
			7'b0111001: begin
				xadd = 4'd21;
				yadd = 4'd1;
			end
			7'b0111010: begin
				xadd = 4'd21;
				yadd = 4'd4;
			end
			7'b0111011: begin
				xadd = 4'd21;
				yadd = 4'd6;
			end
			7'b0111100: begin
				xadd = 4'd22;
				yadd = 4'd2;
			end
			7'b0111101: begin
				xadd = 4'd22;
				yadd = 4'd3;
			end
			7'b0111110: begin
				xadd = 4'd22;
				yadd = 4'd7;
			end
			7'b0111111: begin
				xadd = 4'd24;
				yadd = 4'd1;
			end
			7'b1000000: begin
				xadd = 4'd24;
				yadd = 4'd2;
			end
			7'b1000001: begin
				xadd = 4'd24;
				yadd = 4'd3;
			end
			7'b1000010: begin
				xadd = 4'd24;
				yadd = 4'd4;
			end
			7'b1000011: begin
				xadd = 4'd24;
				yadd = 4'd5;
			end
			7'b1000100: begin
				xadd = 4'd24;
				yadd = 4'd6;
			end
			7'b1000101: begin
				xadd = 4'd24;
				yadd = 4'd7;
			end
			7'b1000110: begin
				xadd = 4'd25;
				yadd = 4'd1;
			end
			7'b1000111: begin
				xadd = 4'd25;
				yadd = 4'd4;
			end
			7'b1001000: begin
				xadd = 4'd25;
				yadd = 4'd7;
			end
			7'b1001001: begin
				xadd = 4'd26;
				yadd = 4'd1;
			end
			7'b1001010: begin
				xadd = 4'd26;
				yadd = 4'd4;
			end
			7'b1001011: begin
				xadd = 4'd26;
				yadd = 4'd7;
			end
			7'b1001100: begin
				xadd = 4'd27
				yadd = 4'd1;
			end
			7'b1001101: begin
				xadd = 4'd27;
				yadd = 4'd4;
			end
			7'b1001110: begin
				xadd = 4'd27;
				yadd = 4'd7;
			end
			7'b1001111: begin
				xadd = 4'd28;
				yadd = 4'd1;
			end
			7'b1010000: begin
				xadd = 4'd28;
				yadd = 4'd7;
			end
			7'b1010001: begin
				xadd = 4'd30;
				yadd = 4'd3;
			end
			7'b1010010: begin
				xadd = 4'd30;
				yadd = 4'd5;
			end
			default: begin
				xadd = 4'd30;
				yadd = 4'd5;
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

module counter1(in, clock, clear_b, out, carryout);
	input in, clock, clear_b;
	output [6:0] out;
	output reg carryout;
	
	wire in1, in2, in3,in4,in5,in6;
	wire [7:0] q;
	
	assign in1 = in & q[0];
	assign in2 = in1 & q[1];
	assign in3 = in2 & q[2];
	assign in4 = in3 & q[3];
	assign in5 = in4 & q[4];
	assign in6 = in5 & q[5];
	
	flipflop2 ff0(.in(in), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[0]));
	flipflop2 ff1(.in(in1), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[1]));
	flipflop2 ff2(.in(in2), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[2]));
	flipflop2 ff3(.in(in3), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[3]));
	flipflop2 ff4(.in(in4), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[4]));
	flipflop2 ff5(.in(in5), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[5]));
	flipflop2 ff6(.in(in6), .clock(clock), .reset_n(clear_b && in), .finish(carryout), .out(q[6]));

	assign out = q[6:0];
	
	always @(*)
	begin
		if(q == 7'b1010011)
			carryout = 1;
		else
			carryout = 0;
	end

endmodule
