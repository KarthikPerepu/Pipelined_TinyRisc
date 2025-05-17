`timescale 1ns/1ps
module tb_processor;
  // Testbench signals
  reg clk;
  reg rst;
  
  // Instantiate the processor
  Final_Pipelined dut (
    .clk(clk),
    .rst(rst)
  );
  
  // Clock generator
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
  end
  
  // Instruction memory initialization
  initial begin
  
    // mov r1,17
     dut.IF.instrumem[0] = 8'h4C;
    dut.IF.instrumem[1] = 8'h40;
    dut.IF.instrumem[2] = 8'h00;
    dut.IF.instrumem[3] = 8'h11;
    
    // mov r2,16
    dut.IF.instrumem[4] = 8'h4C;
    dut.IF.instrumem[5] = 8'h80;
    dut.IF.instrumem[6] = 8'h00;
    dut.IF.instrumem[7] = 8'h10;
    
    // b 0xc
    dut.IF.instrumem[8] = 8'h90;
    dut.IF.instrumem[9] = 8'h00;
    dut.IF.instrumem[10] = 8'h00;
    dut.IF.instrumem[11] = 8'h04;
    
    // nop
    dut.IF.instrumem[12] = 8'h68;
    dut.IF.instrumem[13] = 8'h00;
    dut.IF.instrumem[14] = 8'h00;
    dut.IF.instrumem[15] = 8'h00;
    
    // nop
    dut.IF.instrumem[16] = 8'h68;
    dut.IF.instrumem[17] = 8'h00;
    dut.IF.instrumem[18] = 8'h00;
    dut.IF.instrumem[19] = 8'h00;
    
    // mov r4,256
    dut.IF.instrumem[20] = 8'h4D;
    dut.IF.instrumem[21] = 8'h00;
    dut.IF.instrumem[22] = 8'h01;
    dut.IF.instrumem[23] = 8'h00;
    
    // mov r3,1
    dut.IF.instrumem[24] = 8'h4C;
    dut.IF.instrumem[25] = 8'hC0;
    dut.IF.instrumem[26] = 8'h00;
    dut.IF.instrumem[27] = 8'h01;
    
    
 
  end
  
  // Track PC and control signals
  always @(posedge clk) begin
    // Print PC (Program Counter) at every clock cycle
    $display("Time=%0t | PC=%0d", $time, dut.IF.lo);
    
    // Check for ADD operation in Control unit signals
    if (dut.ID_EX.co[12]) begin  
      $display("Time=%0t | PC=%0d | ADD operation detected in Execute stage", 
               $time, dut.ID_EX.pcc);
    end
  end
  
  // Final register value check
  initial begin
    // Apply reset
    rst = 1;
    #15 rst = 0;
    
    // Wait for pipeline to complete all instructions
    // 5 instructions + 5 pipeline stages = 10 cycles at minimum
    #200;
    
    // Display final register values
    $display("\n Final Register Values");
    $display("R1 = %0d", dut.RF.register[1]);
    $display("R2 = %0d", dut.RF.register[2]);
    $display("R3 = %0d", dut.RF.register[3]);
    $display("R4 = %0d", dut.RF.register[4]);
    $display("R5 = %0d", dut.RF.register[5]);
    
    // Check expected results
    if (dut.RF.register[2] !== 32'd16) $display("ERROR: R2 should be 16, got %0d", dut.RF.register[2]);
    else $display(" R2 = 16 (PASSED)");
    
    if (dut.RF.register[3] !== 32'd1) $display("ERROR: R3 should be 1, got %0d", dut.RF.register[3]);
    else $display(" R3 = 1 (PASSED)");
    
    if (dut.RF.register[4] !== 32'd0) $display("ERROR: R4 should be 0, got %0d", dut.RF.register[4]);
    else $display(" R4 = 0 (PASSED)");
    
    if (dut.RF.register[5] !== 32'd0) $display("ERROR: R5 should be 0, got %0d", dut.RF.register[5]);
    else $display(" R5 = 0 (PASSED)");
    
    $display("ADD operation test completed");
    $finish;
  end
endmodule
