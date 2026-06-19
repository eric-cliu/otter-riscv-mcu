`timescale 1ns / 1ps
// Module Name: ALU
// Author:      Eric Liu
// Created:     6/2/2026 10:27AM
module ALU (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALU_FUN,
    output logic [31:0] RESULT
);
    always_comb begin
        case (ALU_FUN)
            4'b0000: RESULT = A + B;                                   // ADD
            4'b1000: RESULT = A - B;                                   // SUB
            4'b0110: RESULT = A | B;                                   // OR
            4'b0111: RESULT = A & B;                                   // AND
            4'b0100: RESULT = A ^ B;                                   // XOR
            4'b0101: RESULT = A >> B[4:0];                             // SRL
            4'b0001: RESULT = A << B[4:0];                             // SLL
            4'b1101: RESULT = $signed(A) >>> B[4:0];                   // SRA
            4'b0010: RESULT = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT
            4'b0011: RESULT = (A < B) ? 32'd1 : 32'd0;                 // SLTU
            4'b1001: RESULT = A;                                       // LUI copy (pass srcA)
            default: RESULT = 32'b0;
        endcase
    end
endmodule