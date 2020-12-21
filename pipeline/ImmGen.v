//立即数产生
//作者：Hrier
//最后修改日期：2020/11/29
module ImmGen (
    input wire[31:0] inst,
    output wire[31:0] imm1
);

reg[31:0] imm;

assign imm1 = imm;

always@(*) begin
    if(inst[6:0]==7'b1101111) begin //jal
        imm = {{12{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21]};
    end else if(inst[6:0]==7'b1100011) begin //beq or blt
        imm = {{20{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8]};
    end else if(inst[6:0]==7'b0000011 || inst[6:0]==7'b0010011) begin //lw or addi
        imm = {{20{inst[31]}},inst[31:20]};
    end else if(inst[6:0]==7'b0100011) begin //sw
        imm = {{20{inst[31]}},inst[31:25],inst[11:7]};
    end else begin
        imm = 32'b0;
    end
end

endmodule