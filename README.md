# OTTER RISC-V MCU

A 32-bit RISC-V microcontroller implemented in SystemVerilog and deployed on a Digilent Basys3 FPGA board. This project was completed as part of CPE 233 (Computer Design and Assembly Language Programming) and focuses on CPU datapath design, control logic, and hardware verification.

## Overview

The processor implements core RISC-V functionality through a modular architecture consisting of a program counter, register file, arithmetic logic unit (ALU), branch logic, immediate generation, and an FSM-based control unit.

The design was integrated, simulated, and tested using custom SystemVerilog modules and testbenches before deployment to FPGA hardware.

## Architecture

![OTTER MCU Architecture](docs/architecture.png)

The processor datapath includes:

* Program Counter (PC)
* Register File
* Arithmetic Logic Unit (ALU)
* Immediate Generator
* Branch Address Generator
* Branch Condition Generator
* Control Unit Decoder
* Control Unit Finite State Machine (FSM)
* Memory Interface
* Memory-Mapped I/O Support

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

* Arithmetic instructions
* Logical instructions
* Register-to-register operations
* Immediate operations
* Conditional branching
* Jump instructions
* Memory access operations
* Memory-mapped I/O

## Verification

Processor functionality was verified through simulation using a dedicated SystemVerilog testbench.

Verification included:

* ALU operation testing
* Register writeback verification
* Branch execution validation
* Control signal generation checks
* Datapath integration testing

## FPGA Deployment

The design was synthesized and deployed on a Digilent Basys3 FPGA development board.

Features demonstrated on hardware include:

* Program execution
* Memory-mapped I/O
* Seven-segment display output
* User interaction through FPGA peripherals

## Skills Demonstrated

* SystemVerilog
* FPGA Design
* RISC-V Architecture
* Computer Architecture
* Digital Logic Design
* RTL Design
* Hardware Verification
* Finite State Machine Design
* Datapath Integration
* Vivado

## Author

Eric Liu

Computer Engineering — California Polytechnic State University
