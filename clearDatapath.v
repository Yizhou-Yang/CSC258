module cancelCards(reset_n,clk,in,data_in, xout, yout, colour, finish,next,
x0,y0,current_state,next_state,count);
	input reset_n,clk,in;
	input [11:0] data_in;
	output [7:0] xout;
	output [6:0] yout;
	output [2:0] colour;
	output reg finish;
	
	//
	output next;
	output reg [7:0] x0;
	output reg [6:0] y0;
	output reg[5:0] current_state,next_state;
	output reg[2:0] count;
	//
	wire[3:0]data1,data2,data3;
	reg [3:0]data;
	assign data1 = data_in[3:0];
	assign data2 = data_in[7:4];
	assign data3 = data_in[11:8];
	
	//wire next;
	//reg[7:0] x0;
	//reg[6:0] y0;
	
	localparam S1 = 5'd1, S2 = 5'd2, S3 = 5'd3, S_DONE = 5'd4;
	
	//reg[5:0] current_state,next_state;
	//reg[2:0] count;
	always @(*) begin
		if(!reset_n) begin
			current_state = 0;
			finish = 0;
			x0 = 0;
			y0 = 0;
			count = 0;
		end
	end
	
	always @(*)begin
		case(current_state)
			S1:next_state = (count==1)?S2:S1;
			S2:next_state = (count==2)?S3:S2;			
			S3:next_state = (count==3)?S_DONE:S3;	
			S_DONE:next_state = S_DONE;
		default:next_state = S1;
		endcase
	end
	
	always @(posedge next)begin
		count <= count + 1;
	end

	always @(*)begin
	
		case(current_state)
			S1:data = data1;
			S2:data = data2;
			S3:data = data3;
			S_DONE:finish = 1;
		endcase
		
		case(data)
			4'd1:begin	x0 = 8'd50; y0 = 7'd30;	end
			4'd2:begin	x0 = 8'd70; y0 = 7'd30;	end
			4'd3:begin	x0 = 8'd90; y0 = 7'd30;	end
			4'd4:begin	x0 = 8'd50; y0 = 7'd50;	end
			4'd5:begin	x0 = 8'd70; y0 = 7'd50;	end
			4'd6:begin	x0 = 8'd90; y0 = 7'd50;	end
			4'd7:begin	x0 = 8'd50; y0 = 7'd70;	end
			4'd8:begin	x0 = 8'd70; y0 = 7'd70;	end
			4'd9:begin	x0 = 8'd90; y0 = 7'd70;	end
		endcase
		
	end
		
	always @(posedge clk)
		current_state = next_state;
		
	clearCards c1(.reset_n(reset_n),.clk(clk), .in(in),.x0(x0),
				.y0(y0), .x(xout), .y(yout), .colour(colour), .next(next));

	
endmodule