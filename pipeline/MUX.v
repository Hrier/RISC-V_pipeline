//多路分配器
//作者：Hrier
//最后修改时间：2020年11月30日11:12:19

module MUX(
    input wire[31:0] in1,
    input wire[31:0] in2,
    input wire s,
    output wire[31:0] out
);

assign out = s?in1:in2;

endmodule