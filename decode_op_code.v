module decode_op_code (is_alu, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex, is_setx, opcode);
	
	input [4:0] opcode;

	output is_alu, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex, is_setx;
	
	
	assign is_alu  = (~opcode[4]) & (~opcode[3]) & (~opcode[2])    & (~opcode[1]) & (~opcode[0]);    //00000
	assign is_addi = (~opcode[4]) & (~opcode[3]) & opcode[2]    & (~opcode[1]) & opcode[0];    //00101
	assign is_sw   = (~opcode[4]) & (~opcode[3]) & opcode[2]    & opcode[1]    & opcode[0];    //00111
	assign is_lw   = (~opcode[4]) & opcode[3]    & (~opcode[2]) & (~opcode[1]) & (~opcode[0]); //01000
	assign is_j  = (~opcode[4]) & (~opcode[3]) & (~opcode[2])    & (~opcode[1]) & opcode[0];    //00001
	assign is_bne = (~opcode[4]) & (~opcode[3])  & (~opcode[2]) & opcode[1] & (~opcode[0]);	//00010
	assign is_jal = (~opcode[4]) & (~opcode[3])  & (~opcode[2]) & opcode[1] &  opcode[0];	//00011
	assign is_jr = (~opcode[4]) & (~opcode[3])  & (opcode[2]) & ~opcode[1] & (~opcode[0]);	//00100
	assign is_blt = (~opcode[4]) & (~opcode[3])  & (opcode[2]) & opcode[1] & (~opcode[0]);	//00110
	assign is_bex = (opcode[4]) & (~opcode[3])  & (opcode[2]) & opcode[1] & (~opcode[0]);	//10110
	assign is_setx = (opcode[4]) & (~opcode[3])  & (opcode[2]) & ~opcode[1] & (opcode[0]);	//10101

	
endmodule

