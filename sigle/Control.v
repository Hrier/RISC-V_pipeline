//主控单元
//作者：Hrier
//最后修改时间：2020年12月4日14:01:05
module Control (
    input wire[7:0] inst,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemWrite,
    output reg MemRead,
    output reg MemtoReg,
    output reg[1:0] Branch,
    output reg is_jal,
    output reg[1:0] ALUOp
);

always@(*)begin
    case(inst[6:0])
        7'b1101111:begin        //jal
            ALUOp <= 2'b11;
            ALUSrc <= 1;
            MemtoReg <= 0;
            RegWrite <= 1;
            MemRead <= 0;
            MemWrite <= 1;
            Branch <= 1;
            is_jal <= 1;
        end
        7'b0000011:begin        //lw
            ALUOp <= 2'b00;
            ALUSrc <= 1;
            MemtoReg <= 1;
            RegWrite <= 1;
            MemRead <= 1;
            MemWrite <= 0;
            Branch <= 0;
            is_jal <= 0;
        end
        7'b0100011:begin        //sw
            ALUOp <= 2'b00;
            ALUSrc <= 1;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemRead <= 0;
            MemWrite <= 1;
            Branch <= 0;
            is_jal <= 0;
        end
        7'b1100011:begin        //beg或blt
            ALUOp <= 2'b01;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemRead <= 0;
            MemWrite <= 0;   
            is_jal <= 0;    
            if(inst[7])begin
                Branch <= 2'b10;  //blt
            end   
            else begin
                Branch <= 2'b01;  //beq
            end
        end
        7'b0110011:begin        //算术
            ALUOp <= 2'b10;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 1;
            MemRead <= 0;
            MemWrite <= 0;
            Branch <= 0;    
            is_jal <= 0;        
        end
        7'b0010011:begin        //立即数指令
            ALUOp <= 2'b00;
            ALUSrc <= 1;
            MemtoReg <= 0;
            RegWrite <= 1;
            MemRead <= 0;
            MemWrite <= 0;
            Branch <= 0;
            is_jal <= 0;
        end
    endcase
end
    
endmodule