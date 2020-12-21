//执行阶段
module EX (
    input wire[31:0] Read_data1,
    input wire[31:0] Read_data2,
    input wire[31:0] imm,
    input wire ALUSrc,
    input wire[31:0] PC_number,
    input wire[3:0] inst,
    input wire[1:0] ALUOp,

    output wire zero,
    output wire[31:0] ALU_result,
    output wire[31:0] PC_add_imm
);

wire[31:0] src2;

MUX mux1(
    .in1(imm),
    .in2(Read_data2),
    .s(ALUSrc),
    .out(src2)
);

wire[31:0] imm1;
assign imm1 = imm << 1;

Add add1(
    .in1(imm1),
    .in2(PC_number),
    .out(PC_add_imm)
);

wire[2:0] ALU_ctl;

ALU_control ALU_control1(
    .ALUOp(ALUOp),
    .inst(inst),
    .ALU_ctl(ALU_ctl)
);

ALU alu1(
    .ALU_ctl(ALU_ctl),
    .src1(Read_data1),
    .src2(src2),
    .ALU_result(ALU_result),
    .zero(zero)
);

endmodule