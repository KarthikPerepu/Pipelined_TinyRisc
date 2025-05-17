module mux2x1 #(
  parameter w = 1
)(
  input  wire [w-1:0] a,
  input  wire [w-1:0] b,
  input  wire         sel,
  output reg  [w-1:0] o
);
  always @(*) o = sel ? b : a;
endmodule
