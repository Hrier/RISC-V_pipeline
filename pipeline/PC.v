//计数器PC
//作者：Hrier
//最后修改时间：2020/11/29

module PC ( 
    input wire clk,
    input wire rst,
    input wire PC_Write,

    input wire[31:0] in_p_number,
    output wire[31:0] out_p_number
);

reg[31:0] counter;

always @(posedge clk) begin
    if(rst)begin
        counter <= 0;
    end else if(PC_Write) begin
        counter <= in_p_number;
    end
end

assign out_p_number = counter;

endmodule