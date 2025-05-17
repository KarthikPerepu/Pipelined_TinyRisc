module pipo_ID_EX(
  input clk,
  input rst,
  input [31:0] pc,
  input [31:0] instruction,
  input [31:0] a, b, op2,
  input [21:0] control,
  input [31:0] branchTarget,
  output reg [31:0] pcc, instr, ao, bo, oppo, co, bto
);
  always @(posedge clk or posedge rst) begin
      if (rst) begin
          pcc  <= 32'b0;
          instr<= 32'b0;
          ao   <= 32'b0;
          bo   <= 32'b0;
          oppo <= 32'b0;
          co   <= 22'b0;
          bto  <= 32'b0;
      end else begin
          pcc  <= pc;
          instr<= instruction;
          ao   <= a;
          bo   <= b;
          oppo <= op2;
          co   <= control;
          bto  <= branchTarget;
      end
  end   
endmodule
