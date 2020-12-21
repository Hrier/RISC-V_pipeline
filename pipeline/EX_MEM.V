//流水线 执行-存储 环节
module EX_MEM (
    input wire clk,
    input wire rst,
    input wire EX_MEM_Write,
    input wire[31:0] PC_number_in,
    input wire RegWrite_in,
    input wire MemWrite_in,
    input wire MemRead_in,
    input wire MemtoReg_in,
    input wire[1:0] Branch_in,
    input wire is_jal_in,
    input wire[4:0] Rd_in,
    input wire zero_in,
    input wire[31:0] ALU_result_in,
    input wire[31:0] PC_add_imm_in,
    input wire[31:0] Read_data_2_in,

    output wire[31:0] PC_number_out,
    output wire RegWrite_out,
    output wire MemWrite_out,
    output wire MemRead_out,
    output wire MemtoReg_out,
    output wire[1:0] Branch_out,
    output wire is_jal_out,
    output wire[4:0] Rd_out,
    output wire zero_out,
    output wire[31:0] ALU_result_out,
    output wire[31:0] PC_add_imm_out,
    output wire[31:0] Read_data_2_out,
    output reg not_Forwarding
);
    
reg[12:0] control_Reg;
reg[31:0] data [0:3];

assign PC_number_out = data[0];
assign Read_data_2_out = data[1];
assign ALU_result_out = data[2];
assign PC_add_imm_out = data[3];

assign RegWrite_out = control_Reg[0];
assign MemWrite_out = control_Reg[1];
assign MemRead_out  = control_Reg[2];
assign MemtoReg_out = control_Reg[3];
assign Branch_out   = control_Reg[5:4];
assign is_jal_out   = control_Reg[6];
assign zero_out     = control_Reg[7];
assign Rd_out       = control_Reg[12:8];

always @(posedge clk) begin
    if(EX_MEM_Write && !rst)begin
        data[0] <= PC_number_in;
        data[1] <= Read_data_2_in;
        data[2] <= ALU_result_in;
        data[3] <= PC_add_imm_in;

        control_Reg[0] <= RegWrite_in;
        control_Reg[1] <= MemWrite_in;
        control_Reg[2] <= MemRead_in;
        control_Reg[3] <= MemtoReg_in;
        control_Reg[5:4] <= Branch_in;
        control_Reg[6] <= is_jal_in;
        control_Reg[7] <= zero_in;
        control_Reg[12:8] <= Rd_in;
        not_Forwarding <= 0;
    end else begin
        data[0] <= 32'b0;
        data[1] <= 32'b0;
        data[2] <= 32'b0;
        data[3] <= 32'b0;

        control_Reg[7:0] <= 8'b0;
        control_Reg[12:0] <= 5'b0;    

        not_Forwarding <= 1;    
    end
end

endmodule