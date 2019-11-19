module randomGenerate2bits(clk, reset_n, go1, go0, rand);
	input clk,reset_n,go1, go0;
	output reg[1:0] rand;
 
	reg [2:0] random, random_next;
	reg [1:0] counter11,counter12,counter13;
	reg [1:0] counter2;
	wire feedback; 
	
	reg lock;
	
	assign feedback = random[2] ^ random[1]; 
	always @ (posedge clk or negedge reset_n)
		begin
			if(!reset_n)begin
				random <= 3'b111;
				random_next <= 3'b111;
				counter2 <= 2'd0;
				counter11 <= 3'd0;
				counter12 <= 3'd0;
				counter13 <= 3'd0;
				lock <= 0;
			end
			//update the random in order, and move counter2 in case of 11.
			else begin
				random = random_next;
				if(counter2 == 2'b10)
					counter2 = 2'b00;
				else
					counter2 = counter2 + 1;
			end
		end	
	
	always @ (*)
	begin
	  random_next[2:1] = random[1:0];
	  random_next[0] = feedback;
	  
	  //whenever go1 goes to 1, update rand, which outputs the number
	  // and then add the corresponding counter
	  if(go1)begin
				
			if(random[1:0] == 2'b11)begin
				rand = counter2;
			end
			
			else begin
			rand = random[1:0];
			end
			
			case(rand)
				2'b00: counter11= counter11+1;
				2'b01: counter12 = counter12+1;
				2'b10: counter13= counter13+1;
			endcase
	  end
	  
	  //similarly, whenever go0 goes to 1, if lock is 0, change lock to 1 and update rand and counter
	  if (go0&&lock==0)begin
				
			if(random[1:0] == 2'b11)begin
				rand = counter2;
			end
			
			else begin
			rand = random[1:0];
			end
			
			case(rand)
				2'b00: counter11= counter11+1;
				2'b01: counter12 = counter12+1;
				2'b10: counter13= counter13+1;
			endcase
			lock = 1;
	  end
		
	  //instantly change the rand if counter faces a leaking value, so that it outputs properly on the next clockedge
	  if (counter11 == 2'b11&&rand==2'b00)
			rand = 2'b01;			
	  if (counter12 == 2'b11&&rand==2'b01)
			rand = 2'b10;
	  if (counter13 == 2'b11&&rand==2'b10)
			rand = 2'b00;
	end
endmodule
