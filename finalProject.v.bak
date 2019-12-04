module finalProject
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
      KEY,
      SW,
		HEX0, HEX1, HEX2, HEX4, HEX5,
		PS2_DAT, PS2_CLK,
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
	output [6:0] HEX0, HEX1, HEX2, HEX4, HEX5;
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
			//.selections(SW[9:1]),
			.selections(out)
			.selectdone(KEY[3]),
			.x(x), 
			.y(y), 
			.colour(colour), 
			.writeEn(writeEn),
			.HEX0(HEX0),
			.HEX1(HEX1),
			.HEX2(HEX2),
			.HEX4(HEX4),
			.HEX5(HEX5));

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

module datapathControl(reset_n, clk, in, selections, selectdone, x, y, colour, writeEn, HEX0, HEX1, HEX2, HEX4, HEX5);
	input reset_n, clk, in, selectdone;
	input [8:0] selections;
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	output writeEn;
	output [6:0] HEX0, HEX1, HEX2, HEX4, HEX5;
	
	wire [7:0] xin;
	wire [6:0] yin;
	wire [3:0] select;
	wire go0, go1, go2, go4, go5, go6, go7, go8;
	wire [1:0] select_symbol;
	wire [3:0] select_location;
	
	wire [4:0] state;
	wire [17:0] random;
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
			.HEX0(HEX0),
			.HEX1(HEX1),
			.HEX2(HEX2),
			.HEX4(HEX4),
			.HEX5(HEX5),
			.select_symbol(select_symbol),
			.select_location(select_location));
	control ctr(
			.reset_n(reset_n), 
			.clk(clk),
			.go0(go0), 
			.go1(go1),
			.go2(go2),
			.go3(selectdone),
			.go4(go4),
			.go5(go5),
			.go6(go6),
//			.go6(1'b1),
			.go7(go7),
			.go8(go8),
			.random(random),
			.select_symbol(select_symbol),
			.select_location(select_location),
			.select(select), 
			.xout(xin), 
			.yout(yin),
			.writeEn(writeEn),
			.state(state));
	
endmodule

module datapath(reset_n, clk, in, xin, yin, select, selections, random,
					 go0, go1, go2, go4, go5, go6, go7, go8, x, y, colour, HEX0, HEX1, HEX2, HEX4, HEX5, select_symbol, select_location);
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
	output [6:0] HEX0, HEX1, HEX2, HEX4, HEX5;
	output reg [1:0] select_symbol;
	output reg [3:0] select_location;

	wire next0, next1, next2, next3, next4, next5, next6;
	wire [7:0] x0, x1, x2, x3, x4, x5, x6;
	wire [6:0] y0, y1, y2, y3, y4, y5, y6;
	wire [2:0] colour0, colour1, colour2, colour3, colour4, colour5, colour6;
	reg cancel1, cancel2;
	reg [5:0] selected_symbols;
	reg [11:0] selected_locations;
	
	drawCards dc(.reset_n(reset_n), .clk(clk), .in(in), .x(x0), .y(y0), .colour(colour0), .writeEn(writeEn0), .next(next0));
	drawScore ds4(.clk(clk), .reset_n(reset_n), .in(go0), .xout(x4), .yout(y4), .colour(colour4), .next(next4));
	drawSymbol1 ds1(.clk(clk), .reset_n(reset_n), .in(in), .x(xin), .y(yin), .xout(x1), .yout(y1), .colour(colour1), .next(next1));
	drawSymbol2 ds2(.clk(clk), .reset_n(reset_n), .in(in), .x(xin), .y(yin), .xout(x2), .yout(y2), .colour(colour2), .next(next2));
	drawSymbol3 ds3(.clk(clk), .reset_n(reset_n), .in(in), .x(xin), .y(yin), .xout(x3), .yout(y3), .colour(colour3), .next(next3));
	cancelCards cC0(.clk(clk), .reset_n(reset_n), .in(cancel1), .data_in(selected_locations), .xout(x5), .yout(y5), .colour(colour5), .finish(next5));
	cancelSelections cS0(.reset_n(reset_n), .clk(clk), .in(cancel2), .data_in(selected_locations), .xout(x6), .yout(y6), .colour(colour6), .finish(next6));
	wire cancelAll, gameOver;
	reg incorrect;
	wire [2:0] incorrect_num;
	counterto3 ct3(.in(1'b1), .clock(next5), .clear_b(reset_n), .carryout(cancelAll));
	counterto6 ct6(.in(1'b1), .clock(incorrect), .clear_b(reset_n), .q(incorrect_num), .carryout(gameOver));
	
	reg [7:0] score;
	hex hex0(.HEX0(HEX0), .SW(selected_locations[3:0]));
	hex hex1(.HEX0(HEX1), .SW(selected_locations[7:4]));
	hex hex2(.HEX0(HEX2), .SW(selected_locations[11:8]));
	
	hex hex3(.HEX0(HEX4), .SW(score[3:0]));
	hex hex4(.HEX0(HEX5), .SW(score[7:4]));
	
	
	assign select_locations = selections;
	
	always @(*)
	begin
		case (selections)
		4'd9: select_symbol = random[17:16];
		4'd8: select_symbol = random[15:14];
		4'd7: select_symbol = random[13:12];
		4'd6: select_symbol = random[11:10];
		4'd5: select_symbol = random[9:8];
		4'd4: select_symbol = random[7:6];
		4'd3: select_symbol = random[5:4];
		4'd2: select_symbol = random[3:2];
		4'd1: select_symbol = random[1:0];
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
				go4 = 0;
				go5 = 0;
				go6 = 0;
				go7 = 0;
				go8 = 0;
				score = 7'd0;
				selected_locations = 12'd0;
			end
		else
		begin
			case (select)
			//0011-drawCards, 0000-drawSymbol1, 0001-drawSymbol2, 0010-drawSymbol3,
			//0100-select1, 0101-select2, 0110-select3, 0111-cancelSelection,
			//1000-determine, 1001-cancelCards, 1010-determine2
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
			end
			4'b0001: begin
				x <= x2;
				y <= y2;
				colour <= colour2;
			end
			4'b0010: begin
				x <= x3;
				y <= y3;
				colour <= colour3;
			end
			4'b0100: begin
				go0 <= 0;
				go4 = 0;
				go5 = 0;
				incorrect <= 1'b0;
				cancel1 <= 0;
				cancel2 <= 0;
				selected_symbols[1:0] <= select_symbol;
				selected_locations[3:0] <= select_location;
			end
			4'b0101: begin
				selected_symbols[3:2] <= select_symbol;
				selected_locations[7:4] <= select_location;
			end
			4'b0110: begin
				selected_symbols[5:4] <= select_symbol;
				selected_locations[11:8] <= select_location;
			end
			4'b0111: begin
				go4 = 0;
				go5 = 0;
				cancel2 <= 1;
				x <= x6;
				y <= y6;
				colour <= colour6;
				go2 <= next6;
			end
			4'b1000: begin
				cancel1 <= 0;
				cancel2 <= 0;
				go6 = 0;
				score <= 4'd10 - incorrect_num;
				if(selected_symbols[5:4] == selected_symbols[3:2] && selected_symbols[5:4] == selected_symbols[1:0]) //cancel cards
				begin
					go4 <= 1;
					go5 <= 0;
				end
				else	//incorrect, cancel selections
				begin 
					incorrect <= 1'b1;
					go4 <= 0;
					if (gameOver == 1) begin
						go1 <= 1;
						go5 <= 0;
					end
					else
						go5 <= 1;
				end
			end
			4'b1001: begin
				go4 = 0;
				go5 = 0;
				cancel1 <= 1;
				x <= x5;
				y <= y5;
				colour <= colour5;
				go6 <= next5;
				if(cancelAll == 1'b1) begin //go to done state
					go7 <= 1;
					go8 <= 0;
				end
				else begin
					go7 <= 0;
					go8 <= 1;
				end
			end
			4'b1010: begin
				cancel1 <= 0;
				go6 <= 0;
			end
			default: begin
				colour = 3'b000;
				x = 8'b00000000;
				y = 7'b0000000;
				go0 = 0;
				go1 = 0;
				go2 = 0;
				selected_locations = 12'd0;
			end
			endcase
		end
	end
endmodule

module control(reset_n, clk, go0, go1, go2, go3, go4, go5, go6, go7, go8, random, select_symbol, select_location,
					select, xout, yout, writeEn, state);
	input reset_n, clk, go0, go1, go2, go3, go4, go5, go6, go7, go8;
	input [17:0] random;
	input [1:0] select_symbol;
	input [3:0] select_location;
	output reg [7:0] xout;
	output reg [6:0] yout;
	output reg [3:0] select;
	output reg writeEn;
	output [4:0] state;

	reg [4:0] current_state, next_state;
	assign state = current_state;
	localparam S_DRAWCARDS = 5'b00000,
				  S_CANCELSELECTION = 5'b01100,
				  S_SELECT1 = 5'b00001,
				  S_SELECT1_WAIT = 5'b00010,
				  S_SELECT2 = 5'b00011,
				  S_SELECT2_WAIT = 5'b00100,
				  S_SELECT3 = 5'b00101,
				  S_SELECT3_WAIT = 5'b00110,
				  S_DETERMINE1 = 5'b01000,
				  S_CANCELCARDS = 5'b01001,
				  S_DETERMINE2 = 5'b01010,
				  S_DONE = 5'b01011;
				  
	always @(*)
	begin: state_table
		case(current_state)
			S_DRAWCARDS: next_state = go0 ? S_SELECT1 : S_DRAWCARDS;
			S_CANCELSELECTION: next_state = go2 ? S_SELECT1 : S_CANCELSELECTION;
			S_SELECT1: begin
				if(go1) //game over go to done state
					next_state = S_DONE;
				else
					next_state = go3 ? S_SELECT1 : S_SELECT1_WAIT;
			end
			S_SELECT1_WAIT: next_state = go3 ? S_SELECT2 : S_SELECT1_WAIT;
			S_SELECT2: next_state = go3 ? S_SELECT2 : S_SELECT2_WAIT;
			S_SELECT2_WAIT: next_state = go3 ? S_SELECT3 : S_SELECT2_WAIT;
			S_SELECT3: next_state = go3 ? S_SELECT3 : S_SELECT3_WAIT;
			S_SELECT3_WAIT: next_state = go3 ? S_DETERMINE1 : S_SELECT3_WAIT;
			S_DETERMINE1: begin
				if(go4) //correct
					next_state = S_CANCELCARDS;
				else if(go5) //incorrect go back to selection state
					next_state = S_CANCELSELECTION;
				else
					next_state = S_DETERMINE1;
			end
			S_CANCELCARDS: next_state = go6 ? S_DETERMINE2 : S_CANCELCARDS;
			S_DETERMINE2: begin
				if(go7) //done
					next_state = S_DONE;
				else if(go8) //not done go back to selection state
					next_state = S_SELECT1;
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
			S_CANCELSELECTION:
			begin
				select = 4'b0111;
				writeEn = 1'b1;
			end
			S_SELECT1:
			begin
				select = 4'b0100;
				writeEn = 1'b0;
			end
			S_SELECT1_WAIT:
			begin
				select = {2'b00, select_symbol};
				writeEn = 1'b1;
				case (select_location)
				4'b0000: begin
					xout = 8'd50;
					yout = 7'd30; end
				4'b0001: begin
					xout = 8'd70;
					yout = 7'd30; end
				4'b0010: begin
					xout = 8'd90;
					yout = 7'd30; end
				4'b0011: begin
					xout = 8'd50;
					yout = 7'd50; end
				4'b0100: begin
					xout = 8'd70;
					yout = 7'd50; end
				4'b0101: begin
					xout = 8'd90;
					yout = 7'd50; end
				4'b0110: begin
					xout = 8'd50;
					yout = 7'd70; end
				4'b0111: begin
					xout = 8'd70;
					yout = 7'd70; end
				4'b1000: begin
					xout = 8'd90;
					yout = 7'd70; end
				endcase
			end
			S_SELECT2:
			begin
				select = 4'b0101;
				writeEn = 1'b0;
			end
			S_SELECT2_WAIT:
			begin
				select = {2'b00, select_symbol};
				writeEn = 1'b1;
				case (select_location)
				4'b0000: begin
					xout = 8'd50;
					yout = 7'd30; end
				4'b0001: begin
					xout = 8'd70;
					yout = 7'd30; end
				4'b0010: begin
					xout = 8'd90;
					yout = 7'd30; end
				4'b0011: begin
					xout = 8'd50;
					yout = 7'd50; end
				4'b0100: begin
					xout = 8'd70;
					yout = 7'd50; end
				4'b0101: begin
					xout = 8'd90;
					yout = 7'd50; end
				4'b0110: begin
					xout = 8'd50;
					yout = 7'd70; end
				4'b0111: begin
					xout = 8'd70;
					yout = 7'd70; end
				4'b1000: begin
					xout = 8'd90;
					yout = 7'd70; end
				endcase
			end
			S_SELECT3:
			begin
				select = 4'b0110;
				writeEn = 1'b0;
			end
			S_SELECT3_WAIT:
			begin
				select = {2'b00, select_symbol};
				writeEn = 1'b1;
				case (select_location)
				4'b0000: begin
					xout = 8'd50;
					yout = 7'd30; end
				4'b0001: begin
					xout = 8'd70;
					yout = 7'd30; end
				4'b0010: begin
					xout = 8'd90;
					yout = 7'd30; end
				4'b0011: begin
					xout = 8'd50;
					yout = 7'd50; end
				4'b0100: begin
					xout = 8'd70;
					yout = 7'd50; end
				4'b0101: begin
					xout = 8'd90;
					yout = 7'd50; end
				4'b0110: begin
					xout = 8'd50;
					yout = 7'd70; end
				4'b0111: begin
					xout = 8'd70;
					yout = 7'd70; end
				4'b1000: begin
					xout = 8'd90;
					yout = 7'd70; end
				endcase
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
			S_DONE:
			begin
				select = 4'b1011;
				writeEn = 1'b0;
			end
			default:
			begin
				writeEn = 1'b0;
			end
		endcase
	end
	
	always @(posedge clk)
	begin
		if(reset_n == 1'b0) begin
			current_state <= S_DRAWCARDS;
		end
		else begin
			current_state <= next_state;
		end
	end
endmodule

module counterto3(in, clock, clear_b, carryout);
	input in, clock, clear_b;
	output carryout;
	
	wire in1, in2, in3;
	wire [1:0] q;
	
	assign in1 = in & q[0];
	
	reg finish;
	
	flipflop ff0(.in(in), .clock(clock), .reset_n(clear_b && in), .out(q[0]));
	flipflop ff1(.in(in1), .clock(clock), .reset_n(clear_b && in), .out(q[1]));

	assign carryout = (q == 2'b11);
endmodule

module counterto6(in, clock, clear_b, q, carryout);
	input in, clock, clear_b;
	output carryout;
	output [2:0] q;
	
	wire in1, in2, in3;
	
	assign in1 = in & q[0];
	assign in2 = in1 & q[1];
	
	reg finish;
	
	flipflop ff0(.in(in), .clock(clock), .reset_n(clear_b && in), .out(q[0]));
	flipflop ff1(.in(in1), .clock(clock), .reset_n(clear_b && in), .out(q[1]));
	flipflop ff2(.in(in2), .clock(clock), .reset_n(clear_b && in), .out(q[2]));

	assign carryout = (q == 3'b010);
endmodule