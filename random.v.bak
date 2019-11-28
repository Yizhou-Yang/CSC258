module finalProject
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
      KEY,
      SW,
		HEX0,
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
	output [6:0] HEX0;
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
			.selections(SW[9:1]),
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

module datapathControl(reset_n, clk, in, selections, selectdone, x, y, colour, writeEn);
	input reset_n, clk, in, selectdone;
	input [8:0] selections;
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	output writeEn;
	
	wire [7:0] xin;
	wire [6:0] yin;
	wire [3:0] select;
	wire go0, go1, go2, go4, go5, go6, go7, go8;
	wire next5;
	wire [11:0] selected_locations;
	wire [17:0] symbols;
	
	wire [4:0] state;
	wire [17:0] random;
//	assign random = 18'b000010010001011010;
	
	randGen rg0(.clk(clk), .reset_n(reset_n), .start(in), .rand_out(random));
	
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
			.next5(next5),
			.selected_locations(selected_locations),
			.symbols(symbols));
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
			.writeEn(writeEn),
			.state(state));
	
endmodule

module datapath(reset_n, clk, in, xin, yin, select, selections, random,
					 go0, go1, go2, go4, go5, go6, go7, go8, x, y, colour, next5, selected_locations, symbols);
	input reset_n, clk, in;
	input [3:0] select;
	input [7:0] xin;
	input [6:0] yin;
	input [8:0] selections;
	input [17:0] random;
	output reg go0, go1, go2, go4, go5, go6, go7, go8;
	output reg [2:0] colour;
	output reg [7:0] x;
	output reg [6:0] y;
	output next5;
	
	output [17:0] symbols;
	output [11:0] selected_locations;

	reg [3:0] selected_location1, selected_location2, selected_location3;
	assign selected_locations = {selected_location1, selected_location2, selected_location3};
	
	wire next0, next1, next2, next3, next4;
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
	counterto3 ct3cancel(.in(1'b1), .clock(next5), .clear_b(reset_n), .carryout(cancelAll));
	counterto3 ct3select(.in(1'b1), .clock(next5), .clear_b(reset_n), .carryout(cancelAll));
	
	// selected_symbol hold selection, select_symbol is the current selection
	reg [1:0] select_symbol1, select_symbol2, select_symbol3, select_symbol4, select_symbol5, select_symbol6, select_symbol7, select_symbol8, select_symbol9;
	reg [1:0] selected_symbols;
//	reg [11:0] selected_locations;
	assign symbols = {select_symbol1, select_symbol2, select_symbol3, select_symbol4,select_symbol5,select_symbol6, select_symbol7,select_symbol8,select_symbol9};

	always @(posedge clk or negedge reset_n )
	begin
		if(reset_n == 1'b0)
		begin
			colour <= 3'b000;
			x <= 8'b00000000;
			y <= 7'b0000000;
			go0 <= 0;
			go1 <= 0;
			go2 <= 0;
			go4 <= 0;
			go5 <= 0;
			go6 <= 0;
			go7 <= 0;
			go8 <= 0;
//			selected_locations <= 12'd0;
			selected_location1 <= 4'd0;
			selected_location2 <= 4'd0;
			selected_location3 <= 4'd0;
		end
		else
		begin
			case (select)
			//0011-drawCards, 0000-drawSymbol1, 0001-drawSymbol2, 0010-drawSymbol3, 0100-drawScore
			//0101-select, 0110-determine, 0111-cancelCards, 1000-determine
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
				select_symbol1 <= (selections[0]==1'b1) ? random[17:16] : 2'b11;
				select_symbol2 <= (selections[1]==1'b1) ? random[15:14] : 2'b11;
				select_symbol3 <= (selections[2]==1'b1) ? random[13:12] : 2'b11;
				select_symbol4 <= (selections[3]==1'b1) ? random[11:10] : 2'b11;
				select_symbol5 <= (selections[4]==1'b1) ? random[9:8] : 2'b11;
				select_symbol6 <= (selections[5]==1'b1) ? random[7:6] : 2'b11;
				select_symbol7 <= (selections[6]==1'b1) ? random[5:4] : 2'b11;
				select_symbol8 <= (selections[7]==1'b1) ? random[3:2] : 2'b11;
				select_symbol9 <= (selections[8]==1'b1) ? random[1:0] : 2'b11;
				if(select_symbol1 != 2'b11) begin
					selected_location1 <= 4'b0001;
					selected_symbols <= select_symbol1;
				end
				if(select_symbol2 != 2'b11) begin
					if(selected_location1 == 4'd0)
						selected_location1 <= 4'b0010;
					else
						selected_location2 <= 4'b0010;
					selected_symbols <= select_symbol1;
				end
				if(select_symbol3 != 2'b11) begin
					if(selected_location1 == 4'd0)
						selected_location1 <= 4'b0011;
					else if(selected_location2 == 4'd0)
						selected_location2 <= 4'b0011;
					else
						selected_location3 <= 4'b0011;
					selected_symbols <= select_symbol1;
				end
				if(select_symbol4 != 2'b11) begin
					if(selected_location1 == 4'd0)
						selected_location1 <= 4'b0100;
					else if(selected_location2 == 4'd0)
						selected_location2 <= 4'b0100;
					else
						selected_location3 <= 4'b0100;
					selected_symbols <= select_symbol1;
				end
				if(select_symbol5 != 2'b11) begin
					if(selected_location1 == 4'd0)
						selected_location1 <= 4'b0101;
					else if(selected_location2 == 4'd0)
						selected_location2 <= 4'b0101;
					else
						selected_location3 <= 4'b0101;
					selected_symbols <= select_symbol1;
				end
				if(select_symbol6 != 2'b11) begin
					if(selected_location1 == 4'd0)
						selected_location1 <= 4'b0110;
					else if(selected_location2 == 4'd0)
						selected_location2 <= 4'b0110;
					else
						selected_location3 <= 4'b0110;
					selected_symbols <= select_symbol1;
				end
				if(select_symbol7 != 2'b11) begin
					if(selected_location1 == 4'd0)
						selected_location1 <= 4'b0111;
					else if(selected_location2 == 4'd0)
						selected_location2 <= 4'b0111;
					else
						selected_location3 <= 4'b0111;
					selected_symbols <= select_symbol1;
				end
				if(select_symbol8 != 2'b11) begin
					if(selected_location2 == 4'd0)
						selected_location2 <= 4'b1000;
					else
						selected_location3 <= 4'b1000;
					selected_symbols <= select_symbol1;
				end
				if(select_symbol9 != 2'b11) begin
					selected_location3 <= 4'b1001;
					selected_symbols <= select_symbol1;
				end
			end
			4'b0110: begin
				if((select_symbol1!=2'b11 && selected_symbols!=select_symbol1) ||
					(select_symbol2!=2'b11 && selected_symbols!=select_symbol2) ||
					(select_symbol3!=2'b11 && selected_symbols!=select_symbol3) ||
					(select_symbol4!=2'b11 && selected_symbols!=select_symbol4) ||
					(select_symbol5!=2'b11 && selected_symbols!=select_symbol5) ||
					(select_symbol6!=2'b11 && selected_symbols!=select_symbol6) ||
					(select_symbol7!=2'b11 && selected_symbols!=select_symbol7) ||
					(select_symbol8!=2'b11 && selected_symbols!=select_symbol8) ||
					(select_symbol9!=2'b11 && selected_symbols!=select_symbol9)) //incorrect
					go5 <= 1'b1;
				else
					go4 <= 1'b1;
				cancel <= 1'b0;
			end
			4'b0111: begin
				cancel <= 1'b1;
//				go6 <= next5;
			end
			4'b1000: begin
				go7 <= cancelAll;
				go8 <= (!cancelAll) ? 1'b1 : 1'b0;
			end
			default: begin
			
			end
			endcase
		end
	end
endmodule

module control(reset_n, clk, go0, go1, go2, go3, go4, go5, go6, go7, go8, random, 
					select, xout, yout, writeEn, state);
	input reset_n, clk, go0, go1, go2, go3, go4, go5, go6, go7, go8;
	input [17:0] random;
	output reg [7:0] xout;
	output reg [6:0] yout;
	output reg [3:0] select;
	output reg writeEn;
	output [4:0] state;
	
	wire enable;
	reg [4:0] current_state, next_state;
	assign state = current_state;
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
				  S_SELECT = 5'b01011,
				  S_DETERMINE1 = 5'b01100,
				  S_CANCELCARDS = 5'b01101,
				  S_DETERMINE2 = 5'b01110,
				  S_DONE = 5'b01111;
				  
				  
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
			S_DRAWSYMBOL9: next_state = go1 ? S_SELECT : S_DRAWSYMBOL9;
			S_SELECT: next_state = go3 ? S_SELECT : S_DETERMINE1;
			S_DETERMINE1: begin
				if(go4 && go3) //correct
					next_state = S_CANCELCARDS;
				else if(go5 && go3) //incorrect go back to selection state
					next_state = S_SELECT;
				else
					next_state = S_DETERMINE1;
			end
			S_CANCELCARDS: next_state = go6 ? S_DETERMINE2 : S_CANCELCARDS;
			S_DETERMINE2: begin
				if(go7) //done
					next_state = S_DONE;
				else if(go8) //not done go back to selection state
					next_state = S_SELECT;
				else
					next_state = S_DETERMINE2;
			end
			S_DONE: next_state = S_DONE;
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
			S_SELECT:
			begin
				select = 4'b0101;
				writeEn = 1'b0;
			end
			S_DETERMINE1:
			begin
				select = 4'b0110;
				writeEn = 1'b0;
			end
			S_CANCELCARDS:
			begin
				select = 4'b0111;
				writeEn = 1'b1;
			end
			S_DETERMINE2:
			begin
				select = 4'b1000;
				writeEn = 1'b0;
			end
			S_DONE:
			begin
				select = 4'b1001;
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
