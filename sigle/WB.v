//写回部分
module WB (
    input wire[31:0] Read_data,
    input wire MemtoReg,
    input wire[31:0] ALU_result,
    input wire is_jal,
    input wire[31:0] PC_number,

    output wire[31:0] Write_data
);

wire[31:0] PC_add_four;
assign PC_add_four = PC_number + 4;

wire[31:0] a;

MUX mux1(
    .in1(Read_data),
    .in2(ALU_result),
    .s(MemtoReg),
    .out(a)
);

MUX mux2(
    .in1(PC_add_four),
    .in2(a),
    .s(is_jal),
    .out(Write_data)
);

endmodule