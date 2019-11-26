module randGen(clk, reset_n, start, rand_out);
	input clk, reset_n, start;
	output reg[17:0] rand_out;
 
	reg [2:0] random, random_next;
	reg [2:0] counter11,counter12,counter13;
	reg [1:0] counter2;
	reg [1:0] rand;
	reg [3:0] counter31;
	reg [4:0] counter32;
	wire [2:0] out;
	wire feedback; 
	
	randomCounter r1(.start(start),.clk(clk),.reset_n(reset_n),.out(out));
	
	assign feedback = random[2] ^ random[1]; 
	always @ (posedge clk) begin
		//update the random in order, and move counter2 in case of 11.
			random = random_next;
			if(counter31 == 4'd0)
				counter31 <= counter31 + 1;
			else
				counter31 <= 0;
				
			if(counter2 == 2'b10)
				counter2 <= 2'b00;
			else
				counter2 <= counter2 + 1;
				
		// update rand every clock cycle
			if(random[1:0] == 2'b11)begin
				rand <= counter2;
			end
			
			else begin
				rand <= random[1:0];
			end
	end	
	
	always @ (*)
	begin
	  random_next[2:1] = random[1:0];
	  random_next[0] = feedback;
	  
	  if(!reset_n)begin
			random = 3'b111;
			random_next = 3'b111;
			counter2 = 2'd0;
			counter11 = 3'd0;
			counter12 = 3'd0;
			counter13 = 3'd0;
			counter31 = 4'd0;
			counter32 = 5'd0;
			rand = 2'b0;
		end
		
		else if(counter31 == 4'd6)begin
			//update the rand into out, using counter 32 to track position
		  case(counter32)
				5'd0:rand_out[1:0] = rand;
				5'd1:rand_out[3:2] = rand;
				5'd2:rand_out[5:4] = rand;
				5'd3:rand_out[7:6] = rand;
				5'd4:rand_out[9:8] = rand;
				5'd5:rand_out[11:10] = rand;
				5'd6:rand_out[13:12] = rand;
				5'd7:rand_out[15:14] = rand;
				5'd8:rand_out[17:16] = rand;
			endcase
			
			//eliminate repetition
			case(rand)
				2'b00: counter11 = counter11+1;
				2'b01: counter12 = counter12+1;
				2'b10: counter13 = counter13+1;
			endcase
			
			counter32 = counter32 + 1;
		end
			
		else begin
		  //instantly change the rand if counter faces a leaking value, 
		  //so that it outputs properly
		  if (counter11 == 3'd4&&rand==2'b00) begin
				rand = 2'b01;
				counter11 = 3'd3;
				counter12 = counter12 + 1;
			end
		  if (counter12 == 3'd4&&rand==2'b01) begin
				rand = 2'b10;
				counter12 = 3'd3;
				counter13 = counter12 + 1;
			end
		  if (counter13 == 3'd4&&rand==2'b10) begin
				rand = 2'b00;
				counter13 = 3'd3;
				counter11 = counter12 + 1;
			end
		end	
	end
endmodule

module randomCounter(start,clk,reset_n,out);
	input start,clk,reset_n;
	output reg[2:0] out;
	
	reg[2:0] count;
	
	//can't output 000 or 001, add 2 instead
	always @(*)
	begin
		if(!reset_n) begin
			count = 3'd0;
		end
	if(count == 3'b000 || count== 3'b001)
		out = count+2;
	else
		out = count;
	end
	
	always @(posedge clk)begin
			count <= count+1;
	end
endmodule
