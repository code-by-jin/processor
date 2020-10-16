module register_32bits(q, d, clk, en, clr);
//Register for 32 bit 

	//Inputs
   input [31:0] d;
	input clk, en, clr;

   //Output
   output [31:0] q;
	
	genvar i;
   generate
     for (i = 0; i < 32; i = i + 1) begin: register_intialize
   	dffe_ref dff(q[i], d[i], clk, en, clr);
     end
   endgenerate
	
	
endmodule