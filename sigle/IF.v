//取指令阶段
module IF(
    input wire clk,
    input wire rst,
    input wire is_branch,
    input wire[31:0] PC_add_imm,
    output wire[31:0] PC_number
);

wire[31:0] PC_add_4;
wire[31:0] PC_in;
wire[31:0] four;

assign four = 32'd4;

Add add1(
    .in1(PC_number),
    .in2(four),
    .out(PC_add_4)
);

MUX mux1(
    .in1(PC_add_imm),
    .in2(PC_add_4),
    .s(is_branch),
    .out(PC_in)
);

PC PC1(
    .clk(clk),
    .rst(rst),
    .in_p_number(PC_in),
    .out_p_number(PC_number)
);

endmodule
