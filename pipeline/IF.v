//取指令阶段
module IF(
    input wire clk,
    input wire rst,
    input wire is_branch,
    input wire PC_Write,
    input wire[31:0] PC_add_imm,
    output wire[31:0] PC_number
);

reg[31:0] PC_add_4;
wire[31:0] PC_in;

always @(*) begin
    if(rst)begin
        PC_add_4 <= 0;
    end begin
        PC_add_4 <= PC_number + 4;
    end
end

MUX mux1(
    .in1(PC_add_imm),
    .in2(PC_add_4),
    .s(is_branch),
    .out(PC_in)
);

PC PC1(
    .clk(clk),
    .rst(rst),
    .PC_Write(PC_Write),
    .in_p_number(PC_in),
    .out_p_number(PC_number)
);

endmodule
