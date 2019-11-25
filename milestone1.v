module finalProject
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	
	datapathControl dc(
			.reset_n(KEY[0]),
			.clk(CLOCK_50), 
			.in(SW[0]),
			.x(x), 
			.y(y), 
			.colour(colour), 
			.writeEn(writeEn));

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
endmodule

module datapathControl(reset_n, clk, in, x, y, colour, writeEn);
	input reset_n, clk, in;
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	output writeEn;
	
	wire [7:0] xin;
	wire [6:0] yin;
	wire [2:0] select;
	wire go0, go1, go2;
	wire [1:0] rand;
	wire next1, next2, next3;
	wire [6:0] counter;
	wire [1:0] select_symbol1, select_symbol2, select_symbol3;
	wire correct;
	datapath dp(
			.reset_n(reset_n), 
			.clk(clk), 
			.in(in),
			.select(select), 
			.xin(xin), 
			.yin(yin), 
			.go0(go0), 
			.go1(go1),
			.go2(go2),
			.select_symbol1(select_symbol1),
			.select_symbol2(select_symbol2),
			.select_symbol3(select_symbol3),
			.x(x), 
			.y(y), 
			.colour(colour),
			.next1(next1),
			.next2(next2),
			.next3(next3),
			.correct(correct));
			
	wire [3:0] state;
	wire [17:0] random;
	assign random = 18'b000010010001011010;
	control ctr(
			.reset_n(reset_n), 
			.clk(clk),
			.go0(go0), 
			.go1(go1), 
			.go2(go2),
			.random(random),
			.select(select), 
			.xout(xin), 
			.yout(yin), 
			.writeEn(writeEn),
			.state(state));
	
endmodule

module datapath(reset_n, clk, in, select, select_symbol1, select_symbol2, select_symbol3, xin, yin, go0, go1, go2, x, y, colour, next1, next2, next3, correct);
	input reset_n, clk, in;
	input [3:0] select;
	input [1:0] select_symbol1, select_symbol2, select_symbol3;
	input [7:0] xin;
	input [6:0] yin;
	output reg go0, go1, go2;
	output reg [2:0] colour;
	output reg [7:0] x;
	output reg [6:0] y;
	output next1, next2, next3;
	output reg correct;

	wire next0, next4;
	wire [7:0] x0, x1, x2, x3, x4;
	wire [6:0] y0, y1, y2, y3, y4;
	wire [2:0] colour0, colour1, colour2, colour3, colour4;
	drawCards dc(.reset_n(reset_n), .clk(clk), .in(in), .x(x0), .y(y0), .colour(colour0), .writeEn(writeEn0), .next(next0));
	drawScore ds4(.clk(clk), .reset_n(reset_n), .in(go0), .xout(x4), .yout(y4), .colour(colour4), .next(next4));
	drawSymbol1 ds1(.clk(clk), .reset_n(reset_n), .in(go2), .x(xin), .y(yin), .xout(x1), .yout(y1), .colour(colour1), .next(next1));
	drawSymbol2 ds2(.clk(clk), .reset_n(reset_n), .in(go2), .x(xin), .y(yin), .xout(x2), .yout(y2), .colour(colour2), .next(next2));
	drawSymbol3 ds3(.clk(clk), .reset_n(reset_n), .in(go2), .x(xin), .y(yin), .xout(x3), .yout(y3), .colour(colour3), .next(next3));
	
	reg [1:0] selected_symbol;
	always @(posedge clk or negedge reset_n )
	begin
		if(reset_n == 1'b0)
		begin
			colour = 3'b000;
			x = 8'b00000000;
			y = 7'b0000000;
			go0 = 0;
			go1 = 0;
			go2 = 0;
		end
		else
		begin
			case (select)
			//0011-drawCards, 0000-drawSymbol1, 0001-drawSymbol2, 0010-drawSymbol3, 0100-drawScore
			//0101-select1, 0110-select2, 0111-select3, 1000-cancelCards, 1001-cancelSelections 
			4'b0011: begin
				x <= x0;
				y <= y0;
				colour <= colour0;
				if(next0 == 1)
					go0 <= next0;
				else
					go0 <= 0;
				end
			4'b0000: begin
				x <= x1;
				y <= y1;
				colour <= colour1;
				if(next1 == 1)
					go1 <= next1;
				else
					go1 <= 0;
			end
			4'b0001: begin
				x <= x2;
				y <= y2;
				colour <= colour2;
				if(next2 == 1)
					go1 <= next2;
				else
					go1 <= 0;
			end
			4'b0010: begin
				x <= x3;
				y <= y3;
				colour <= colour3;
				if(next3 == 1)
					go1 <= next3;
				else
					go1 <= 0;
			end
			4'b0100: begin
				x <= x4;
				y <= y4;
				colour <= colour4;
				if(next4 == 1)
					go2 <= next4;
				else
					go2 <= 0;
			end
			4'b0101: begin
				x <= 8'd0;
				y <= 8'd0;
				colour <= 3'b000;
				selected_symbol <= selected_symbol1;
				correct <= 1'b1;
			end
			4'b0110: begin
				x <= 8'd0;
				y <= 8'd0;
				colour <= 3'b000;
				if(selected_symbol == selected_symbol2)
					correct <= 1'b1;
				else
					correct <= 1'b0;
			end
			4'b0111: begin
				x <= 8'd0;
				y <= 8'd0;
				colour <= 3'b000;
				if(selected_symbol == selected_symbol3 && correct == 1'b1)
					correct <= 1'b1;
				else
					correct <= 1'b0;
			end
			endcase
		end
	end
endmodule

module control(reset_n, clk, go0, go1, go2, go3, correct, random, select, select_symbol1, select_symbol2, select_symbol3, xout, yout, writeEn, state);
	input reset_n, clk, go0, go1, go2, go3, correct;
	input [17:0] random;
	output reg [7:0] xout;
	output reg [6:0] yout;
	output reg [3:0] select;
	output reg [1:0] select_symbol1, select_symbol2, select_symbol3;
	output reg writeEn;
	output [3:0] state;
	
	reg [3:0] current_state, next_state;
	assign state = current_state;
	localparam S_DRAWCARDS = 4'b00000,
				  S_DRAWSYMBOL1 = 4'b00001,
				  S_DRAWSYMBOL2 = 4'b00010,
				  S_DRAWSYMBOL3 = 4'b00011,
				  S_DRAWSYMBOL4 = 4'b00100,
				  S_DRAWSYMBOL5 = 4'b00101,
				  S_DRAWSYMBOL6 = 4'b00110,
				  S_DRAWSYMBOL7 = 4'b00111,
				  S_DRAWSYMBOL8 = 4'b01000,
				  S_DRAWSYMBOL9 = 4'b01001,
				  S_DRAWSCORE = 4'b01010,
				  S_SELECT1 = 4'b01011;
				  S_SELECT2 = 4'b01100;
				  S_SELECT3 = 4'b01101;
				  S_DETERMINE1 = 4'b01110;
				  S_DETERMINE2 = 4'b01111;
				  S_DONE2 = 2'b10000;
	always @(*)
	begin: state_table
		case(current_state)
			S_DRAWCARDS: next_state = go0 ? S_DRAWSCORE : S_DRAWCARDS;
			S_DRAWSCORE: next_state = go2 ? S_DRAWSYMBOL1 : S_DRAWSCORE;
			S_DRAWSYMBOL1: next_state = go1 ? S_DRAWSYMBOL2 : S_DRAWSYMBOL1;
			S_DRAWSYMBOL2: next_state = go1 ? S_DRAWSYMBOL3 : S_DRAWSYMBOL2;
			S_DRAWSYMBOL3: next_state = go1 ? S_DRAWSYMBOL4 : S_DRAWSYMBOL3;
			S_DRAWSYMBOL4: next_state = go1 ? S_DRAWSYMBOL5 : S_DRAWSYMBOL4;
			S_DRAWSYMBOL5: next_state = go1 ? S_DRAWSYMBOL6 : S_DRAWSYMBOL5;
			S_DRAWSYMBOL6: next_state = go1 ? S_DRAWSYMBOL7 : S_DRAWSYMBOL6;
			S_DRAWSYMBOL7: next_state = go1 ? S_DRAWSYMBOL8 : S_DRAWSYMBOL7;
			S_DRAWSYMBOL8: next_state = go1 ? S_DRAWSYMBOL9 : S_DRAWSYMBOL8;
			S_DRAWSYMBOL9: next_state = go1 ? S_SELECT1: S_DRAWSYMBOL9;
			S_SELECT1: next_state = go3 ? S_SELECT2 : S_SELECT1;
			S_SELECT2: next_state = go3 ? S_SELECT3 : S_SELECT2;
			S_SELECT3: next_state = go3 ? S_DETERMINE1 : S_SELECT3;
			S_DETERMINE1: next_state = go4 ? S_DETERMINE2 : S_SELECT1;
			S_DETERMINE2: next_state = go5 ? S_DONE2 : S_DETERMINE2
			S_DONE2: next_state = S_DONE2;
			default: next_state = S_DRAWCARDS;
		endcase
	end
	
	always @(*)
	begin: signals
		case(current_state)
			S_DRAWCARDS:
			begin
				select = 4'b0011;
				xout = 8'd0;
				yout = 7'd0;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL1: 
			begin
				select = {2'b00, random[17:16]};
				xout = 8'd50;
				yout = 7'd30;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL2: 
			begin
				select = {2'b00, random[15:14]};
				xout = 8'd70;
				yout = 7'd30;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL3: 
			begin
				select = {2'b00, random[13:12]};
				xout = 8'd90;
				yout = 7'd30;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL4: 
			begin
				select = {2'b00, random[11:10]};
				xout = 8'd50;
				yout = 7'd50;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL5: 
			begin
				select = {2'b00, random[9:8]};
				xout = 8'd70;
				yout = 7'd50;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL6: 
			begin
				select = {2'b00, random[7:6]};
				xout = 8'd90;
				yout = 7'd50;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL7: 
			begin
				select = {2'b00, random[5:4]};
				xout = 8'd50;
				yout = 7'd70;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL8: 
			begin
				select = {2'b00, random[3:2]};
				xout = 8'd70;
				yout = 7'd70;
				writeEn = 1'b1;
			end
			S_DRAWSYMBOL9: 
			begin
				select = {2'b00, random[1:0]};
				xout = 8'd90;
				yout = 7'd70;
				writeEn = 1'b1;
			end
			S_DRAWSCORE: 
			begin
				select = 4'b0100;
				xout = 8'd0;
				yout = 7'd0;
				writeEn = 1'b1;
			end
			S_SELECT1:
			begin
				select = 4'b0101;
				xout = 8'd0;
				yout = 7'd0;
				writeEn = 1'b0;
				select_symbol1 = random[17:16];
			end
			S_SELECT2:
			begin
				select = 4'b0110;
				xout = 8'd0;
				yout = 7'd0;
				writeEn = 1'b0;
				select_symbol2 = random[15:14];
			end
			S_SELECT3:
			begin
				select = 4'b0111;
				xout = 8'd0;
				yout = 7'd0;
				writeEn = 1'b0;
				select_symbol3 = random[13:12];
			end
			S_DETERMINE:
			begin
				if(!correct) //wrong match - cancelSelections
					select = 4'b1000;
				else // cancelCards
					select = 4'b1001
				xout = 8'd0;
				yout = 7'd0;
				writeEn = 1'b0;
			end
			default: begin
				select = 3'b011;
				xout = 8'd0;
				yout = 7'd0;
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
