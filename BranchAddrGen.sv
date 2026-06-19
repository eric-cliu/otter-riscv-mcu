`timescale 1ns / 1ps
// Module Name: BranchAddrGen
// Author: Joseph Dotado   
// Created: 6/2/2026 10:28AM
module BranchAddrGen (
    input  logic [31:0] PC,       // current PC
    input  logic [31:0] rs1,      // base register for jalr
    input  logic [31:0] J_TYPE,   // jal  immediate
    input  logic [31:0] B_TYPE,   // branch immediate
    input  logic [31:0] I_TYPE,   // jalr immediate
    output logic [31:0] jal,      // jal target
    output logic [31:0] branch,   // branch target
    output logic [31:0] jalr      // jalr target
);
    assign jal    = PC  + J_TYPE;   
    assign branch = PC  + B_TYPE;   
    assign jalr   = rs1 + I_TYPE;   
endmodule