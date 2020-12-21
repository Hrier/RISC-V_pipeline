//执行阶段
module EX (
    input wire[31:0] Read_data1,
    input wire[31:0] Read_data2,
    input wire[31:0] imm,
    input wire ALUSrc,
    input wire[2:0] ALU_ctl,
    input wire[1:0] Branch,
    input wire is_jal,
    input wire[31:0] PC_number,

    output reg is_branch,
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

wire zero;

ALU alu1(
    .ALU_ctl(ALU_ctl),
    .src1(Read_data1),
    .src2(src2),
    .ALU_result(ALU_result),
    .zero(zero)
);

always@(is_jal,Branch) begin
    if(is_jal)begin
        is_branch <= 1;
    end else if(Branch==2'b01 && zero==1)begin
        is_branch <= 1;
    end else if(Branch==2'b10 && ALU_result==1)begin
        is_branch <= 1;
    end else begin
        is_branch <= 0;
    end
end

endmodule