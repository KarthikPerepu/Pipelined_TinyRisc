# 5-Stage Pipelined RISC Processor

![Processor Pipeline](docs/pipeline_diagram.png)

This repository contains a fully functional **5-stage pipelined RISC processor** implemented in **Verilog HDL**. The processor features a classic RISC pipeline with Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MA), and Register Write-back (WB) stages. The design prioritizes modularity, readability, and extensibility.

---

## 🔧 Architecture Features

- **5-Stage Pipeline**  
  Implements the classic RISC pipeline stages for improved instruction throughput.

- **Parametrized Design**  
  Key components (e.g., multiplexers) can be easily scaled via parameters.

- **Comprehensive ALU**  
  Supports arithmetic, logical, shift, and comparison operations.

- **Branch Support**  
  Hardware logic for both conditional and unconditional branch operations.

- **Memory Access**  
  Separate instruction and data memories; supports load and store operations.

- **Immediate Generation**  
  Flexible handling of multiple immediate‐format encodings.

---

## 🚀 Pipeline Stages

1. **Instruction Fetch (IF)**  
   - PC management and instruction memory access  
   - Branch target selection via mux  
   - 32-bit instruction fetch  

2. **Instruction Decode (ID)**  
   - Control‐signal generation based on opcode  
   - Register‐file read ports  
   - Immediate‐value generation  
   - Branch‐target address calculation  

3. **Execute (EX)**  
   - ALU operations: arithmetic, logical, shifts  
   - Branch‐condition evaluation  
   - Flag‐register updates for comparisons  

4. **Memory Access (MA)**  
   - Data‐memory read/write  
   - Address calculation from ALU result  

5. **Write-back (WB)**  
   - Select result from ALU, data memory, or other sources  
   - Register‐file write port  

---

## 🧾 Instruction Set Architecture (ISA)

- **Data Transfer**: `LD`, `ST`  
- **Arithmetic**: `ADD`, `SUB`, `MUL`, `DIV`, `MOD`  
- **Logical**: `AND`, `OR`, `NOT`  
- **Shifts**: `LSH`, `RSH`, `ARSH`  
- **Control Flow**: `BEQ`, `BGT`, `BR`  
- **Function Calls**: `CALL`, `RET`  
- **Special**: `CMP`, `MOV`  

---

## 🧩 Key Modules

### Core Pipeline Components
- `instructionfetch.v`  
- `control_unit.v`  
- `OperandFetchUnit.v`  
- `Register_file.v`  
- `ALU.v`  
- `memoryaccessunit.v`  
- `regwriteback.v`  

### Pipeline Registers
- `pipo_IF_ID.v`  
- `pipo_ID_EX.v`  
- `EX_MA.v`  
- `MA_RW.v`  

### ALU Submodules
- `Adder.v`, `Multiplier.v`, `Divider.v`, `Logical_unit.v`, etc.  
- `unified_shift_register.v` (supports LSH/RSH/ARSH)  

### Auxiliary Components
- `mux2x1.v`, `mux4x1.v` (parameterized multiplexers)  
- `imm_gen.v` (immediate‐value generator)  
- `branchunit.v` (branch‐decision logic)  
- `flag_reg.v` (comparison flags storage)  

---

## 🛠 Getting Started

### Prerequisites

- **Simulator**: Verilog HDL compatible simulator (ModelSim, Icarus Verilog, etc.)
- **Synthesis Tools**: Xilinx Vivado, Intel Quartus, etc
