module mux4x1 #(
  parameter w = 1
)(
  input  wire [w-1:0] a,
  input  wire [w-1:0] b,
  input  wire [w-1:0] c,
  input  wire [w-1:0] d,
  input  wire         en,
  input  wire [1:0]   sel,
  output reg  [w-1:0] o
);
  always @(*) begin
    if (en) begin
      case (sel)
        2'b00: o = a;
        2'b01: o = b;
        2'b10: o = c;
        2'b11: o = d;
        default: o = {w{1'b0}};
      endcase
    end else
      o = {w{1'b0}};
  end
endmodule
