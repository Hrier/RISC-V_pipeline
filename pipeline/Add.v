//加法器
//作者：Hrier
//最后修改时间：2020年11月30日11:07:23

module Add(
    input wire[31:0] in1,
    input wire[31:0] in2,
    output wire[31:0] out
);

assign out = in1 + in2;

endmodule