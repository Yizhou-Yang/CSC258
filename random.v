module randGen(clk, reset_n, start, rand_out);
	input clk, reset_n, start;
	output reg[17:0] rand_out;

	reg [2:0] counter11,counter12,counter13;
	reg [1:0] counter2;
	wire [1:0] rand;
	reg [1:0]rand_in;
	reg [4:0] counter3;
	wire out;
	reg lock;
	
	Counter r1(.clk(clk),.reset_n(reset_n),.out(out));
	rG r2(.clk(clk),.reset_n(reset_n),.rand(rand));
	
	always @ (*)
		begin
			if(!reset_n)begin
				counter2 = 2'd0;
				counter11 = 3'd0;
				counter12 = 3'd0;
				counter13 = 3'd0;
				counter3 = 5'd0;
				lock = 0;
		end
	end
	
		always @(*)begin
				if (counter11 == 3'd3&& rand_in==2'b00) begin
					rand_in = 2'b01;
				end
			  if (counter12 == 3'd3&&rand_in==2'b01) begin
					rand_in = 2'b10;
				end
			  if (counter13 == 3'd3&&rand_in==2'b10) begin
					rand_in = 2'b00;
				end
				if (counter11 == 3'd3&& rand_in==2'b00) begin
					rand_in = 2'b01;
				end
				if (counter12 == 3'd3&&rand_in==2'b01) begin
					rand_in = 2'b10;
				end
		end
		
		always @(posedge out) begin
			if(start && reset_n) begin
				case(rand_in)
					2'b00: counter11 = counter11+1;
					2'b01: counter12 = counter12+1;
					2'b10: counter13 = counter13+1;
				endcase
			end
		end
		
		always@(posedge out)begin
			if(start && reset_n && !lock) begin
			  case(counter3)
					5'd0:rand_out[1:0] <= rand_in;
					5'd1:rand_out[3:2] <= rand_in;
					5'd2:rand_out[5:4] <= rand_in;
					5'd3:rand_out[7:6] <= rand_in;
					5'd4:rand_out[9:8] <= rand_in;
					5'd5:rand_out[11:10] <= rand_in;
					5'd6:rand_out[13:12] <= rand_in;
					5'd7:rand_out[15:14] <= rand_in;
					5'd8:begin
						rand_out[17:16] <= rand_in;
						lock <= 1;
					end
				endcase
				counter3 <= counter3 + 1;
			end
		end

	always @ (posedge clk) begin
		//update the random in order, and move counter2 in case of 11.
				
			if(counter2 == 2'b10)
				counter2 <= 2'b00;
			else
				counter2 <= counter2 + 1;
		// update rand every clock cycle
	end	
	
	always @ (posedge clk) begin
		rand_in <= (rand == 2'b11)?counter2:rand;
	end
	
endmodule


module rG(clk, reset_n, rand);
	input clk, reset_n;
	output reg[1:0] rand;
 
	reg [2:0] random, random_next;
	wire feedback; 
	
	assign feedback = random[2] ^ random[1]; 
	always @ (posedge clk) begin
			random = random_next;
			rand <= random[1:0];
	end	
	
	always @ (*)
	begin
	  random_next[2:1] = random[1:0];
	  random_next[0] = feedback;
	  
	  if(!reset_n)begin
			random = 3'b111;
			random_next = 3'b111;
			rand = 2'b0;
		end
	end
endmodule

module Counter(clk,reset_n,out);
	input clk,reset_n;
	output reg out;
	
	reg[2:0] count;
	
	always @(*)
	begin
		if(!reset_n) begin
			count = 3'd0;
		end
		out = count;
	end
	
	always @(posedge clk)begin
			count <= count + 1;
			if(count == 3'd2)
				out <= 1'b1;
			else out <= 1'b0 ;
	end
endmodule
