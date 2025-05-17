module EX_MA (
  input clk,
  input rst,
  input [31:0] pc, aluresult, op2, instruction,
  input [21:0] control,
  output reg [31:0] pcc, alo, opo, io,
  output reg [21:0] co
);
  always @(posedge clk or posedge rst) begin
      if (rst) begin
          pcc <= 32'b0;
          alo <= 32'b0;
          opo <= 32'b0;
          io  <= 32'b0;
          co  <= 22'b0;
      end else begin
          pcc <= pc;
          alo <= aluresult;
          opo <= op2;
          io  <= instruction;
          co  <= control;
      end
  end
endmodule
