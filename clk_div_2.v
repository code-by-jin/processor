module clk_div_2 (clk_out, clk, clr);
	output reg clk_out;
	input clk, clr;  
   

   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           clk_out <= 1'b0;
       end else begin
           clk_out <= ~clk_out;
       end
   end
	endmodule
	