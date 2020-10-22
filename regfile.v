module regfile(
	clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB,
	reg1, reg2, reg3, reg4, reg6, reg7, reg9
);
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB;

	reg[31:0] registers[31:0];
	
	always @(posedge clock or posedge ctrl_reset)
	begin
		if(ctrl_reset)
			begin
				integer i;
				for(i = 0; i < 32; i = i + 1)
					begin
						registers[i] = 32'd0;
					end
			end
		else
			if(ctrl_writeEnable && ctrl_writeReg != 5'd0)
				registers[ctrl_writeReg] = data_writeReg;
	end
	
	assign data_readRegA = registers[ctrl_readRegA];
	assign data_readRegB = registers[ctrl_readRegB];
	
	output [31:0] reg1, reg2, reg3, reg4, reg6, reg7, reg9;

	
	assign reg1[31:0] = registers[1][31:0];
	assign reg2[31:0] = registers[2][31:0];
	assign reg3[31:0] = registers[3][31:0];
	assign reg4[31:0] = registers[4][31:0];
	assign reg6[31:0] = registers[6][31:0];
	assign reg7[31:0] = registers[7][31:0];
	assign reg9[31:0] = registers[9][31:0];
/*	assign reg10[31:0] = registers[10][31:0];
	assign reg12[31:0] = registers[12][31:0];
	
	assign reg20[31:0] = registers[20][31:0];
	assign reg21[31:0] = registers[21][31:0];	
	assign reg22[31:0] = registers[22][31:0];
	assign reg23[31:0] = registers[23][31:0];
	assign reg24[31:0] = registers[24][31:0];
	assign reg25[31:0] = registers[25][31:0];
	assign reg26[31:0] = registers[26][31:0];
	
	assign reg19[31:0] = registers[19][31:0];
	assign reg27[31:0] = registers[27][31:0];	
	assign reg28[31:0] = registers[28][31:0];
	assign reg29[31:0] = registers[29][31:0];
	assign reg30[31:0] = registers[30][31:0];
	assign reg31[31:0] = registers[31][31:0];*/
	
endmodule
