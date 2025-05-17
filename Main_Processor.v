module Final_Pipelined (
  input  wire        clk,
  input  wire        rst
);

  // === IF Stage ===
  wire        isBranchTaken_IF;
  wire [31:0] branchPC_IF, instruction_IF, pc_IF;
 wire [31:0] branchPC_EX;
  wire        isBranchTaken_EX;
  instructionfetch IF (
    .clk(clk),
    .rst(rst),
    .isbranchtaken(isBranchTaken_EX),
    .branchpc(branchPC_EX),
    .instruct(instruction_IF),
    .lo(pc_IF)
  );

  // IF/ID Pipeline Register
  wire [31:0] pc_ID, instr_ID;
  pipo_IF_ID IF_ID (
    .pc(pc_IF),
    .instruction(instruction_IF),
    .clk(clk),
    .rst(rst),
    .pcc(pc_ID),
    .instructiono(instr_ID)
  );

  // === ID Stage ===
  // Control Unit
  wire isSt_ID, isLd_ID, isBeq_ID, isBgt_ID, isRet_ID;
  wire isImmediate_ID, isWb_ID, isUbranch_ID, isCall_ID;
  wire isAdd_ID, isSub_ID, isCmp_ID;
  wire isMul_ID, isDiv_ID, isMod_ID;
  wire isLsl_ID, isLsr_ID, isAsr_ID;
  wire isOr_ID, isAnd_ID, isNot_ID, isMov_ID;

  control_unit CU (
    .inst(instr_ID),
    .isSt(isSt_ID), .isLd(isLd_ID), .isBeq(isBeq_ID), .isBgt(isBgt_ID), .isRet(isRet_ID),
    .isImmediate(isImmediate_ID), .isWb(isWb_ID), .isUbranch(isUbranch_ID), .isCall(isCall_ID),
    .isAdd(isAdd_ID), .isSub(isSub_ID), .isCmp(isCmp_ID),
    .isMul(isMul_ID), .isDiv(isDiv_ID), .isMod(isMod_ID),
    .isLsl(isLsl_ID), .isLsr(isLsr_ID), .isAsr(isAsr_ID),
    .isOr(isOr_ID),   .isAnd(isAnd_ID), .isNot(isNot_ID), .isMov(isMov_ID)
  );

  // Pack control signals into vector
  wire [21:0] c_ID = { isSt_ID, isLd_ID, isBeq_ID, isBgt_ID, isRet_ID,
                          isImmediate_ID, isWb_ID, isUbranch_ID, isCall_ID,
                          isAdd_ID, isSub_ID, isCmp_ID, isMul_ID, isDiv_ID,
                          isMod_ID, isLsl_ID, isLsr_ID, isAsr_ID,
                          isOr_ID, isAnd_ID, isNot_ID, isMov_ID };

  // Operand Fetch and Register File
  wire [3:0] rd_ID   = instr_ID[25:22];
  wire [3:0] rs1_ID  = instr_ID[21:18];
  wire [3:0] rs2_ID  = instr_ID[17:14];
  wire [3:0] ra      = 4'd15;
  wire [3:0] inp1_ID, inp2_ID;
  wire [31:0] reg1_out_ID, reg2_out_ID;

  OperandFetchUnit OFU (
    .isRet(isRet_ID), .isSt(isSt_ID),
    .rs1(rs1_ID), .rs2(rs2_ID), .rd(rd_ID), .ra(ra),
    .inpregfile1(inp1_ID), .inpregfile2(inp2_ID)
  );
  wire [21:0] c_WB;
  wire [31:0] wb_data;
  wire [3:0]  wb_addr;
  Register_file RF (
    .clock(clk), .reset(rst),
    .reg_rd1(inp1_ID), .reg_rd2(inp2_ID),
    .reg_rd1_out(reg1_out_ID), .reg_rd2_out(reg2_out_ID),
    .reg_wr1(wb_addr), .reg_wr1_data(wb_data), .wr1_enable(c_WB[15])
  );

  // Immediate Generation
  wire [31:0] imm_ID, branchTarget_ID;
  imm_gen IMG (
    .inst(instr_ID),
    .immx(imm_ID),
    .pc(pc_ID),
    .branchTarget(branchTarget_ID)
  );

  // === ID/EX Pipeline Register ===
  wire [31:0] pc_EX, instr_EX;
  wire [31:0] reg1_EX, reg2_EX, imm_EX, branchTarget_EX;
  wire [21:0] c_EX;
  pipo_ID_EX ID_EX (
    .clk(clk), .rst(rst),
    .pc(pc_ID), .instruction(instr_ID),
    .a(reg1_out_ID), .b(reg2_out_ID), .op2(imm_ID),
    .control(c_ID), .branchTarget(branchTarget_ID),
    .pcc(pc_EX), .instr(instr_EX), .ao(reg1_EX), .bo(reg2_EX),
    .oppo(imm_EX), .co(c_EX), .bto(branchTarget_EX)
  );

  // === EX Stage ===
  // Unpack control signals
  wire isSt_EX        = c_EX[21];
  wire isLd_EX        = c_EX[20];
  wire isBeq_EX       = c_EX[19];
  wire isBgt_EX       = c_EX[18];
  wire isRet_EX       = c_EX[17];
  wire isImmediate_EX = c_EX[16];
  wire isWb_EX        = c_EX[15];
  wire isUbranch_EX   = c_EX[14];
  wire isCall_EX      = c_EX[13];
  wire isAdd_EX       = c_EX[12];
  wire isSub_EX       = c_EX[11];
  wire isCmp_EX       = c_EX[10];
  wire isMul_EX       = c_EX[9];
  wire isDiv_EX       = c_EX[8];
  wire isMod_EX       = c_EX[7];
  wire isLsl_EX       = c_EX[6];
  wire isLsr_EX       = c_EX[5];
  wire isAsr_EX       = c_EX[4];
  wire isOr_EX        = c_EX[3];
  wire isAnd_EX       = c_EX[2];
  wire isNot_EX       = c_EX[1];
  wire isMov_EX       = c_EX[0];

  // ALU operand B MUX
  wire [31:0] aluB_EX;
  mux2x1 #(.w(32)) imm_mux_EX (
    .a(reg2_EX),
    .b(imm_EX),
    .sel(isImmediate_EX),
    .o(aluB_EX)
  );

  // ALU
  wire [31:0] aluResult_EX;
  wire        cout_EX, cmp_g_EX, cmp_e_EX;

  ALU ALU_E (
    .a(reg1_EX), .b(aluB_EX),
    .isAdd(isAdd_EX), .isSub(isSub_EX), .isCmp(isCmp_EX),
    .isMul(isMul_EX), .isDiv(isDiv_EX), .isMod(isMod_EX),
    .isOr(isOr_EX), .isNot(isNot_EX), .isAnd(isAnd_EX), .isMov(isMov_EX),
    .isAsl(isLsl_EX), .isAsr(isAsr_EX), .isLsr(isLsr_EX), .isLsl(isLsl_EX),
    .isSt(isSt_EX), .isLd(isLd_EX),
    .rs11(), .rs22(),
    .aluResult(aluResult_EX),
    .cout(cout_EX), .cmp_g(cmp_g_EX), .cmp_e(cmp_e_EX)
  );

  // Branch Unit
  wire ocmp_g_EX, ocmp_e_EX;
  wire [1:0] flag_EX;
  flag_reg FLG (
    .clk(clk), .isCmp(isCmp_EX),
    .cmp_g(cmp_g_EX), .cmp_e(cmp_e_EX),
    .ocmp_g(ocmp_g_EX), .ocmp_e(ocmp_e_EX)
  );
  assign flag_EX = {ocmp_e_EX, ocmp_g_EX};

 
 
  branchunit BU (
    .branchTarget(branchTarget_EX),
    .op1(reg1_EX),
    .isBeq(isBeq_EX), .isBgt(isBgt_EX), .isUbranch(isUbranch_EX),
    .flag(flag_EX), .isRet(isRet_EX), .isCall(isCall_EX),
    .branchPC(branchPC_EX),
    .isBranchTaken(isBranchTaken_EX)
  );

  // === EX/MEM Pipeline Register ===
  wire [31:0] pc_MEM, aluOut_MEM, op2_MEM, instr_MEM, branchPC_MEM;
  wire [21:0] c_MEM;
  EX_MA EX_MEM (
    .clk(clk), .rst(rst),
    .pc(pc_EX), .aluresult(aluResult_EX), .op2(reg2_EX), .instruction(instr_EX),
    .control(c_EX),
    .pcc(pc_MEM), .alo(aluOut_MEM), .opo(op2_MEM), .io(instr_MEM), .co(c_MEM)
  );

  // === MEM Stage ===
  wire [31:0] ldResult_MEM;
  memoryaccessunit MA (
    .op2(op2_MEM),
    .aluResult(aluOut_MEM),
    .isLd(c_MEM[20]), .isSt(c_MEM[21]),
    .clk(clk),
    .ldresult(ldResult_MEM)
  );

  // Pass branch information to IF stage
  assign branchPC_IF      = branchPC_EX;
  assign isBranchTaken_IF = isBranchTaken_EX;

  // === MEM/WB Pipeline Register ===
  wire [31:0] pc_WB, ldOut_WB, aluOut_WB,instr_WB;
  MA_RW MEM_WB (
    .clk(clk), .rst(rst),
    .pc(pc_MEM), .ldresult(ldResult_MEM), .aluresult(aluOut_MEM), .instruction(instr_MEM),
    .control(c_MEM),
    .pcc(pc_WB), .ldo(ldOut_WB), .alo(aluOut_WB),.io(instr_WB), .co(c_WB)
  );
  regwriteback WB (
    .aluResult(aluOut_WB),
    .ldResult(ldOut_WB),
    .prpc(pc_WB + 32'd4),
    .isLd(c_WB[20]), .isCall(c_WB[13]), .isWb(c_WB[15]),
    .ra(ra), .rd(instr_WB[25:22]),
    .writedata(wb_data),
    .writeadd(wb_addr)
  );
endmodule
