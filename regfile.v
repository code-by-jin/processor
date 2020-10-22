module regfile(
	clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB,
	reg1, reg4, reg19, reg20, reg27, reg28, reg29, reg31 // for test only// test only
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
	
	output [31:0] reg1, reg4, reg19, reg20, reg27, reg28, reg29, reg31; 
	
	assign reg1[31:0] = registers[1][31:0];
	assign reg4[31:0] = registers[4][31:0];

	assign reg19[31:0] = registers[19][31:0];
	assign reg20[31:0] = registers[20][31:0];
	assign reg27[31:0] = registers[27][31:0];	
	assign reg28[31:0] = registers[28][31:0];
	assign reg29[31:0] = registers[29][31:0];
	assign reg31[31:0] = registers[31][31:0];
	
endmodule
