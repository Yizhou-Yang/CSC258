module milestone1(CLOCK_50, reset_n);
	input CLOCK_50, reset_n;
	
	wire [7:0] x;
	wire [6:0] y;
	wire [2:0] colour;
	wire writeEn1,writeEn2,writeEn3;
	wire [1:0] next;
	drawCards(
			.reset_n(reset_n),
			.clk(CLOCK_50),
			
			.x(x),
			.y(y),
			.colour(colour),
			.writeEn(writeEn1),
			
			.next(next));
			
	drawSymbols ds0(
			.clk(CLOCK_50),
			.reset_n(reset_n), 
			.next(next),
			
			.xout(x), 
			.yout(y),
			.colour(colour),
			.writeEn(writeEn2),
			.out(next)
			);
	
	assign writeEn3 = writeEn1 || writeEn2;
	VGAdraw vgadraw(
			.clk(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.writeEn(writeEn3));
endmodule

module datapathControl(reset_n, clk, x, y, colour, writeEn);
	input reset_n, clk;
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	output writeEn;
	
	wire [7:0] xin;
	wire [6:0] yin;
	wire [1:0] select;
	wire go0, go1;
	datapath dp(
			.reset_n(reset_n), 
			.clk(clk), 
			.select(select), 
			.xin(xin), 
			.yin(yin), 
			.go0(go0), 
			.go1(go1), 
			.x(x), 
			.y(y), 
			.colour(colour));
			
	control ctr(
			.reset_n(reset_n), 
			.clk(clk), 
			.go0(go0), 
			.go1(go1), 
			.select(select), 
			.xout(xin), 
			.yout(yin), 
			.writeEn(writeEn));
	
endmodule

module datapath(reset_n, clk, select, xin, yin, go0, go1, x, y, colour);
	input reset_n, clk;
	input [1:0] select;
	input [7:0] xin;
	input [6:0] yin;
	output reg go0, go1;
	output reg [2:0] colour;
	output reg [7:0] x;
	output reg [6:0] y;
	
	wire next0, next1, next2, next3;
	wire [7:0] x0, x1, x2, x3;
	wire [6:0] y0, y1, y2, y3;
	wire [2:0] colour0, colour1, colour2, colour3;
	wire writeEn0, writeEn1, writeEn2, writeEn3;
	drawCards dc(.reset_n(reset_n), .clk(clk), .x(x0), .y(y0), .colour(colour0), .writeEn(writeEn0), .next(next0));
	drawSymbol1 ds1(.clk(clk), .reset_n(reset_n), .in(next0), .x(xin), .y(yin), .xout(x1), .yout(y1), .colour(colour1), .next(next1));
	drawSymbol2 ds2(.clk(clk), .reset_n(reset_n), .in(next0), .x(xin), .y(yin), .xout(x2), .yout(y2), .colour(colour2), .next(next2));
	drawSymbol3 ds3(.clk(clk), .reset_n(reset_n), .in(next0), .x(xin), .y(yin), .xout(x3), .yout(y3), .colour(colour3), .next(next3));
	
	always @(posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)
		begin
			colour = 3'b000;
			x = 8'b00000000;
			y = 7'b0000000;
			go0 = 0;
			go1 = 0;
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
				if(next1 == 1)
					go1 <= next1;
				else
					go1 <= 0;
			end
			2'b10: begin
				x <= x2;
				y <= y2;
				colour <= colour2;
				if(next2 == 1)
					go1 <= next2;
				else
					go1 <= 0;
			end
			2'b11: begin
				x <= x3;
				y <= y3;
				colour <= colour3;
				if(next3 == 1)
					go1 <= next3;
				else
					go1 <= 0;
			end
			endcase
		end
	end
endmodule

module control(reset_n, clk, go0, go1, select, xout, yout, writeEn);
	input reset_n, clk, go0, go1;
	output reg [7:0] xout;
	output reg [6:0] yout;
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
			S_DRAWSYMBOL2: next_state = go1 ? S_DRAWSYMBOL3 : S_DRAWSYMBOL2;
			S_DRAWSYMBOL3: next_state = go1 ? S_DRAWSYMBOL4: S_DRAWSYMBOL3;
			S_DRAWSYMBOL4: next_state = go1 ? S_DRAWSYMBOL5: S_DRAWSYMBOL4;
			S_DRAWSYMBOL5: next_state = go1 ? S_DRAWSYMBOL6: S_DRAWSYMBOL5;
			S_DRAWSYMBOL6: next_state = go1 ? S_DRAWSYMBOL7: S_DRAWSYMBOL6;
			S_DRAWSYMBOL7: next_state = go1 ? S_DRAWSYMBOL8: S_DRAWSYMBOL7;
			S_DRAWSYMBOL8: next_state = go1 ? S_DRAWSYMBOL9: S_DRAWSYMBOL8;
			S_DRAWSYMBOL9: next_state = go1 ? S_DONE: S_DRAWSYMBOL9;
			S_DONE: next_state = S_DONE;
			default: next_state = S_DRAWCARDS;
		endcase
	end
	
	always @(*)
	begin: signals
		case(current_state)
			S_DRAWCARDS:
			begin
				select = 2'b00;
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
			current_state <= S_DRAWCARDS;
		else
			current_state <= next_state;
	end

endmodule

module randomGenerate2bits(clk, reset_n, rand);
	input clk,reset_n;
	output reg[1:0] rand;
	always @(posedge clk or negedge reset_n)
	begin
		if(!reset_n)
			rand <= 2'd0;
		
		else
		begin
			rand = $random;
			while(rand == 2'b11)
				rand = $random;
		end
	end
endmodule
