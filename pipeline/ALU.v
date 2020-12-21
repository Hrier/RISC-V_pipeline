//运算单元
//作者：Hrier
//最后修改日期：2020年11月30日11:19:39

module ALU(
    input wire[2:0] ALU_ctl,
    input wire[31:0] src1,
    input wire[31:0] src2,
    output reg[31:0] ALU_result,
    output reg zero
);

always@(*) begin
    case(ALU_ctl)
        3'b000: ALU_result <= src1 & src2;   //and
        3'b001: ALU_result <= src1 | src2;   //or
        3'b010: ALU_result <= src1 + src2;   //add
        3'b011: ALU_result <= src1 - src2;   //subtract
        3'b100: ALU_result <= src1<src2 ? 1:0;   //比较
        3'b101: ALU_result <= src1 ^ src2;    //xor
        3'b110: ALU_result <= src1 << src2;   //左移
        3'b111: ALU_result <= src1 >> src2;   //右移
    endcase
end

always@(*) begin
    if(ALU_result==32'b0)begin
        zero <= 1;
    end else begin
        zero <= 0;
    end
end


endmodule