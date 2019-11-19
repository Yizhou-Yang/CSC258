module randomGenerate2bits(clk, reset_n, go1, rand);
	input clk,reset_n,go1;
	output reg[1:0] rand;
 
	reg [2:0] random, random_next;
	reg [1:0] counter11,counter12,counter13;
	reg [1:0] counter2;
	wire feedback; 
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
			end
			else begin
				random = random_next;
				if(counter2 == 2'b10)
					counter2 = 2'b00;
				else
					counter2 = counter2 + 1;
				case(rand)
				2'b00: counter11= counter11+1;
				2'b01: counter12 = counter12+1;
				2'b10: counter13= counter13+1;
				endcase
			end
		end		
	
	always @ (*)
	begin
	  random_next[2:1] = random[1:0];
	  random_next[0] = feedback;
	  if(go1)begin
				
			if(random[1:0] == 2'b11)begin
				rand = counter2;
			end
			
			else begin
			rand = random[1:0];
			end
	  end
	  if (counter11 == 2'b11&&rand==2'b00)
			rand = 2'b01;			
	  if (counter12 == 2'b11&&rand==2'b01)
			rand = 2'b10;
	  if (counter13 == 2'b11&&rand==2'b10)
			rand = 2'b00;
	end
endmodule
