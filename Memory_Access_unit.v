module flag_reg (
input clk, 
  input isCmp,
  input cmp_g,
  input cmp_e,
  output reg ocmp_g,
  output reg ocmp_e 

);
always @(posedge clk)
begin
if(isCmp)
begin
  ocmp_g<=cmp_g;
  ocmp_e<=cmp_e;
end
end

endmodule
