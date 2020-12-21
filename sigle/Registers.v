//CPU 寄存器组 32个寄存器
//作者：Hrier
//最后修改日期：2020/11/29 先大概写写以后再改
module Registers (
    input wire clk,
    input wire rst,
    input wire[4:0] Read_register1,
    input wire[4:0] Read_register2,
    input wire[4:0] Write_register,
    input wire[31:0] Write_data,
    input wire RegWrite,

    output wire[31:0] Read_data1,
    output wire[31:0] Read_data2
);

reg[31:0] register [0:31];

assign Read_data1 = register[Read_register1];
assign Read_data2 = register[Read_register2];

always @(posedge clk or negedge clk) begin
    if(rst)begin
        register[0] <= 32'b0;
    end else if(RegWrite && Write_register!=0)begin
        register[Write_register] <= Write_data;
    end
end

endmodule