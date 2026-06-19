`timescale 1ns / 1ps
// Module Name: IMMED_GEN
// Author:      Eric Liu
// Created:     6/2/2026 10:28AM

module IMMED_GEN (
    input  logic [31:7] IR, // Instruction Bits [31:7]
    output logic [31:0] U_TYPE,
    output logic [31:0] I_TYPE,
    output logic [31:0] S_TYPE,
    output logic [31:0] B_TYPE,
    output logic [31:0] J_TYPE
);
    assign U_TYPE = {IR[31:12], 12'b0}; // U-Type: bits [31:12], lower 12 bits zeroed
    assign I_TYPE = {{20{IR[31]}}, IR[31:20]}; // I-Type: sign-extend IR[31:20]
    assign S_TYPE = {{20{IR[31]}}, IR[31:25], IR[11:7]}; // S-Type: sign-extend {IR[31:25], IR[11:7]}
    assign B_TYPE = {{19{IR[31]}}, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0}; // B-Type
    assign J_TYPE = {{11{IR[31]}}, IR[31], IR[19:12], IR[20], IR[30:21], 1'b0}; // J-Type
endmodule