module randGen(clk, reset_n, start, rand_out);
	input clk, reset_n, start;
	output reg[17:0] rand_out;
	
	reg [2:0]count;
	
	always@(posedge clk or negedge reset_n) begin
		if(!reset_n)
			count <= 0;
		else begin
			count <= count+1;
		end
	end
	
	always@(posedge start or negedge reset_n or negedge start)begin
		if(!reset_n)
			rand_out <= 0;
		else if(start) begin
			case(count)
				3'd0:rand_out <= 18'b010101101000100000;
				3'd1:rand_out <= 18'b010010000100100110;
				3'd2:rand_out <= 18'b010000011001101000;
				3'd3:rand_out <= 18'b000110101001000100;
				3'd4:rand_out <= 18'b000001001001100110;
				3'd5:rand_out <= 18'b001001001010010100;
				3'd6:rand_out <= 18'b100100100100011000;
				3'd7:rand_out <= 18'b100001100001100100;
			endcase
		end
		else begin
			rand_out <= 0;
		end
	end
	
endmodule
