module milestone1(CLOCK_50, reset_n);
	input CLOCK_50, reset_n;
	
	wire [7:0] x;
	wire [6:0] y;
	wire [2:0] colour;
	wire writeEn;
	
	drawCards(
			.reset_n(reset_n),
			.clk(CLOCK_50),
			.x(x),
			.y(y),
			.colour(colour),
			.writeEn(writeEn));
			
	
	
	drawSymbols ds0(
			.clk(CLOCK_50),
			.reset_n(reset_n), 
			.xout(x), 
			.yout(y),
			.colour(colour));
	
	VGAdraw vgadraw(
			.clk(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.writeEn(writeEn));
endmodule

module drawSymbols(clk, reset_n, xout, yout, colour);
	input clk, reset_n;
	output reg [7:0] xout;
	output reg [6:0] yout;
	output reg [2:0] colour;
	
	wire [7:0] x0, x1out, x2out, x3out;
	reg [7:0] x1in, x2in, x3in;
	wire [6:0] y0, y1out, y2out, y3out;
	reg [6:0] y1in, y2in, y3in;
	wire [2:0] colour1, colour2, colour3;
	reg in1, in2, in3;
	wire next1, next2, next3;
	assign x0 = 8'd50;
	assign y0 = 7'd30;
	
	reg [1:0] counter1, counter2, counter3; 
	wire [1:0] symbol;
	wire next;
	assign next = next1 || next2 || next3;
	randomGenerate2bits rg(.clk(next), .reset_n(reset_n), .rand(symbol));
	always @(*)
	begin
		case (symbol)
			2'b01: begin
				in1 = 1'b1;
				in2 = 1'b0;
				in3 = 1'b0;
				x1in = x0;
				y1in = y0;
				xout = x1out;
				yout = y1out;
				colour = colour1;
			end
			2'b10: begin
				in1 = 1'b0;
				in2 = 1'b1;
				in3 = 1'b0;
				x2in = x0;
				y2in = y0;
				xout = x2out;
				yout = y2out;
				colour = colour2;
			end
			2'b11: begin
				in1 = 1'b0;
				in2 = 1'b0;
				in3 = 1'b1;
				x3in = x0;
				y3in = y0;
				xout = x3out;
				yout = y3out;
				colour = colour3;
			end
		endcase
	end
	
	drawSymbol1 ds1(
			.clk(clk), 
			.reset_n(reset_n),
			.in(in1),
			.x(x1in),
			.y(y1in), 
			.xout(x1out), 
			.yout(y1out), 
			.colour(colour1),
			.next(next1));
			
	drawSymbol2 ds2(
			.clk(clk), 
			.reset_n(reset_n),
			.in(in2),
			.x(x2in),
			.y(y2in), 
			.xout(x2out), 
			.yout(y2out), 
			.colour(colour2),
			.next(next2));
	
	drawSymbol3 ds3(
			.clk(clk), 
			.reset_n(reset_n),
			.in(in3),
			.x(x3in),
			.y(y3in), 
			.xout(x3out), 
			.yout(y3out), 
			.colour(colour3),
			.next(next3));
endmodule

module datapathControl(reset_n, clk, x, y, colour, writeEn);
	input reset_n, clk;
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	output writeEn;
	
	wire go0, go1, go2, go3, go4, go5, go6, go7, go8, go9;
	wire [1:0] select;
	wire [7:0] xout;
	wire [6:0] yout;
	wire [3:0] state;
	wire writeEn1, writeEn2;
	wire next0;
	datapath dp(
			.reset_n(reset_n), 
			.clk(clk), 
			.select(select), 
			.xin(xout),
			.yin(yout),
			.state(state),
			.go0(go0), 
			.go1(go1), 
			.go2(go2), 
			.go3(go3), 
			.go4(go4), 
			.go5(go5), 
			.go6(go6), 
			.go7(go7), 
			.go8(go8), 
			.go9(go9), 
			.x(x), 
			.y(y), 
			.colour(colour), 
			.writeEn(writeEn1),
			.next2(next0));
	control control(
			.reset_n(reset_n), 
			.clk(clk), 
			.go0(go0), 
			.go1(go1), 
			.go2(go2), 
			.go3(go3), 
			.go4(go4), 
			.go5(go5), 
			.go6(go6), 
			.go7(go7), 
			.go8(go8), 
			.go9(go9), 
			.select(select), 
			.xout(xout),
			.yout(yout),
			.stateout(state),
			.writeEn(writeEn2));
	
endmodule

module datapath(reset_n, clk, select, xin, yin, state, go0, go1, go2, go3, go4, go5, go6, go7, go8, go9, x, y, colour, writeEn, next2);
	input reset_n, clk;
	input [1:0] select;
	input [3:0] state;
	input [7:0] xin;
	input [6:0] yin;
	output reg go0, go1, go2, go3, go4, go5, go6, go7, go8, go9;
	output reg [2:0] colour;
	output reg [7:0] x;
	output reg [6:0] y;
	output reg writeEn;
	output next2;
	
	//wire next0, 
	wire next0, next1, next3;
	wire [7:0] x0, x1, x2, x3;
	wire [6:0] y0, y1, y2, y3;
	wire [2:0] colour0, colour1, colour2, colour3;
	wire writeEn0, writeEn1, writeEn2, writeEn3;
	drawCards dc(.reset_n(reset_n), .clk(clk), .x(x0), .y(y0), .colour(colour0), .writeEn(writeEn0), .next(next0));
	drawSymbol1 ds1(.clk(clk), .reset_n(reset_n), .in(next0), .x(xin), .y(yin), .xout(x1), .yout(y1), .colour(colour1), .next(next1));
	drawSymbol1 ds2(.clk(clk), .reset_n(reset_n), .in(next0), .x(xin), .y(yin), .xout(x2), .yout(y2), .colour(colour2), .next(next2));
	drawSymbol1 ds3(.clk(clk), .reset_n(reset_n), .in(next0), .x(xin), .y(yin), .xout(x3), .yout(y3), .colour(colour3), .next(next3));
	
	always @(posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)
		begin
			colour = 3'b000;
			x = 8'b00000000;
			y = 7'b0000000;
			go0 = 0;
			go1 = 0;
			go2 = 0;
			go3 = 0;
			go4 = 0;
			go5 = 0;
			go6 = 0;
			go7 = 0;
			go8 = 0;
			go9 = 0;
			writeEn = 0;
		end
		else
		begin
			case (select)
			2'b00: begin
				x <= x0;
				y <= y0;
				colour <= colour0;
				if(next0 == 1)
					go0 <= next0;
				else
					go0 <= 0;
				end
			2'b01: begin
				x <= x1;
				y <= y1;
				colour <= colour1;
				if(state==4'b0001)
				begin
					if(next1 == 1)
						go1 <= next1;
				end
				if(state==4'b0010)
				begin
					if(next1 == 1)
						go2 <= next1;
				end
				if(state==4'b0011)
				begin
					if(next1 == 1)
						go3 <= next1;
				end
				if(state==4'b0100)
				begin
					if(next1 == 1)
						go4 <= next1;
				end
				if(state==4'b0101)
				begin
					if(next1 == 1)
						go5 <= next1;
				end
				if(state==4'b0110)
				begin
					if(next1 == 1)
						go6 <= next1;
				end
				if(state==4'b0111)
				begin
					if(next1 == 1)
						go7 <= next1;
				end
				if(state==4'b1000)
				begin
					if(next1 == 1)
						go8 <= next1;
				end
				if(state==4'b1001)
				begin
					if(next1 == 1)
						go9 <= next1;
				end
			end
			2'b10: begin
				x <= x2;
				y <= y2;
				colour <= colour2;
				if(state==4'b0001)
				begin
					if(next2 == 1)
						go1 <= next2;
				end
				if(state==4'b0010)
				begin
					if(next2 == 1)
						go2 <= next2;
				end
				if(state==4'b0011)
				begin
					if(next2 == 1)
						go3 <= next2;
				end
				if(state==4'b0100)
				begin
					if(next2 == 1)
						go4 <= next2;
				end
				if(state==4'b0101)
				begin
					if(next2 == 1)
						go5 <= next2;
				end
				if(state==4'b0110)
				begin
					if(next2 == 1)
						go6 <= next2;
				end
				if(state==4'b0111)
				begin
					if(next2 == 1)
						go7 <= next2;
				end
				if(state==4'b1000)
				begin
					if(next2 == 1)
						go8 <= next2;
				end
				if(state==4'b1001)
				begin
					if(next2 == 1)
						go9 <= next2;
				end
			end
			2'b11: begin
				x <= x3;
				y <= y3;
				colour <= colour3;
				if(state==4'b0001)
				begin
					if(next3 == 1)
						go1 <= next3;
				end
				if(state==4'b0010)
				begin
					if(next3 == 1)
						go2 <= next3;
				end
				if(state==4'b0011)
				begin
					if(next3 == 1)
						go3 <= next3;
				end
				if(state==4'b0100)
				begin
					if(next3 == 1)
						go4 <= next3;
				end
				if(state==4'b0101)
				begin
					if(next3 == 1)
						go5 <= next3;
				end
				if(state==4'b0110)
				begin
					if(next3 == 1)
						go6 <= next3;
				end
				if(state==4'b0111)
				begin
					if(next3 == 1)
						go7 <= next3;
				end
				if(state==4'b1000)
				begin
					if(next3 == 1)
						go8 <= next3;
				end
				if(state==4'b1001)
				begin
					if(next3 == 1)
						go9 <= next3;
				end
			end
			endcase
		end
	end
endmodule

module control(reset_n, clk, go0, go1, go2, go3, go4, go5, go6, go7, go8, go9, select, xout, yout, stateout, writeEn);
	input reset_n, clk, go0, go1, go2, go3, go4, go5, go6, go7, go8, go9;
	output reg [7:0] xout;
	output reg [6:0] yout;
	output reg [3:0] stateout;
	output reg [1:0] select;
	output reg writeEn;
	
	reg [3:0] current_state, next_state;
	localparam S_DRAWCARDS = 4'b0000,
				  S_DRAWSYMBOL1 = 4'b0001,
				  S_DRAWSYMBOL2 = 4'b0010,
				  S_DRAWSYMBOL3 = 4'b0011,
				  S_DRAWSYMBOL4 = 4'b0100,
				  S_DRAWSYMBOL5 = 4'b0101,
				  S_DRAWSYMBOL6 = 4'b0110,
				  S_DRAWSYMBOL7 = 4'b0111,
				  S_DRAWSYMBOL8 = 4'b1000,
				  S_DRAWSYMBOL9 = 4'b1001,
				  S_DONE = 4'b1010;
	always @(*)
	begin: state_table
		case(current_state)
			S_DRAWCARDS: next_state = go0 ? S_DRAWSYMBOL1 : S_DRAWCARDS;
			S_DRAWSYMBOL1: next_state = go1 ? S_DRAWSYMBOL2 : S_DRAWSYMBOL1;
			S_DRAWSYMBOL2: next_state = go2 ? S_DRAWSYMBOL3 : S_DRAWSYMBOL2;
			S_DRAWSYMBOL3: next_state = go3 ? S_DRAWSYMBOL4: S_DRAWSYMBOL3;
			S_DRAWSYMBOL4: next_state = go4 ? S_DRAWSYMBOL5: S_DRAWSYMBOL4;
			S_DRAWSYMBOL5: next_state = go5 ? S_DRAWSYMBOL6: S_DRAWSYMBOL5;
			S_DRAWSYMBOL6: next_state = go6 ? S_DRAWSYMBOL7: S_DRAWSYMBOL6;
			S_DRAWSYMBOL7: next_state = go7 ? S_DRAWSYMBOL8: S_DRAWSYMBOL7;
			S_DRAWSYMBOL8: next_state = go8 ? S_DRAWSYMBOL9: S_DRAWSYMBOL8;
			S_DRAWSYMBOL9: next_state = go9 ? S_DONE: S_DRAWSYMBOL9;
			S_DONE: next_state = S_DONE;
			default: next_state = S_DRAWCARDS;
		endcase
	end
	
//	reg gorandom;
//	wire [1:0] rand;
//	randomGenerate2bits rg0(.clk(clk), .go(gorandom), .reset_n(reset_n), .rand(rand));
//
//	reg [2:0] symbol;
//	always @(*)
//	begin
//		case (rand)
//		2'b00: symbol = 2'b01;
//		2'b01: symbol = 2'b10;
//		2'b10: symbol = 2'b11;
//		2'b11: symbol = 2'b11;
//		endcase
//	end
	
	always @(*)
	begin: signals
		case(current_state)
			S_DRAWCARDS:
			begin
				select = 2'b00;
//				gorandom = 0;
				xout <= 8'd0;
				yout <= 7'd0;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL1: 
			begin
				select = 2'b01;
//				gorandom = 1;
				xout <= 8'd50;
				yout <= 7'd30;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL2: 
			begin
				select = 2'b10;
//				gorandom = 1;
				xout <= 8'd70;
				yout <= 7'd30;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL3: 
			begin
				select = 2'b11;
//				gorandom = 1;
				xout <= 8'd90;
				yout <= 7'd30;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL4: 
			begin
				select = 2'b01;
//				gorandom = 1;
				xout <= 8'd50;
				yout <= 7'd50;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL5: 
			begin
				select = 2'b10;
//				gorandom = 1;
				xout <= 8'd70;
				yout <= 7'd50;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL6: 
			begin
				select = 2'b11;
//				gorandom = 1;
				xout <= 8'd90;
				yout <= 7'd50;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL7: 
			begin
				select = 2'b01;
//				gorandom = 1;
				xout <= 8'd50;
				yout <= 7'd70;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL8: 
			begin
				select = 2'b10;
//				gorandom = 1;
				xout <= 8'd70;
				yout <= 7'd70;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL9: 
			begin
				select = 2'b11;
//				gorandom = 1;
				xout <= 8'd90;
				yout <= 7'd70;
				writeEn = 1'b1;
			end
			default: begin
				select = 2'b00;
//				gorandom = 0;
				xout <= 8'd0;
				yout <= 7'd0;
				writeEn = 1'b0;
			end
		endcase
	end
	
	always @(posedge clk)
	begin
		if(reset_n == 1'b0)
		begin
			current_state <= S_DRAWCARDS;
			stateout <= S_DRAWCARDS;
		end
		else
		begin
			current_state <= next_state;
			stateout <= next_state;
		end
	end

endmodule

module randomGenerate2bits(clk, go, reset_n, rand);
	input clk, reset_n, go;
	output reg[1:0] rand;
	always @(posedge clk or negedge reset_n)
	begin
		if(!reset_n)
			rand <= 2'b11;
		
		else
		begin
			if(go == 1)
				rand <= $random;
			else
				rand <= 2'b11;
//				while(rand == 2'b11)
//					rand <= $random;
		end
	end
endmodule
