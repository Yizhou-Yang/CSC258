module hex(HEX0, SW);
	input [3:0] SW;
	output [6:0] HEX0;
	
	decoder7segment u0(
		.c0(SW[0]),
		.c1(SW[1]),
		.c2(SW[2]),
		.c3(SW[3]),
		.HEX0(HEX0)
		);
endmodule

module decoder7segment(c3, c2, c1, c0, HEX0);
	input c3, c2, c1, c0;
	output [6:0] HEX0;
	
	assign HEX0[0] = ~c3 & ~c2 & ~c1 & c0 | ~c3 & c2 & ~c1 & ~c0 | c3 & c2 & ~c1 & c0 | c3 & ~c2 & c1 & c0;
	assign HEX0[1] = c3 & c2 & ~c0 | c1 & c0 & c3 | c1 & ~c0 & c2 | ~c3 & c2 & ~c1 & c0;
	assign HEX0[2] = ~c3 & ~c2 & c1 & ~c0 | c3 & c2 & ~c0 | c3 & c2 & c1;
	assign HEX0[3] = ~c3 & c2 & ~c1 & ~c0 | ~c3 & ~c2 & ~c1 & c0 | c1 & c0 & c2 | c3 & ~c2 & c1 & ~c0;
	assign HEX0[4] = ~c3 & c0 | ~c1 & c0 & ~c2 | ~c3 & c2 & ~c1;
	assign HEX0[5] = c3 & c2 & ~c1 & c0 | ~c3 & ~c2 & c0 | ~c3 & ~c2 & c1 | c1 & c0 & ~c3;
	assign HEX0[6] = ~c3 & ~c2 & ~c1 | c3 & c2 & ~c1 & ~c0 | ~c3 & c2 & c1 & c0;
endmodule
