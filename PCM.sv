`timescale 1ns / 1ps
// Module Name: PCM  
// Author: Eric Liu   
// Created: 6/2/2026 10:34AM
module PCM(
    input        PCM_RST,         // reset (PC -> 0)
    input        PCM_WE,          // write enable (advance PC)
    input [31:0] PCM_JALR,        // jalr target
    input [31:0] PCM_BRANCH,      // branch target
    input [31:0] PCM_JAL,         // jal target
    input [1:0]  PCM_SEL,         // next-PC select
    input        PCM_CLK,         // clock
    output       [31:0] PCM_PLUS4,// PC + 4 (also used for link/return addr)
    output logic [31:0] PCM_COUNT // current PC
);
    logic [31:0] PC_DIN;          // value to load into PC
    logic [31:0] PCMUX_OUT;       // mux output
    assign PC_DIN    = PCMUX_OUT;
    assign PCM_PLUS4 = PCM_COUNT + 4;

    always_comb begin
        case (PCM_SEL)
            2'd0: PCMUX_OUT = PCM_PLUS4;  // PC + 4
            2'd1: PCMUX_OUT = PCM_JALR;   // JALR target
            2'd2: PCMUX_OUT = PCM_BRANCH; // Branch target
            2'd3: PCMUX_OUT = PCM_JAL;    // JAL target
        endcase
    end

    PC_REGISTER PC_REG (
        .PCM_CLK(PCM_CLK), .PCM_RST(PCM_RST), .PCM_WE(PCM_WE),
        .PC_DIN(PC_DIN), .PCM_COUNT(PCM_COUNT)
    );
endmodule

// Module Name: PC_REGISTER  
// Author: Eric Liu   
// Created: 6/2/2026 10:34AM

module PC_REGISTER(
    input logic PCM_CLK, //CLK input
    input logic PCM_RST, // Reset Input
    input logic PCM_WE, // Write input
    input logic [31:0] PC_DIN,
    output logic [31:0] PCM_COUNT
);
    always_ff @(posedge PCM_CLK) begin
        if (PCM_RST)      PCM_COUNT <= 32'h00000000; // reset to address 0
        else if (PCM_WE)  PCM_COUNT <= PC_DIN; // Next PC
    end
endmodule