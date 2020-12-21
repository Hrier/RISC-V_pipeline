module riscv(

	input wire				 clk,
	input wire				 rst,         // high is reset
	
    // inst_mem
	input wire[31:0]         inst_i,
	output wire[31:0]        inst_addr_o,
	output wire              inst_ce_o,

    // data_mem
	input wire[31:0]         data_i,      // load data from data_mem
	output wire              data_we_o,
    output wire              data_ce_o,
	output wire[31:0]        data_addr_o,
	output wire[31:0]        data_o       // store data to  data_mem

);

//  instance your module  below
assign inst_ce_o = 1'b1;

wire[31:0] imm;
wire is_branch;
wire[31:0] PC_number;
wire[31:0] PC_add_imm;

IF IF1(
	.clk(clk),
	.rst(rst),
	.PC_add_imm(PC_add_imm),
	.is_branch(is_branch),

	.PC_number(PC_number)
);
assign inst_addr_o = PC_number;

wire RegWrite;
wire ALUSrc;
wire MemWrite;
wire MemRead;
wire MemtoReg;
wire[1:0] Branch;
wire is_jal;
wire[2:0] ALU_ctl;

wire[31:0] Write_data;
wire[31:0] Read_data1;
wire[31:0] Read_data2;

ID ID1(
	.clk(clk),
	.rst(rst),
	.inst(inst_i),
	.RegWrite(RegWrite),

	.Write_data(Write_data),
	.ALUSrc(ALUSrc),
	.MemWrite(MemWrite),
	.MemRead(MemRead),
	.MemtoReg(MemtoReg),
	.Branch(Branch),
	.is_jal(is_jal),
	.imm(imm),
	.ALU_ctl(ALU_ctl),
	.Read_data1(Read_data1),
	.Read_data2(Read_data2)
);

wire[31:0] ALU_result;

EX EX1(
	.Read_data1(Read_data1),
	.Read_data2(Read_data2),
	.imm(imm),
	.ALUSrc(ALUSrc),
	.ALU_ctl(ALU_ctl),
	.Branch(Branch),
	.is_jal(is_jal),
	.PC_number(PC_number),

	.is_branch(is_branch),
	.ALU_result(ALU_result),
	.PC_add_imm(PC_add_imm)
);

assign data_o = Read_data2;
assign data_addr_o = ALU_result;
assign data_we_o = MemWrite;
assign data_ce_o = ~rst;


WB WB1(
	.Read_data(data_i),
	.MemtoReg(MemtoReg),
	.ALU_result(ALU_result),
	.is_jal(is_jal),
	.PC_number(PC_number),
	
	.Write_data(Write_data)
);

endmodule