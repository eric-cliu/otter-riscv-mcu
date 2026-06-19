`timescale 1ns / 1ps
// Module Name: OTTERMCU
// Author:      Joseph Dotado, Eric Liu
// Created:     6/2/2026 20:24

module OTTERMCU(
    input  logic        CPU_RST,
    input  logic        CPU_INTR,
    input  logic        CPU_CLK,
    input  logic [31:0] CPU_IOBUS_IN,
    output logic [31:0] CPU_IOBUS_OUT,
    output logic [31:0] CPU_IOBUS_ADDR,
    output logic        CPU_IOBUS_WR
);
    // Control Signals
    logic        PCWrite, regWrite, memWE2, memRDEN1, memRDEN2, reset_out;
    logic        branch_taken;
    logic [3:0]  alu_fun;
    logic [1:0]  alu_srcA, alu_srcB, rf_wr_sel;
    logic [2:0]  pcSource;

    // Branch Condition Flags
    logic BR_EQ, BR_LT, BR_LTU;

    // Datapath
    logic [31:0] PC, PC_PLUS4, IR, RS1, RS2;
    logic [31:0] U_TYPE, I_TYPE, S_TYPE, B_TYPE, J_TYPE;
    logic [31:0] SRC_A, SRC_B, ALU_OUT, RF_IN, MEM_OUT;
    logic [31:0] JAL_ADDR, BRANCH_ADDR, JALR_ADDR;

    // Instruction Fields
    logic [6:0] OPCODE;
    logic [2:0] FUNCT3;
    logic       FUNCT7_5;

    assign OPCODE   = IR[6:0];
    assign FUNCT3   = IR[14:12];
    assign FUNCT7_5 = IR[30];

    // IOBUS
    assign CPU_IOBUS_OUT  = RS2;
    assign CPU_IOBUS_ADDR = ALU_OUT;

    // Control FSM
    cu_fsm FSM (
        .clk(CPU_CLK), .reset(CPU_RST), .intr(CPU_INTR),
        .opcode(OPCODE), .branch_taken(branch_taken),
        .PCWrite(PCWrite), .regWrite(regWrite),
        .memWE2(memWE2), .memRDEN1(memRDEN1), .memRDEN2(memRDEN2),
        .reset_out(reset_out)
    );

    // Decoder
    cu_dcdr DCDR (
        .opcode(OPCODE), .funct3(FUNCT3), .funct7_5(FUNCT7_5),
        .br_eq(BR_EQ), .br_lt(BR_LT), .br_ltu(BR_LTU),
        .branch_taken(branch_taken),
        .alu_fun(alu_fun), .alu_srcA(alu_srcA), .alu_srcB(alu_srcB),
        .pcSource(pcSource), .rf_wr_sel(rf_wr_sel)
    );

    // Program Counter
    PCM PCM (
        .PCM_RST(CPU_RST), .PCM_WE(PCWrite),
        .PCM_JALR(JALR_ADDR), .PCM_BRANCH(BRANCH_ADDR), .PCM_JAL(JAL_ADDR),
        .PCM_SEL(pcSource[1:0]), .PCM_CLK(CPU_CLK),
        .PCM_PLUS4(PC_PLUS4), .PCM_COUNT(PC)
    );

    // Memory
    Memory MEM (
        .MEM_CLK(CPU_CLK), .MEM_RDEN1(memRDEN1), .MEM_RDEN2(memRDEN2),
        .MEM_WE2(memWE2), .MEM_ADDR1(PC[15:2]), .MEM_ADDR2(ALU_OUT),
        .MEM_DIN2(RS2), .MEM_SIZE(FUNCT3[1:0]), .MEM_SIGN(FUNCT3[2]),
        .IO_IN(CPU_IOBUS_IN), .IO_WR(CPU_IOBUS_WR),
        .MEM_DOUT1(IR), .MEM_DOUT2(MEM_OUT)
    );

    // Reg File
    REG_FILE RF (
        .clk(CPU_CLK), .en(regWrite), .wd(RF_IN),
        .adr1(IR[19:15]), .adr2(IR[24:20]), .wa(IR[11:7]),
        .rs1(RS1), .rs2(RS2)
    );

    // Immediate Generator
    IMMED_GEN IGEN (
        .IR(IR[31:7]),
        .U_TYPE(U_TYPE), .I_TYPE(I_TYPE), .S_TYPE(S_TYPE),
        .B_TYPE(B_TYPE), .J_TYPE(J_TYPE)
    );

    // ALU srcA MUX: 0 = rs1, 1 = U-type immediate
    always_comb begin
        case (alu_srcA)
            2'd0:    SRC_A = RS1;
            2'd1:    SRC_A = U_TYPE;
            default: SRC_A = RS1;
        endcase
    end

    //ALU srcB MUX: 0 = rs2, 1 = I-type, 2 = S-type, 3 = PC
    always_comb begin
        case (alu_srcB)
            2'd0:    SRC_B = RS2;
            2'd1:    SRC_B = I_TYPE;
            2'd2:    SRC_B = S_TYPE;
            2'd3:    SRC_B = PC;
            default: SRC_B = RS2;
        endcase
    end

    // ALU
    ALU ALU_UNIT (
        .A(SRC_A), .B(SRC_B), .ALU_FUN(alu_fun), .RESULT(ALU_OUT)
    );

    // Branch Condition Generator
    BranchCondGen BCG (
        .rs1(RS1), .rs2(RS2),
        .br_eq(BR_EQ), .br_lt(BR_LT), .br_ltu(BR_LTU)
    );

    // Branch Address Generator
    BranchAddrGen BAG (
        .PC(PC), .rs1(RS1),
        .J_TYPE(J_TYPE), .B_TYPE(B_TYPE), .I_TYPE(I_TYPE),
        .jal(JAL_ADDR), .branch(BRANCH_ADDR), .jalr(JALR_ADDR)
    );

    // Register Writeback MUX : 0 = PC+4, 2 = MEM, 3 = ALU 
    always_comb begin
        case (rf_wr_sel)
            2'd0:    RF_IN = PC_PLUS4;
            2'd2:    RF_IN = MEM_OUT;
            2'd3:    RF_IN = ALU_OUT;
            default: RF_IN = ALU_OUT;
        endcase
    end
endmodule