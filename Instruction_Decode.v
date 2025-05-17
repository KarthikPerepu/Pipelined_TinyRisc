module control_unit (
  input  wire [31:0] inst,
  output reg         isSt,
  output reg         isLd,
  output reg         isBeq,
  output reg         isBgt,
  output reg         isRet,
  output reg         isImmediate,
  output reg         isWb,
  output reg         isUbranch,
  output reg         isCall,
  output reg         isAdd,
  output reg         isSub,
  output reg         isCmp,
  output reg         isMul,
  output reg         isDiv,
  output reg         isMod,
  output reg         isLsl,
  output reg         isLsr,
  output reg         isAsr,
  output reg         isOr,
  output reg         isAnd,
  output reg         isNot,
  output reg         isMov
);
  wire op1 = inst[27];
  wire op2 = inst[28];
  wire op3 = inst[29];
  wire op4 = inst[30];
  wire op5 = inst[31];

  always @(*) begin
    isSt        = ~op5 &  op4 &  op3 &  op2 &  op1;
    isLd        = ~op5 &  op4 &  op3 &  op2 & ~op1;
    isBeq       =  op5 & ~op4 & ~op3 & ~op2 & ~op1;
    isBgt       =  op5 & ~op4 & ~op3 & ~op2 &  op1;
    isRet       =  op5 & ~op4 &  op3 & ~op2 & ~op1;
    isImmediate =  inst[26];
     isWb=(~(op5|((~op5)&op3&op1&(op4|(~op2))))|(op5&(~op4)&(~op3)&op2&op1));
    isUbranch   =  op5 & ~op4 & ((~op3 & op2) | (op3 & ~op2 & ~op1));
    isCall      =  op5 & ~op4 & ~op3 &  op2 &  op1;
      isAdd =(((~op5) & (~op4) & (~op3) & (~op2) & (~op1)) | ((~op5) & op4 & op3 & op2));
    isSub       = ~op5 & ~op4 & ~op3 & ~op2 &  op1;
    isCmp       = ~op5 & ~op4 &  op3 & ~op2 &  op1;
    isMul       = ~op5 & ~op4 & ~op3 &  op2 & ~op1;
    isDiv       = ~op5 & ~op4 & ~op3 &  op2 &  op1;
    isMod       = ~op5 & ~op4 &  op3 & ~op2 & ~op1;
    isLsl       = ~op5 &  op4 & ~op3 &  op2 & ~op1;
    isLsr       = ~op5 &  op4 & ~op3 &  op2 &  op1;
    isAsr       = ~op5 &  op4 &  op3 & ~op2 & ~op1;
    isOr        = ~op5 & ~op4 &  op3 &  op2 &  op1;
    isAnd       = ~op5 & ~op4 &  op3 &  op2 & ~op1;
    isNot       = ~op5 &  op4 & ~op3 & ~op2 & ~op1;
    isMov       = ~op5 &  op4 & ~op3 & ~op2 &  op1;
  end
endmodule

module OperandFetchUnit (
  input  wire        isRet,
  input  wire        isSt,
  input  wire [3:0]  rs1,
  input  wire [3:0]  rs2,
  input  wire [3:0]  rd,
  input  wire [3:0]  ra,
  output wire [3:0]  inpregfile1,
  output wire [3:0]  inpregfile2
);
  mux2x1 #(.w(4)) m1 (.a(rs1), .b(ra), .sel(isRet), .o(inpregfile1));
  mux2x1 #(.w(4)) m2 (.a(rs2), .b(rd), .sel(isSt),  .o(inpregfile2));
endmodule


module Register_file (
  input  wire        clock,
  input  wire        reset,
  input  wire [3:0]  reg_rd1,
  input  wire [3:0]  reg_rd2,
  output wire [31:0] reg_rd1_out,
  output wire [31:0] reg_rd2_out,
  input  wire [3:0]  reg_wr1,
  input  wire [31:0] reg_wr1_data,
  input  wire        wr1_enable
);
  reg [31:0] register [0:15];
  integer i;
  assign reg_rd1_out = register[reg_rd1];
  assign reg_rd2_out = register[reg_rd2];

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      for (i=0; i<16; i=i+1) register[i] <= 32'd0;
    end else if (wr1_enable) begin
      register[reg_wr1] <= reg_wr1_data;
    end
  end
endmodule


module imm_gen(
    input  [31:0] inst,
    output [31:0] immx,
    input  [31:0] pc,
    output [31:0] branchTarget
);
wire [17:0] imm_field = inst[17:0];
wire [26:0] off = inst[26:0];
wire [31:0] exof = { {3{off[26]}},off, 2'b00 };
wire [15:0] imm16 = imm_field[15:0];
wire mod_u = imm_field[16];
wire mod_h = imm_field[17];
reg [31:0] immx_reg;
always @* begin
    case({mod_h, mod_u})
        2'b00: begin
        immx_reg = {{16{imm16[15]}}, imm16};
        end
        2'b01: begin
            immx_reg = {16'b0, imm16};
        end
        2'b10: begin
            immx_reg = {imm16, 16'b0};
        end
        2'b11: begin
            immx_reg = {{16{imm16[15]}}, imm16};
        end
        default: immx_reg = 32'b0;
    endcase
end

assign immx = immx_reg;
assign branchTarget = pc + exof;
endmodule


