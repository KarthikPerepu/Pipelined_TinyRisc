5-Stage Pipelined RISC Processor

Overview
This repository contains a fully functional 5-stage pipelined RISC processor implemented in Verilog HDL. The processor features a classic RISC pipeline with Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MA), and Register Write-back (WB) stages. The design prioritizes modularity, readability, and extensibility.
Architecture Features

5-Stage Pipeline: Implements the classic RISC pipeline stages for improved throughput
Parametrized Design: Key components like multiplexers can be easily scaled
Comprehensive ALU: Supports arithmetic, logical, shift, and comparison operations
Branch Support: Hardware for conditional and unconditional branch operations
Memory Access: Both load and store operations with separate instruction and data memory
Immediate Generation: Flexible immediate value handling with multiple formats

Pipeline Stages
1. Instruction Fetch (IF)

PC management and instruction memory access
Branch target selection through multiplexing
Instruction fetching (32-bit instructions)

2. Instruction Decode (ID)

Control signal generation based on opcode
Register file access
Immediate value generation
Branch target calculation

3. Execute (EX)

ALU operations (arithmetic, logical, shift)
Branch condition evaluation
Flag register updates for comparison operations

4. Memory Access (MA)

Data memory read/write operations
Address calculation using ALU results

5. Write-back (WB)

Result selection from multiple sources (ALU, memory, etc.)
Register file updates

Instruction Set Architecture
The processor supports a rich instruction set including:

Data transfer: Load (LD), Store (ST)
Arithmetic: Add, Subtract, Multiply, Divide, Modulo
Logical: AND, OR, NOT
Shifts: Logical left/right shift, Arithmetic shift right
Control flow: Branch equal, Branch greater than, Unconditional branch
Function calls: Call, Return
Special: Compare, Move

Key Modules
Core Pipeline Components

instructionfetch: Manages the PC and retrieves instructions
control_unit: Decodes instructions and generates control signals
OperandFetchUnit: Selects the appropriate register addresses
Register_file: Provides register read/write functionality
ALU: Performs all arithmetic and logical operations
memoryaccessunit: Handles data memory access
regwriteback: Manages the write-back multiplexing and control

Pipeline Registers

pipo_IF_ID: Between Instruction Fetch and Decode stages
pipo_ID_EX: Between Instruction Decode and Execute stages
EX_MA: Between Execute and Memory Access stages
MA_RW: Between Memory Access and Write-back stages

ALU Components

Various computational modules including Adder, Mul, Divider, Logical_unit, etc.
Shifter unit (unified_shift_register) supporting multiple shift types

Auxiliary Components

mux2x1 and mux4x1: Parameterized multiplexers
imm_gen: Immediate value generator
branchunit: Branch decision logic
flag_reg: Stores comparison flags

Getting Started
Prerequisites

Verilog HDL compatible simulator (ModelSim, Icarus Verilog, etc.)
Synthesis tools (if targeting hardware implementation)
