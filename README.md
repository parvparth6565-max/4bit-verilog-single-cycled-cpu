# 4bit-verilog-single-cycled-cpu
4-bit educational CPU designed from scratch in Verilog HDL with ALU, register file, memory, branching, and HALT support.




4-bit Verilog CPU

A fully functional 4-bit educational CPU designed from scratch in Verilog HDL. This project demonstrates the fundamental building blocks of processor architecture, including the Program Counter, Control Unit, Register File, ALU, Data Memory, Instruction Memory, and branching logic.

The CPU was developed to gain a practical understanding of digital design, computer architecture, and processor implementation using synthesizable Verilog.

⸻

Features

* 4-bit datapath architecture
* 8-bit Program Counter (PC)
* Register File with four general-purpose registers
* Arithmetic Logic Unit (ALU)
* Instruction Memory
* Data Memory
* Immediate value support
* Load and Store instructions
* Branch-on-Equal (BEQ)
* HALT instruction
* Carry Flag generation
* Zero Flag generation
* Sign Flag generation
* Parameterized Instruction Memory Depth
* Modular Verilog design
* Fully verified using a custom testbench
* GTKWave simulation support

⸻

CPU Architecture

The processor consists of the following modules:

* Program Counter
* Instruction Memory
* Control Unit
* Register File
* Arithmetic Logic Unit (ALU)
* Result Register
* Data Memory

Instruction execution follows the sequence:

Instruction Fetch → Decode → Execute → Memory Access → Write Back

(Current implementation is single-cycle.)

⸻

Supported Instructions

Instruction	Description
ADD	Addition
SUB	Subtraction
AND	Bitwise AND
OR	Bitwise OR
XOR	Bitwise XOR
SHL	Logical Shift Left
SHR	Logical Shift Right
ADDI	Add Immediate
SUBI	Subtract Immediate
LOAD	Load data from memory
STORE	Store data into memory
BEQ	Branch if Equal
HALT	Stops CPU execution

⸻

Status Flags

Zero Flag (ZF)

Set when the ALU result equals zero.

Sign Flag (SF)

Reflects the Most Significant Bit (MSB) of the ALU result.

Carry Flag (CF)

Generated during addition when a carry is produced beyond the 4-bit result.

⸻

Project Structure

4bit-verilog-cpu/
│
├── src/
│   ├── cpu_datapath.v
│   ├── alu.v
│   ├── control_unit.v
│   ├── reg_file.v
│   ├── instruction_memory.v
│   ├── data_memory.v
│   ├── program_counter.v
│   └── reg_out.v
│
├── testbench/
│   └── cpu_tb.v
│
├── waveforms/
│   └── cpu_execution.vcd
│
├── screenshots/
│   └── gtkwave.png
│
└── README.md

⸻

Simulation

Simulation has been verified using:

* Icarus Verilog
* GTKWave

Typical simulation flow:

1. Compile the design.
2. Run the simulation.
3. Generate the VCD waveform.
4. View execution in GTKWave.

⸻

Current Capabilities

* Correct instruction execution
* Memory operations
* Branch target computation
* Immediate instructions
* HALT functionality
* Register write-back
* Carry, Zero, and Sign flags

⸻

Planned Improvements

* Program Loader using $readmemb
* Five-stage Pipeline
* Pipeline Registers
* Data Hazard Detection
* Forwarding Unit
* Stall Logic
* Branch Prediction
* Overflow Flag
* Additional ALU Instructions
* Expanded Register File
* Enhanced Test Programs

⸻

Learning Objectives

This project was built to understand:

* Processor architecture
* Verilog HDL
* Datapath design
* Control logic
* Memory interfacing
* Digital system verification
* Simulation and debugging

⸻

Author

Parth

Student, Innovator, and Hardware Design Enthusiast

Focused on Digital Design, Computer Architecture, Embedded Systems, AI, and Electronics.

⸻

License

This project is intended for educational and learning purposes.
Anyone is welcome to study, modify, and extend the design with appropriate attribution.
