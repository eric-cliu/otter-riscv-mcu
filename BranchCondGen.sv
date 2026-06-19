`timescale 1ns / 1ps
//  Module Name: BranchCondGen
//  Author: Joseph Dotado   
// Created: 6/2/2026 10:36AM
module BranchCondGen (
    input  logic [31:0] rs1,
    input  logic [31:0] rs2,
    output logic        br_eq,    // rs1 == rs2
    output logic        br_lt,    // rs1 <  rs2 (signed)
    output logic        br_ltu    // rs1 <  rs2 (unsigned)
);
    always_comb begin
        br_eq  = (rs1 == rs2);                      // equality 
        br_lt  = ($signed(rs1) < $signed(rs2));     // signed   
        br_ltu = (rs1 < rs2);                       // unsigned 
    end
endmodule