module riscv(

	input wire				 clk,
	input wire				 rst,         // high is reset
	
    // inst_mem
	input wire[31:0]         inst_i,
	output wire[31:0]        inst_addr_o,
	output wire              inst_ce_o,

    // data_mem
	input wire[31:0]         data_i,      // load data from data_mem
	output wire              data_we_o,
    output wire              data_ce_o,
	output wire[31:0]        data_addr_o,
	output wire[31:0]        data_o       // store data to  data_mem

);

//  instance your module  below
assign inst_ce_o = ~rst;

wire PC_Write;
wire Control_on;
wire ID_EX_Write;
wire EX_MEM_Write;
wire guess_branch;

reg is_branch;
wire[31:0] PC_number0;
wire[31:0] PC_add_imm1;

IF IF1(
	.clk(clk),
	.rst(rst),
	.PC_add_imm(PC_add_imm1),
	.is_branch(guess_branch),
	.PC_Write(PC_Write),

	.PC_number(PC_number0)
);
assign inst_addr_o = PC_number0;

wire IF_ID_Write;
wire[31:0] PC_number1;
wire[31:0] inst1;

wire not_Forwarding0;
wire not_Forwarding1;
wire not_Forwarding2;

IF_ID IF_ID1(
	.clk(clk),
	.rst(rst),
	.IF_ID_Write(IF_ID_Write),
	.PC_number_in(PC_number0),
	.inst_in(inst_i),

	.PC_number_out(PC_number1),
	.inst_out(inst1),
	.not_Forwarding(not_Forwarding0)
);

wire RegWrite0;
wire ALUSrc0;
wire MemWrite0;
wire MemRead0;
wire MemtoReg0;
wire[1:0] Branch0;
wire is_jal0;

wire[31:0] imm0;
wire[31:0] Write_data;
wire[31:0] Read_data1_0;
wire[31:0] Read_data2_0;
wire[1:0]  ALUOp0;
wire RegWrite3;
wire[4:0] Rd3;

ID ID1(
	.clk(clk),
	.rst(rst),
	.inst(inst1),
	.RegWrite_in(RegWrite3),
	.Write_data(Write_data),
	.Write_register(Rd3),
	.Control_on(Control_on),

	.ALUOp(ALUOp0),
	.RegWrite(RegWrite0),
	.ALUSrc(ALUSrc0),
	.MemWrite(MemWrite0),
	.MemRead(MemRead0),
	.MemtoReg(MemtoReg0),
	.Branch(Branch0),
	.is_jal(is_jal0),
	.imm(imm0),
	.Read_data1(Read_data1_0),
	.Read_data2(Read_data2_0)
);

wire[31:0] PC_number2;
wire[1:0] ALUOp1;
wire RegWrite1;
wire ALUSrc1;
wire MemWrite1;
wire MemRead1;
wire MemtoReg1;
wire[1:0] Branch1;
wire is_jal1;
wire[31:0] imm1;
wire[31:0] Read_data1_1;
wire[31:0] Read_data2_1;
wire[4:0]  Rs1_1;
wire[4:0]  Rs2_1;
wire[4:0]  Rd_1;
wire[3:0]  EX_inst;

ID_EX ID_EX1(
	.clk(clk),
	.rst(rst),
	.ID_EX_Write(ID_EX_Write),
	.PC_number_in(PC_number1),
	.ALUOp_in(ALUOp0),
	.RegWrite_in(RegWrite0),
	.ALUSrc_in(ALUSrc0),
	.MemWrite_in(MemWrite0),
	.MemRead_in(MemRead0),
	.MemtoReg_in(MemtoReg0),
	.Branch_in(Branch0),
	.is_jal_in(is_jal0),
	.imm_in(imm0),
	.Read_data1_in(Read_data1_0),
	.Read_data2_in(Read_data2_0),
	.Rs1_in(inst1[19:15]),
	.Rs2_in(inst1[24:20]),
	.Rd_in(inst1[11:7]),
	.inst_in({inst1[30],inst1[14:12]}),

	.PC_number_out(PC_number2),
	.ALUOp_out(ALUOp1),
	.RegWrite_out(RegWrite1),
	.ALUSrc_out(ALUSrc1),
	.MemWrite_out(MemWrite1),
	.MemRead_out(MemRead1),
	.MemtoReg_out(MemtoReg1),
	.Branch_out(Branch1),
	.is_jal_out(is_jal1),
	.imm_out(imm1),
	.Read_data1_out(Read_data1_1),
	.Read_data2_out(Read_data2_1),
	.Rs1_out(Rs1_1),
	.Rs2_out(Rs2_1),
	.Rd_out(Rd_1),
	.inst_out(EX_inst),
	.not_Forwarding(not_Forwarding1)
);

wire[1:0] ForwardA;
wire[1:0] ForwardB;

wire[31:0] ALU_result0;
wire zero0;
wire[31:0] PC_add_imm0;
wire[31:0] ALU_result1;

//前递
reg[31:0] rs1,rs2;

always @(*) begin
	case(ForwardA)
		2'b00: rs1 <= Read_data1_1;
		2'b01: rs1 <= Write_data;
		2'b10: rs1 <= ALU_result1;
	endcase

	case(ForwardB)
		2'b00: rs2 <= Read_data2_1;
		2'b01: rs2 <= Write_data;
		2'b10: rs2 <= ALU_result1;
	endcase
end

EX EX1(
	.Read_data1(rs1),
	.Read_data2(rs2),
	.imm(imm1),
	.ALUSrc(ALUSrc1),
	.PC_number(PC_number2),
	.inst(EX_inst),
	.ALUOp(ALUOp1),

	.zero(zero0),
	.ALU_result(ALU_result0),
	.PC_add_imm(PC_add_imm0)
);

wire[31:0] PC_number3;
wire[31:0] Read_data2_2;
wire RegWrite2;
wire MemWrite2;
wire MemRead2;
wire MemtoReg2;
wire[1:0] Branch2;
wire is_jal2;
wire[4:0] Rd_2;
wire zero1;

EX_MEM EX_MEM1(
	.clk(clk),
	.rst(rst),
	.EX_MEM_Write(EX_MEM_Write),
	.PC_number_in(PC_number2),
	.RegWrite_in(RegWrite1),
	.MemWrite_in(MemWrite1),
	.MemRead_in(MemRead1),
	.MemtoReg_in(MemtoReg1),
	.Branch_in(Branch1),
	.is_jal_in(is_jal1),
	.Rd_in(Rd_1),
	.zero_in(zero0),
	.ALU_result_in(ALU_result0),
	.PC_add_imm_in(PC_add_imm0),
	.Read_data_2_in(Read_data2_1),

	.PC_number_out(PC_number3),
	.RegWrite_out(RegWrite2),
	.MemWrite_out(MemWrite2),
	.MemRead_out(MemRead2),
	.MemtoReg_out(MemtoReg2),
	.Branch_out(Branch2),
	.is_jal_out(is_jal2),
	.Rd_out(Rd_2),
	.zero_out(zero1),
	.ALU_result_out(ALU_result1),
	.PC_add_imm_out(PC_add_imm1),
	.Read_data_2_out(Read_data2_2),
	.not_Forwarding(not_Forwarding2)
);

always@(*) begin
	if(is_jal2)begin
		is_branch <= 1;
	end else if(Branch2==2'b01 && zero1==1)begin
		is_branch <= 1;
	end else if(Branch2==2'b10 && ALU_result1==32'b00000001)begin
		is_branch <= 1;
	end else begin
		is_branch <= 0;
	end
end

assign data_o = Read_data2_2;
assign data_addr_o = ALU_result1;
assign data_we_o = MemWrite2;
assign data_ce_o = ~rst;

wire[31:0] Read_data1;
wire[31:0] ALU_result2;
wire[31:0] PC_number4;
wire MemtoReg3;
wire is_jal3;

MEM_WB MEM_WB1(
	.clk(clk),
	.rst(rst),
	.Read_data_in(data_i),
	.ALU_result_in(ALU_result1),
	.Rd_in(Rd_2),
	.MemtoReg_in(MemtoReg2),
	.RegWrite_in(RegWrite2),
	.is_jal_in(is_jal2),
	.PC_number_in(PC_number3),

	.Read_data_out(Read_data1),
	.ALU_result_out(ALU_result2),
	.Rd_out(Rd3),
	.MemtoReg_out(MemtoReg3),
	.RegWrite_out(RegWrite3),
	.is_jal_out(is_jal3),
	.PC_number_out(PC_number4)
);

WB WB1(
	.Read_data(Read_data1),
	.MemtoReg(MemtoReg3),
	.ALU_result(ALU_result2),
	.is_jal(is_jal3),
	.PC_number(PC_number4),
	
	.Write_data(Write_data)
);

Forwarding_unit Forwarding_unit1(
	.rst(rst),
	.EX_MEM_RegWrite(RegWrite2),
	.MEM_WB_RegWrite(RegWrite3),
	.Rs1(Rs1_1),
	.Rs2(Rs2_1),
	.EX_MEM_rd(Rd_2),
	.MEM_WB_rd(Rd3),
	.not_Forwarding0(not_Forwarding0),
	.not_Forwarding1(not_Forwarding1),
	.not_Forwarding2(not_Forwarding2),

	.ForwardA(ForwardA),
	.ForwardB(ForwardB)
);

Hazard_dete Hazard_dete1(
	.clk(clk),
	.ID_EX_MemRead(MemRead1),
	.ID_EX_Rd(Rd_1),
	.IF_ID_Rs1(inst1[19:15]),
	.IF_ID_Rs2(inst1[24:20]),
	.rst(rst),
	.inst(inst1[6:0]),
	.is_branch(is_branch),

	.IF_ID_Write(IF_ID_Write),
	.PC_Write(PC_Write),
	.Control_on(Control_on),
	.ID_EX_Write(ID_EX_Write),
	.EX_MEM_Write(EX_MEM_Write),
	.guess_branch(guess_branch)
);

endmodule