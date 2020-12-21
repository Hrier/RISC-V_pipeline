//ALU控制单元
//作者：Hrier
//最后修改日期：2020年12月4日13:11:11

module ALU_control(
    input wire[1:0] ALUOp,
    input wire[3:0] inst,
    output reg[2:0] ALU_ctl
);

always@(ALUOp,inst)begin
    case(ALUOp)
        2'b00: ALU_ctl <= 3'b010;       //addi或sw或lw
        2'b01:begin                     //分支操作
            if(inst[2])begin            //blt
                ALU_ctl <= 3'b100;
            end else begin              //beq
                ALU_ctl <= 3'b011;
            end
        end
        2'b10:begin                     //R型指令
            if(inst[3])begin
                ALU_ctl <= 3'b011;              //sub
            end else begin
                case(inst[2:0])
                    3'b000: ALU_ctl <= 3'b010;  //add
                    3'b001: ALU_ctl <= 3'b110;  //sll
                    3'b100: ALU_ctl <= 3'b101;  //xor
                    3'b101: ALU_ctl <= 3'b111;  //srl
                    3'b110: ALU_ctl <= 3'b001;  //or
                    3'b111: ALU_ctl <= 3'b000;  //and
                endcase
            end
        end
        2'b11: ALU_ctl <= 3'b010;               //jal
    endcase
end

endmodule