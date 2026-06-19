`timescale 1ns / 1ps
// Module Name: REG_FILE 
// Author: Eric Liu 
// Created: 6/2/2026 10:35AM
module REG_FILE(
    input logic clk, // clock
    input logic en, // enable write
    input logic [31:0] wd, // write data
    input logic [4:0] adr1, // input address 1
    input logic [4:0] adr2, // input address 2
    input logic [4:0] wa, // write address
    output logic [31:0] rs1, // output reg 1
    output logic [31:0] rs2 // output reg 2

);
    logic [31:0] regs [31:0];

    initial begin // sets all registers to 0
        for (integer i = 0; i < 32; i++)
            regs[i] = 32'b0;
    end

    always_comb begin
        rs1 = (adr1 == 5'd0) ? 32'd0 : regs[adr1]; // register 0 is always 0
        rs2 = (adr2 == 5'd0) ? 32'd0 : regs[adr2]; // register 0 is always 0
    end

    always_ff @(posedge clk) begin // write logic
        if (en == 1 && (wa != 5'd0))
            regs[wa] <= wd; // store wd in selected register
        regs[0] <= 32'b0;   // x0 always 0
    end
endmodule