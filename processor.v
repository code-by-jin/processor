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
	/*random logic: control signals*/
	wire [31:0] pc, pc_next;
	wire is_alu, is_addi, is_sw, is_lw;
	wire DMwe, Rwe, Rwd, Rdst, ALUinB;	
	wire [4:0] rd, rs, rt, shamt, ALU_op;
	wire [31:0] data_operandB, sx_immed, data_result;
	wire isNotEqual, isLessThan, overflow, isNotEqual_pc, isLessThan_pc, overflow_pc;
	
	//Instruction Fetch
	register_32bits pc_fetch (pc, pc_next, clock, 1'b1, reset); //reg pc: pc_next -> pc
	
	/*imem*/
	assign address_imem = pc[11:0];  //output
	
	//Instruction Decode
	decode_op_code decode_op (is_alu, is_addi, is_sw, is_lw, DMwe, Rwe, Rwd, ALUinB, q_imem[31:27]);
	
	assign ALU_op = is_alu ? q_imem[6:2] : 5'd0;   // alu if 1
	
	assign shamt  = is_alu ? q_imem[11:7] : 5'd0;  // alu if 1
 	
	// assign rt = is_alu ? q_imem[16:12] : 5'd0;
	assign rt = q_imem[16:12];
	assign rs = q_imem[21:17];
	assign rd = q_imem[26:22];
	
	//Operand Fetch
	/*SX: sign extesion part*/
	assign sx_immed[31:16] = q_imem[16] ? 16'hFFFF:16'h0000;
	assign sx_immed[15:0] = q_imem[15:0]; 

	// Execute
	/*alu*/
	assign data_operandB = ALUinB ? sx_immed: data_readRegB;		// mux to choose add operand	
	alu alu_op (data_readRegA, data_operandB, ALU_op, shamt, data_result, isNotEqual, isLessThan, overflow);
	
	//Determine $rstatus value
	assign is_add = is_alu & (~ALU_op[4]) & (~ALU_op[3]) & (~ALU_op[2]) & (~ALU_op[1]) & (~ALU_op[0]); // 00000
	assign is_sub = is_alu & (~ALU_op[4]) & (~ALU_op[3]) & (~ALU_op[2]) & (~ALU_op[1]) & (ALU_op[0]); // 00001
	assign ovf_label = overflow ? (is_add? 32'd1 : (is_addi? 32'd2 : 32'd3)) : 32'd0; // add->1; addi->2; sub->3

	
	// Result Store
	/*dmem*/
	assign address_dmem = data_result[11:0];	//dataresult(address) output to dmem
	assign data = data_readRegB; // output
	
	assign wren = DMwe; // output, when is_sw
			
	/*Regfile*/
	assign ctrl_writeEnable = Rwe; //output
	assign ctrl_readRegA = rs; //output
	assign ctrl_readRegB = DMwe ? rd : rt; //output	
	assign ctrl_writeReg = overflow? 5'd30 : rd; //output
	
	//output, if Rwd(is_lw): q_dmem; else: data_result(alu_output)
	assign data_writeReg = overflow? ovf_label : (Rwd ? q_dmem : data_result); 
	
	//Next Instruction
	alu (pc, 32'd1, 5'd0, 5'd0, pc_next, isNotEqual_pc, isLessThan_pc, overflow_pc); // pc -> pc_next
	
endmodule
