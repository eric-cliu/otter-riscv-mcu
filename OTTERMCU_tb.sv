// Module Name: OTTERMCU_tb
// Author: Eric Liu (Mostly taken from Dr. Perk's Video)
// Created: 6/2/2026 10:29AM
`timescale 1ns / 1ps
module OTTERMCU_tb();

    logic        CLK;
    logic        RST;
    logic        INTR;
    logic        WR;
    logic [31:0] IN;
    logic [31:0] OUT;
    logic [31:0] ADDR;

    OTTERMCU UUT (
        .CPU_CLK(CLK), .CPU_RST(RST), .CPU_INTR(INTR),
        .CPU_IOBUS_WR(WR), .CPU_IOBUS_IN(IN),
        .CPU_IOBUS_OUT(OUT), .CPU_IOBUS_ADDR(ADDR)
    );

    // 20 ns clock
    initial CLK = 1'b0;
    always #10 CLK = ~CLK;

    // reset + sample input
    initial begin
        INTR = 1'b0;
        IN   = 32'h2;
        RST  = 1'b1;       // assert reset
        #60;
        RST  = 1'b0;       // release reset
    end

    always @(posedge CLK)
        if (WR && ADDR == 32'h1100_0040)
            $display("[%0t] SSEG <= 0x%02h", $time, OUT[7:0]);

endmodule