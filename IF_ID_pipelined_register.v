module pipo_IF_ID (
  input [31:0] pc,
  input [31:0] instruction,
  input clk,
  input rst,
  output reg [31:0] pcc,
  output reg [31:0] instructiono
);
  always @(posedge clk or posedge rst) begin
      if (rst) begin
          pcc <= 32'b0;
          instructiono <= 32'b0;
      end else begin
          pcc <= pc;
          instructiono <= instruction;
      end
  end 
endmodule
