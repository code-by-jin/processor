/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 wire [31:0] pc_in, pc_out;
	 
	 /*Fetch*/
	 // use pc as a register
	 register_32bits pc (pc_next, pc_in, clock, 1'b1, reset); //reg pc;
	 
	 // adder add_0 (pc_out, pc_in, 4) // 4 or 1
	 /*each pc clock: address_imem = address_imem + 12'd4*/
	 
	 assign address_imem = pc[11:0];  //+4
	 
	 
	 
	 // first option for next pc
	 

	 /*random logic: control signals*/
	wire is_alu, is_addi, is_sw, is_lw;
	wire DMwe, Rwe, Rwd, ALUinB, Rdst, ALUop;
	decode_op_code (is_alu, is_addi, is_sw, is_lw, q_imem[31:27]);
	Rwe = xor(is_alu, is_addi, is_lw);	// control regfile write
	ALUinB = xor(is_addi, is_lw, is_sw);
	// Rdst = not is_alu;
	// DMwe = is_sw, data memory write enable
	// Rwd = is_lw, read word enable
	
	wire [4:0] rd, rs, rt, shamt, ctrl_aluop;
	wire [31:0] dst, data_write, data_readA, data_readB, data_operandB;
	wire [16:0] immed;
	shamt = q_imem[11:7];
	immed = q_imem[16:0];
	
	assign ctrl_aluop = is_alu ? q_imem[6:2] : 5'd0; // 1:alu, 0:addition 
	
*	sx_immed //SX: sign extesion part

	/*Regfile set when read*/
	ctrl_writeEnable = 0;
	ctrl_writeReg = q_imem[26:22]; // =rd
	ctrl_readRegA = q_imem[21:17]; // =rs
	ctrl_readRegB = q_imem[16:12]; // =rt
	
	/*alu*/
	assign data_operandB = ALUinB ? sx_immed: data_readRegB;		// mux to choose add operand	
	alu(data_readRegA, data_operandB, ctrl_aluop, shamt, 
			data_result, isNotEqual, isLessThan, overflow);
	
	/*dmem set*/
	address_dmem = data_result[11:0];	//dataresult(address) output to dmem
	data = data_readRegB
	wren = is_lw ? 0 : 1;
	
	/*Regfile set when wirte*/
	data_writeReg = is_lw ? q_dmem : data_result; //mux 1:lw,choose data from d_mem, 0: alu result
	ctrl_writeEnable = Rwe;

endmodule
