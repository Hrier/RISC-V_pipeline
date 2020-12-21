//流水线 存储-写回
module MEM_WB(
    input wire clk,
    input wire rst,
    input wire[31:0] Read_data_in,
    input wire[31:0] ALU_result_in,
    input wire[31:0] PC_number_in,
    input wire[4:0]  Rd_in,
    input wire MemtoReg_in,
    input wire RegWrite_in,
    input wire is_jal_in,

    output wire[31:0] Read_data_out,
    output wire[31:0] ALU_result_out,
    output wire[31:0] PC_number_out,
    output wire[4:0]  Rd_out,
    output wire MemtoReg_out,
    output wire RegWrite_out,
    output wire is_jal_out
);

reg[31:0] data [0:2];
reg[7:0]  control_Reg;

assign Read_data_out  = data[0];
assign ALU_result_out = data[1];
assign PC_number_out  = data[2];

assign Rd_out       = control_Reg[4:0];
assign MemtoReg_out = control_Reg[5];
assign RegWrite_out = control_Reg[6];
assign is_jal_out   = control_Reg[7];

always @(posedge clk) begin
    if(rst)begin
        data[0] <= 32'b0;
        data[1] <= 32'b0;
        data[2] <= 32'b0;        
        control_Reg[7:5] <= 3'b0;
        control_Reg[4:0] <= 5'b0;
    end else begin
        data[0] <= Read_data_in;
        data[1] <= ALU_result_in;
        data[2] <= PC_number_in;

        control_Reg[4:0] <= Rd_in;
        control_Reg[5] <= MemtoReg_in;
        control_Reg[6] <= RegWrite_in;
        control_Reg[7] <= is_jal_in;
    end
end

endmodule