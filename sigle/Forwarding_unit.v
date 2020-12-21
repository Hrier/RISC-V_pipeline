//前递单元
module Forwarding_unit (
    input wire EX_MEM_RegWrite,
    input wire MEM_WB_RegWrite,
    input wire[4:0] Rs1,
    input wire[4:0] Rs2,
    input wire[4:0] EX_MEM_rd,
    input wire[4:0] MEM_WB_rd,

    output reg[1:0] ForwardA,
    output reg[1:0] ForwardB
);

always@(*) begin
    if(EX_MEM_RegWrite && EX_MEM_rd != 0)begin
        if(EX_MEM_rd == Rs1)begin
            ForwardA <= 2'b10;
        end else if(MEM_WB_RegWrite && MEM_WB_rd != 0)begin
            if(MEM_WB_rd == Rs1)begin
                ForwardA <= 2'b01;
            end else begin
                ForwardA <= 2'b00;
            end
        end
    end
end

always@(*) begin
    if(EX_MEM_RegWrite && EX_MEM_rd != 0)begin
        if(EX_MEM_rd == Rs2)begin
            ForwardB <= 2'b10;
        end else if(MEM_WB_RegWrite && MEM_WB_rd != 0)begin
            if(MEM_WB_rd == Rs2)begin
                ForwardB <= 2'b01;
            end else begin
                ForwardB <= 2'b00;
            end
        end
    end
end

endmodule