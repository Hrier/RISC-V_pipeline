//译码阶段
module ID (
    input wire clk,
    input wire rst,
    input wire[31:0] inst,
    input wire[31:0] Write_data,

    output wire RegWrite,
    output wire ALUSrc,
    output wire MemWrite,
    output wire MemRead,
    output wire MemtoReg,
    output wire[1:0] Branch,
    output wire is_jal,
    output wire[31:0] imm,
    output wire[2:0] ALU_ctl,
    output wire[31:0] Read_data1,
    output wire[31:0] Read_data2  
);

wire[1:0] ALUOp;

Control Control1(
    .inst({inst[14],inst[6:0]}),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .is_jal(is_jal),
    .ALUOp(ALUOp)
);

Registers Registers1(
	.clk(clk),
	.rst(rst),
	.Read_register1(inst[19:15]),
	.Read_register2(inst[24:20]),
	.Write_register(inst[11:7]),
	.Write_data(Write_data),
	.RegWrite(RegWrite),
	.Read_data1(Read_data1),
	.Read_data2(Read_data2)
);

ALU_control ALU_control1(
    .ALUOp(ALUOp),
    .inst({inst[30],inst[14:12]}),
    .ALU_ctl(ALU_ctl)
);

ImmGen ImmGen1(
    .inst(inst),
    .imm1(imm)
);
    
endmodule