//流水线 译码-执行
module ID_EX(
    input wire clk,
    input wire rst,
    input wire ID_EX_Write,
    input wire[31:0] PC_number_in,
    input wire[1:0]ALUOp_in,
    input wire RegWrite_in,
    input wire ALUSrc_in,
    input wire MemWrite_in,
    input wire MemRead_in,
    input wire MemtoReg_in,
    input wire[1:0] Branch_in,
    input wire is_jal_in,
    input wire[31:0] imm_in,
    input wire[31:0] Read_data1_in,
    input wire[31:0] Read_data2_in,
    input wire[4:0] Rs1_in,
    input wire[4:0] Rs2_in,
    input wire[4:0] Rd_in,
    input wire[3:0] inst_in,

    output wire[31:0] PC_number_out,
    output wire[1:0]ALUOp_out,
    output wire RegWrite_out,
    output wire ALUSrc_out,
    output wire MemWrite_out,
    output wire MemRead_out,
    output wire MemtoReg_out,
    output wire[1:0] Branch_out,
    output wire is_jal_out,
    output wire[31:0] imm_out,
    output wire[31:0] Read_data1_out,
    output wire[31:0] Read_data2_out,
    output wire[4:0] Rs1_out,
    output wire[4:0] Rs2_out,
    output wire[4:0] Rd_out,
    output wire[3:0] inst_out,
    output reg not_Forwarding
);

reg[9:0] control_Reg;
reg[31:0] data [0:3];
reg[4:0] Rs_Rd [0:2];
reg[3:0] inst;

assign PC_number_out = data[0];
assign imm_out = data[1];
assign Read_data1_out = data[2];
assign Read_data2_out = data[3];

assign ALUOp_out    = control_Reg[1:0];
assign RegWrite_out = control_Reg[2];
assign ALUSrc_out   = control_Reg[3];
assign MemWrite_out = control_Reg[4];
assign MemRead_out  = control_Reg[5];
assign MemtoReg_out = control_Reg[6];
assign Branch_out   = control_Reg[8:7];
assign is_jal_out   = control_Reg[9];

assign Rs1_out = Rs_Rd[0];
assign Rs2_out = Rs_Rd[1];
assign Rd_out  = Rs_Rd[2];

assign inst_out = inst;

always @(posedge clk) begin
    if(ID_EX_Write && !rst)begin
        data[0] <= PC_number_in;
        data[1] <= imm_in;
        data[2] <= Read_data1_in;
        data[3] <= Read_data2_in;

        control_Reg[1:0] <= ALUOp_in;
        control_Reg[2] <= RegWrite_in;
        control_Reg[3] <= ALUSrc_in;
        control_Reg[4] <= MemWrite_in;
        control_Reg[5] <= MemRead_in;
        control_Reg[6] <= MemtoReg_in;
        control_Reg[8:7] <= Branch_in;
        control_Reg[9] <= is_jal_in;

        Rs_Rd[0] <= Rs1_in;
        Rs_Rd[1] <= Rs2_in;
        Rs_Rd[2] <= Rd_in; 

        inst <= inst_in;

        not_Forwarding <= 0;
    end else begin
        data[0] <= 32'b0;
        data[1] <= 32'b0;
        data[2] <= 32'b0;
        data[3] <= 32'b0;

        control_Reg <= 10'b0;

        Rs_Rd[0] <= 5'b0;
        Rs_Rd[1] <= 5'b0;
        Rs_Rd[2] <= 5'b0;   

        inst <= 4'b0;    

        not_Forwarding <= 1; 
    end
end

endmodule