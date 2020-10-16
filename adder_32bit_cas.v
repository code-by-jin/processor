module adder_32bit_cas(out, ovf, cout, in1, in2, cin);
	input [31:0] in1, in2;
	input cin;
	output [31:0] out;
	output ovf, cout;
	
	wire ovf_low, cout_low; // carry out from low 4-bit add and serve as the selector for high 4-bit add
	wire [15:0] out_temp0, out_temp1;
	wire ovf_high_temp0, ovf_high_temp1, cout_high_temp0, cout_high_temp1;
	
	// 4-bit rca
	adder_16bit_cas add_low(out[15:0], ovf_low, cout_low, in1[15:0], in2[15:0], cin);
	
	adder_16bit_cas add_high0(out_temp0, ovf_high_temp0, cout_high_temp0, in1[31:16], in2[31:16], 1'b0);
	adder_16bit_cas add_high1(out_temp1, ovf_high_temp1, cout_high_temp1, in1[31:16], in2[31:16], 1'b1);
	
	mux_2_1_16bit mux_high(out[31:16], out_temp0, out_temp1,  cout_low);
	mux_2_1_1bit mux_cout(cout, cout_high_temp0, cout_high_temp1, cout_low);
	mux_2_1_1bit mux_ovf(ovf, ovf_high_temp0, ovf_high_temp1, cout_low);	
	
endmodule


module adder_16bit_cas(out, ovf, cout, in1, in2, cin);
	input [15:0] in1, in2;
	input cin;
	output [15:0] out;
	output ovf, cout;
	
	wire ovf_low, cout_low; // carry out from low 4-bit add and serve as the selector for high 4-bit add
	wire [7:0] out_temp0, out_temp1;
	wire ovf_high_temp0, ovf_high_temp1, cout_high_temp0, cout_high_temp1;
	
	adder_8bit_cas add_low(out[7:0], ovf_low, cout_low, in1[7:0], in2[7:0], cin);
	
	adder_8bit_cas add_high0(out_temp0, ovf_high_temp0, cout_high_temp0, in1[15:8], in2[15:8], 1'b0);
	adder_8bit_cas add_high1(out_temp1, ovf_high_temp1, cout_high_temp1, in1[15:8], in2[15:8], 1'b1);
	
	mux_2_1_8bit mux_high(out[15:8], out_temp0, out_temp1,  cout_low);
	mux_2_1_1bit mux_cout(cout, cout_high_temp0, cout_high_temp1, cout_low);
	mux_2_1_1bit mux_ovf(ovf, ovf_high_temp0, ovf_high_temp1, cout_low);	
	
endmodule

module adder_8bit_cas(out, ovf, cout, in1, in2, cin);
	input [7:0] in1, in2;
	input cin;
	output [7:0] out;
	output ovf, cout;
	
	wire ovf_low, cout_low; 
	wire [3:0] out_temp0, out_temp1;
	wire ovf_high_temp0, ovf_high_temp1, cout_high_temp0, cout_high_temp1;
	
	
	adder_4bit_rca add_low(out[3:0], ovf_low, cout_low, in1[3:0], in2[3:0], cin);
	
	adder_4bit_rca add_high0(out_temp0, ovf_high_temp0, cout_high_temp0, in1[7:4], in2[7:4], 1'b0);
	adder_4bit_rca add_high1(out_temp1, ovf_high_temp1, cout_high_temp1, in1[7:4], in2[7:4], 1'b1);
	
	mux_2_1_4bit mux_high(out[7:4], out_temp0, out_temp1,  cout_low);
	mux_2_1_1bit mux_cout(cout, cout_high_temp0, cout_high_temp1, cout_low);
	mux_2_1_1bit mux_ovf(ovf, ovf_high_temp0, ovf_high_temp1, cout_low);
		
endmodule

module adder_4bit_rca(out, ovf, cout, in1, in2, cin);
	input [3:0] in1, in2;
	input cin;
	output [3:0] out;
	output ovf, cout;
	wire w1, w2, w3;
	
	// 4-bit rca
	adder_1bit add1(out[0], w1, in1[0], in2[0], cin);
	adder_1bit add2(out[1], w2, in1[1], in2[1], w1);
	adder_1bit add3(out[2], w3, in1[2], in2[2], w2);
	adder_1bit add4(out[3], cout, in1[3], in2[3], w3);
	xor xor0 (ovf, w3, cout);

endmodule

// Verilog code for full adder
module adder_1bit(sum, cout, a, b, cin);
	input a, b, cin;
	output sum, cout;
	wire w1, w2, w3;
	
	// sum = a xor b xor cin
	xor xorsum1(w1, a, b);
	xor xorsum2(sum, cin, w1);
	
	// cout = a and b or a and cin or b and cin
	and andcout1(w2, a, b);
	and andcout2(w3, w1, cin);
	or orcout2(cout, w2, w3);
	
endmodule

