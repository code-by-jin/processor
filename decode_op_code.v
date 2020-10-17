module decode_op_code (is_alu, is_addi, is_sw, is_lw, DMwe, Rwe, Rwd, Rdst, ALUinB, opcode);
	
	input [4:0] opcode;
	
	output is_alu, is_addi, is_sw, is_lw, DMwe, Rwe, Rwd, Rdst, ALUinB;
	
	
	assign is_alu  = (~opcode[4]) & (~opcode[3]) & opcode[2]    & (~opcode[1]) & opcode[0];    //00000
	assign is_addi = (~opcode[4]) & (~opcode[3]) & opcode[2]    & (~opcode[1]) & opcode[0];    //00101
	assign is_sw   = (~opcode[4]) & (~opcode[3]) & opcode[2]    & opcode[1]    & opcode[0];    //00111
	assign is_lw   = (~opcode[4]) & opcode[3]    & (~opcode[2]) & (~opcode[1]) & (~opcode[0]); //01000
	
	assign DMwe = is_sw;
	assign Rwe  = is_alu | is_addi | is_lw;
	assign Rwd  = is_lw;
	assign Rdst = ~is_alu;
	assign ALUinB = is_addi | is_sw | is_lw;
	
endmodule
