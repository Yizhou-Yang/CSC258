module finalProject
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
      KEY,
      SW,
		HEX0, HEX2, HEX4,
//		  PS2_DAT, PS2_CLK,
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
	output [6:0] HEX0, HEX2, HEX4;
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
			.selections(SW[4:1]),
			.selectdone(KEY[3]),
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

module datapathControl(reset_n, clk, in, selections, selectdone, x, y, colour, writeEn, HEX0, HEX2, HEX4);
	input reset_n, clk, in, selectdone;
	input [3:0] selections;
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	output writeEn;
	output [6:0] HEX0, HEX2, HEX4;
	
	wire [7:0] xin;
	wire [6:0] yin;
	wire [3:0] select;
	wire go0, go1, go2, go4, go5, go6, go7, go8;
	wire next1, next5;
	wire correct;
	
	wire [4:0] state, state2;
	wire [17:0] random;
	assign random = 18'b000010010001011010;
	
	datapath dp(
			.reset_n(reset_n), 
			.clk(clk), 
			.in(in),
			.xin(xin), 
			.yin(yin),
			.select(select),
			.selections(selections),
			.random(random),
			.go0(go0), 
			.go1(go1),
			.go2(go2),
			.go4(go4),
			.go5(go5),
			.go6(go6),
			.go7(go7),
			.go8(go8),
			.x(x), 
			.y(y), 
			.colour(colour),
			.next1(next1),
			.next5(next5),
			.correct(correct),
			.HEX0(HEX0),
			.HEX2(HEX2),
			.HEX4(HEX4));
	control ctr(
			.reset_n(reset_n), 
			.clk(clk),
			.go0(go0), 
			.go1(go1), 
			.go2(go2),
			.go3(selectdone),
			.go4(go4),
			.go5(go5),
//			.go6(go6),
			.go6(1'b1),
			.go7(go7),
			.go8(go8),
			.random(random),
			.select(select), 
			.xout(xin), 
			.yout(yin),
			.correct(correct),
			.writeEn(writeEn),
			.state(state),
			.state2(state2));
	
endmodule

module datapath(reset_n, clk, in, xin, yin, select, selections, random,
					 go0, go1, go2, go4, go5, go6, go7, go8, x, y, colour, next1, next5, correct, HEX0, HEX2, HEX4);
	input reset_n, clk, in;
	input [3:0] select;
	input [7:0] xin;
	input [6:0] yin;
	input [3:0] selections;
	input [17:0] random;
	output reg go0, go1, go2, go4, go5, go6, go7, go8;
	output reg [2:0] colour;
	output reg [7:0] x;
	output reg [6:0] y;
	output next1, next5;
	output reg correct;
	output [6:0] HEX0, HEX2, HEX4;

	wire next0, next2, next3, next4;
	wire [7:0] x0, x1, x2, x3, x4, x5;
	wire [6:0] y0, y1, y2, y3, y4, y5;
	wire [2:0] colour0, colour1, colour2, colour3, colour4, colour5;
	reg cancel;
	
	drawCards dc(.reset_n(reset_n), .clk(clk), .in(in), .x(x0), .y(y0), .colour(colour0), .writeEn(writeEn0), .next(next0));
	drawScore ds4(.clk(clk), .reset_n(reset_n), .in(go0), .xout(x4), .yout(y4), .colour(colour4), .next(next4));
	drawSymbol1 ds1(.clk(clk), .reset_n(reset_n), .in(go2), .x(xin), .y(yin), .xout(x1), .yout(y1), .colour(colour1), .next(next1));
	drawSymbol2 ds2(.clk(clk), .reset_n(reset_n), .in(go2), .x(xin), .y(yin), .xout(x2), .yout(y2), .colour(colour2), .next(next2));
	drawSymbol3 ds3(.clk(clk), .reset_n(reset_n), .in(go2), .x(xin), .y(yin), .xout(x3), .yout(y3), .colour(colour3), .next(next3));
//	cancelCards cC0(.clk(clk), .reset_n(reset_n), .in(cancel), .selections(selected_locations), .xout(x5), .yout(y5), .colour(colour5), .next(next5));
	wire cancelAll;
	counterto3 ct3(.in(1'b1), .clock(next5), .clear_b(reset_n), .carryout(cancelAll));
	
	// selected_symbol hold selection, select_symbol is the current selection
	reg [1:0] select_symbol;
	reg [5:0] selected_symbols;
	reg [8:0] selected_locations;
	
	hex hex0(.HEX0(HEX0), .SW({1'b0, selected_locations[2:0]}));
	hex hex1(.HEX0(HEX2), .SW({1'b0, selected_locations[5:3]}));
	hex hex2(.HEX0(HEX4), .SW({1'b0, selected_locations[8:6]}));
	
	always @(*)
	begin
		case (selections)
		4'b0001: select_symbol = random[17:16];
		4'b0010: select_symbol = random[15:14];
		4'b0011: select_symbol = random[13:12];
		4'b0100: select_symbol = random[11:10];
		4'b0101: select_symbol = random[9:8];
		4'b0110: select_symbol = random[7:6];
		4'b0111: select_symbol = random[5:4];
		4'b1000: select_symbol = random[3:2];
		4'b1001: select_symbol = random[1:0];
		endcase
	end

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
			//0101-select1, 0110-select2, 0111-select3, 1000-determine, 1001-cancelCards, 1010-determine
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
				selected_symbols[1:0] <= select_symbol;
				selected_locations[2:0] <= selections;
				correct <= 1'b0;
			end
			4'b0110: begin
				selected_symbols[3:2] <= select_symbol;
				selected_locations[5:3] <= selections;
				correct <= 1'b0;
			end
			4'b0111: begin
				selected_symbols[5:4] <= select_symbol;
				selected_locations[8:6] <= selections;
				if(selected_symbols[5:4] == selected_symbols[3:2] && selected_symbols[5:4] == selected_symbols[1:0])
					correct <= 1'b1;
				else
					correct <= 1'b0;
			end
			4'b1000: begin
				cancel <= 0;
				if(!correct) begin //incorrect, cancel selections
					go4 <= 0;
					go5 <= 1;
				end
				else begin //cancel cards
					go4 <= 1;
					go5 <= 0;
				end
			end
			4'b1001: begin
				cancel <= 1;
				x <= x5;
				y <= y5;
				colour <= colour5;
				go6 <= next5;
			end
			4'b1010: begin
				cancel <= 0;
				if(cancelAll == 1'b1) begin //go to done state
					go7 <= 1;
					go8 <= 0;
				end
				else begin
					go7 <= 0;
					go8 <= 1;
				end
			end
			default: begin
			
			end
			endcase
		end
	end
endmodule

module control(reset_n, clk, go0, go1, go2, go3, go4, go5, go6, go7, go8, correct, random, 
					select, xout, yout, writeEn, state, state2);
	input reset_n, clk, go0, go1, go2, go3, go4, go5, go6, go7, go8, correct;
	input [17:0] random;
	output reg [7:0] xout;
	output reg [6:0] yout;
	output reg [3:0] select;
	output reg writeEn;
	output [4:0] state,state2;
	
	wire enable;
	reg [4:0] current_state, next_state;
	reg [4:0] current_state2, next_state2;
	assign state = current_state;
	assign state2 = current_state2;
	localparam S_DRAWCARDS = 5'b00000,
	
				  S_DRAWSYMBOL1 = 5'b00001,
				  S_DRAWSYMBOL2 = 5'b00010,
				  S_DRAWSYMBOL3 = 5'b00011,
				  S_DRAWSYMBOL4 = 5'b00100,
				  S_DRAWSYMBOL5 = 5'b00101,
				  S_DRAWSYMBOL6 = 5'b00110,
				  S_DRAWSYMBOL7 = 5'b00111,
				  S_DRAWSYMBOL8 = 5'b01000,
				  S_DRAWSYMBOL9 = 5'b01001,
				  S_DRAWSCORE = 5'b01010,
				  S_DONE = 5'b01011,
				  
				  S_SELECT1 = 5'b01100,
				  S_SELECT2 = 5'b01101,
				  S_SELECT3 = 5'b01110,
				  S_DONE2 = 5'b01111,
				  
				  S_DETERMINE1 = 5'b10000,
				  S_CANCELCARDS = 5'b10001,
				  S_DETERMINE2 = 5'b10010,
				  S_DONE3 = 5'b10011;
				  
				  
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
			// consider adding a done state
			S_DRAWSYMBOL9: begin
					next_state = go1 ? S_DONE : S_DRAWSYMBOL9;
					next_state2 = S_SELECT1;
			end
			S_DONE: next_state = S_DONE;
			
			S_DETERMINE1: begin
				if(go4) //correct
					next_state = S_CANCELCARDS;
				else if(go5)  begin//incorrect go back to selection state
					next_state = S_DONE;
					next_state2 = S_SELECT1;
				end
				else
					next_state = S_DETERMINE1;
			end
			S_CANCELCARDS: next_state = go6 ? S_DETERMINE2 : S_CANCELCARDS;
			S_DETERMINE2: begin
				if(go7) //done
					next_state = S_DONE2;
				else if(go8) begin//not done go back to selection state
					next_state2 = S_SELECT1;
					next_state = S_DONE;
				end
				else
					next_state = S_DETERMINE2;
			end
			S_DONE3: next_state = S_DONE3;
			default: next_state = S_DRAWCARDS;
		endcase
	end
	
	//go3 should never move until S_DONE
	always @(negedge go3) begin
		if(current_state!=S_DRAWSYMBOL9 && current_state!=S_DETERMINE1)
		begin
			case(current_state2)
				S_SELECT1: next_state2 <= S_SELECT2;
				S_SELECT2: next_state2 <= S_SELECT3;
				//consider adding done state
				S_SELECT3:begin
					next_state2 <= S_DONE2;
					next_state <= S_DETERMINE1;
				end
				S_DONE2: next_state2 <= S_DONE2;
				default: next_state2 <= S_SELECT1;
			endcase
		end
	end
	reg temp;
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
			S_DRAWSCORE: 
			begin
				select = 4'b0100;
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
			S_DONE:
			begin
				case(current_state2)
				S_SELECT1: select = 4'b0101;
				S_SELECT2: select = 4'b0110;
				S_SELECT3: select = 4'b0111;
				S_DONE2: temp = 0;
				endcase
				writeEn = 1'b0;
			end
			S_DETERMINE1:
			begin
				select = 4'b1000;
				writeEn = 1'b0;
			end
			S_CANCELCARDS:
			begin
				select = 4'b1001;
				writeEn = 1'b1;
			end
			S_DETERMINE2:
			begin
				select = 4'b1010;
				writeEn = 1'b0;
			end
			S_DONE3:
			begin
				select = 4'b1011;
				writeEn = 1'b0;
			end
		endcase
	end
	
	always @(posedge clk)
	begin
		if(reset_n == 1'b0) begin
			current_state <= S_DRAWCARDS;
			current_state2 <= S_SELECT1;
		end
		else begin
			current_state <= next_state;
			current_state2 <= next_state2;
		end
	end
endmodule

module counterto3(in, clock, clear_b, carryout);
	input in, clock, clear_b;
	output carryout;
	
	wire in1, in2, in3;
	wire [2:0] q;
	
	assign in1 = in & q[0];
	assign in2 = in1 & q[1];
	
	reg finish;
	
	flipflop ff0(.in(in), .clock(clock), .reset_n(clear_b && in), .out(q[0]));
	flipflop ff1(.in(in1), .clock(clock), .reset_n(clear_b && in), .out(q[1]));
	flipflop ff2(.in(in2), .clock(clock), .reset_n(clear_b && in), .out(q[2]));

	assign carryout = q[2];
endmodule
