module MA_RW (
  input clk, rst,
  input [31:0] pc, ldresult, aluresult, instruction,
  input  wire [21:0] control,
  output reg [31:0] pcc, ldo, alo, io,
  output reg [21:0] co
);
  always @(posedge clk or posedge rst) begin
      if (rst) begin
          pcc <= 32'b0;
          ldo <= 32'b0;
          alo <= 32'b0;
          io  <= 32'b0;
          co  <= 22'd0;
      end else begin
          pcc <= pc;
          ldo <= ldresult;
          alo <= aluresult;
          io  <= instruction;
          co  <= control;
      end
  end
endmodule
