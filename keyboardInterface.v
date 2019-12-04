//用法
//keyboardInterface kI(.keyboard_clk(PS2_CLK),data(PS2_DAT),clk(CLOCK_50),reset_n(reset_n),
//												 read(),out())
//read为1的时候开始录入，输出为out[3:0],每次弄完可能要把reset归0（目前没有）
module keyboardInterface(keyboard_clk,data,clk,reset_n,read,out);
	input clk,data,keyboard_clk,reset_n,read;
	output reg[3:0]out;
	
	wire[7:0] scan_code;
	wire read, scan_ready;
	reg[7:0] scan_history[1:2];
	
	always @(posedge scan_ready)begin
		scan_history [2]<=scan_history[1];
		scan_history [1]<=scan_code;
	end
	
	keyboard k0(.keyboard_clk(keyboard_clk), .keyboard_data(data), .clock50(clk), .reset(0),
										.read(read), .scan_ready(scan_ready), .scan_code(scan_code));
										
	oneshot pulse (.pulse_out(read),. trigger_in(scan_ready),.clk(clk));
	
	always@(*)
		if(scan_history[2]!='hF0)begin
			case(scan_history[1])
				'h16:out = 4'd1;
				'h1E:out = 4'd2;
				'h26:out = 4'd3;
				'h25:out = 4'd4;
				'h2E:out = 4'd5;
				'h36:out = 4'd6;
				'h3D:out = 4'd7;
				'h3E:out = 4'd8;
				'h46:out = 4'd9;
			endcase
		end
	end
endmodule
