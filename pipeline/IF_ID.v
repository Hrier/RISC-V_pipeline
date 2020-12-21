//流水�? 取指-译码

module IF_ID(
    input wire clk,
    input wire rst,
    input wire IF_ID_Write,
    input wire[31:0] PC_number_in,
    input wire[31:0] inst_in,

    output wire[31:0] PC_number_out,
    output wire[31:0] inst_out,
    output reg not_Forwarding
);

reg[31:0] IF_ID_Reg [0:1];

assign PC_number_out = IF_ID_Reg[0];
assign inst_out = IF_ID_Reg[1];

always@(posedge clk)begin
    if(IF_ID_Write && !rst)begin
        IF_ID_Reg[0] <= PC_number_in;
        IF_ID_Reg[1] <= inst_in;
        not_Forwarding <= 0;
    end else begin
        IF_ID_Reg[0] <= 32'b0;
        IF_ID_Reg[1] <= 32'b0;
        not_Forwarding <= 1;        
    end
end

endmodule