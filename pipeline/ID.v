//译码阶段
module ID (
    input wire clk,
    input wire rst,
    input wire[31:0] inst,
    input wire[31:0] Write_data,
    input wire[4:0] Write_register,
    input wire RegWrite_in,
    input wire Control_on,

    output wire[1:0] ALUOp,
    output wire RegWrite,
    output wire ALUSrc,
    output wire MemWrite,
    output wire MemRead,
    output wire MemtoReg,
    output wire[1:0] Branch,
    output wire is_jal,
    output wire[31:0] imm,
    output wire[31:0] Read_data1,
    output wire[31:0] Read_data2  
);

Control Control1(
    .inst({inst[14],inst[6:0]}),
    .Control_on(Control_on),
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
	.Write_register(Write_register),
	.Write_data(Write_data),
	.RegWrite(RegWrite_in),
	.Read_data1(Read_data1),
	.Read_data2(Read_data2)
);

ImmGen ImmGen1(
    .inst(inst),
    .imm1(imm)
);
    
endmodule