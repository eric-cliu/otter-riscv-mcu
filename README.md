# OTTER RISC-V MCU

A 32-bit RV32I RISC-V multicycle processor implemented in SystemVerilog and deployed on a Digilent Basys3 FPGA board. This project was completed as part of CPE 233 (Computer Design and Assembly Language Programming) and focuses on CPU datapath design, control logic, and hardware verification.

## Overview

The processor implements the RV32I instruction set using a multicycle datapath architecture consisting of a program counter, register file, ALU, immediate generator, branch address generation, branch condition generation, and an FSM-based control unit.
The design was integrated, simulated, and tested using custom SystemVerilog modules and testbenches before deployment to FPGA hardware.

## Architecture

![OTTER MCU Architecture](architecture.png)

The processor datapath includes:

* Program Counter (PC)
* Register File
* Arithmetic Logic Unit (ALU)
* Immediate Generator
* Branch Address Generator
* Branch Condition Generator
* Control Unit Decoder
* Control Unit Finite State Machine (FSM)
* Dual-Port Memory Interface
* Memory-Mapped I/O Interface

## Implemented Components

The following modules were designed and implemented as part of this project:

| Module        | Description                                      |
| ------------- | ------------------------------------------------ |
| PCM           | Program counter management and update logic      |
| ALU           | Arithmetic and logical operations                |
| REG_FILE      | Register file implementation                     |
| IMMED_GEN     | RISC-V immediate value generation                |
| BranchAddrGen | Branch and jump target calculation               |
| BranchCondGen | Branch comparison logic                          |
| cu_dcdr       | Instruction decode and control signal generation |
| cu_fsm        | Finite-state machine controller                  |
| OTTERMCU      | Top-level processor integration                  |
| OTTERMCU_tb   | Functional verification testbench                |
| BCD           | Binary-coded decimal conversion logic            |

## Provided Infrastructure

The following files were provided as course infrastructure and integrated into the final design:

* otter_memory
* CathodeDriver
* SevSegDisp
* OTTER_Wrapper_v1_02
* Basys3_Master.xdc

## Supported Functionality

The processor supports key RISC-V datapath operations including:

* RV32I arithmetic and logical instructions
* Register-register and immediate operations
* Conditional branch instructions
* JAL and JALR control-flow operations
* Load and store instructions
* Memory-mapped I/O access

## Verification

Processor functionality was verified through simulation using a dedicated SystemVerilog testbench.

Verification included:

* ALU operation testing
* Register writeback verification
* Branch execution validation
* Control signal generation checks
* Datapath integration testing

## FPGA Deployment

The design was synthesized and deployed on a Digilent Basys3 FPGA development board. Processor functionality was validated using both provided OTTER memory images and custom test programs executed directly on hardware.
Features demonstrated on hardware include:

* Program execution
* Memory-mapped I/O
* Seven-segment display output
* User interaction through FPGA peripherals

## Author

Eric Liu

https://www.linkedin.com/in/eric-cliu/
