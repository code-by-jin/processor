module decode_op_code (is_alu, is_addi, is_sw, is_lw, DMwe, Rwe, Rwd, ALUinB, BR, JP, opcode);
	
	input [4:0] opcode;
	wire is_beq, is_j;
	output is_alu, is_addi, is_sw, is_lw, DMwe, Rwe, Rwd[1:0], ALUinB, BR, JP;
	
	
	assign is_alu  = (~opcode[4]) & (~opcode[3]) & (~opcode[2])    & (~opcode[1]) & (~opcode[0]);    //00000
	assign is_addi = (~opcode[4]) & (~opcode[3]) & opcode[2]    & (~opcode[1]) & opcode[0];    //00101
	assign is_sw   = (~opcode[4]) & (~opcode[3]) & opcode[2]    & opcode[1]    & opcode[0];    //00111
	assign is_lw   = (~opcode[4]) & opcode[3]    & (~opcode[2]) & (~opcode[1]) & (~opcode[0]); //01000
	assign is_beq = (~opcode[4]) & (~opcode[3])  & (~opcode[2]) & opcode[1] & (~opcode[0]);	//00010
	assign is_j  = (~opcode[4]) & (~opcode[3]) & (~opcode[2])    & (~opcode[1]) & opcode[0];    //00001
	
	assign DMwe = is_sw;
	assign Rwe  = is_alu | is_addi | is_lw;
	assign Rwd  = is_lw;
	assign Rdst = ~is_alu;
	assign ALUinB = is_addi | is_sw | is_lw;
	assign BR = is_beq;
	assign JP = is_j;
	
endmodule

