//风险探测
module Hazard_dete (
    input wire clk,
    input wire ID_EX_MemRead,
    input wire[4:0] ID_EX_Rd,
    input wire[4:0] IF_ID_Rs1,
    input wire[4:0] IF_ID_Rs2,
    input wire[6:0] inst,
    input wire is_branch,
    input wire rst,

    output reg ID_EX_Write,
    output reg EX_MEM_Write,
    output reg IF_ID_Write,
    output reg PC_Write,
    output reg Control_on,
    output reg guess_branch
);

reg count_flag;
reg[1:0] count;

always @(*) begin
    if(rst)begin
        guess_branch <= 0;
    end else if(count==2'b01)begin
        guess_branch <= is_branch;
    end else begin
        guess_branch <= 0;
    end
end

always @(posedge clk) begin
    if(rst)begin
        count_flag <= 0;
    end else if(inst==7'b1101111 || inst==7'b1100011)begin
        count_flag <= 1;
    end else if(count==2'b01) begin
        count_flag <= 0;
    end
end

always @(posedge clk) begin
    if(rst)begin
        count <= 2'b00;
    end else if(count_flag && count!=2'b01)begin
        count <= count + 1;
    end else begin
        count <= 2'b00;
    end
end

always@(*)begin
    if(rst)begin
        IF_ID_Write <= 1;
        PC_Write <= 1;
        Control_on <= 1;
        ID_EX_Write <= 1;
        EX_MEM_Write <= 1;        
    end else begin
        if(ID_EX_MemRead&&((ID_EX_Rd==IF_ID_Rs1)||(ID_EX_Rd==IF_ID_Rs2)))begin
            IF_ID_Write <= 0;
            PC_Write <= 0;
            Control_on <= 0;
        end else begin
            IF_ID_Write <= 1;
            PC_Write <= 1;
            Control_on <= 1;        
        end

        if(guess_branch)begin
            IF_ID_Write <= 0;
            ID_EX_Write <= 0;
            EX_MEM_Write <= 0;
            Control_on <= 0;            
        end else begin
            Control_on <= 1; 
            ID_EX_Write <= 1;
            EX_MEM_Write <= 1;   
            IF_ID_Write <= 1;                 
        end
    end
end

endmodule