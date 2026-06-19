`timescale 1ns / 1ps
// Module Name: cu_fsm
// Author:      Joseph Dotado
// Created:     6/2/2026 10:26AM

module cu_fsm (
    input  logic       clk,
    input  logic       reset,
    input  logic       intr,          // interrupt 
    input  logic [6:0] opcode,        // instruction opcode
    input  logic       branch_taken,  // from decoder 
    output logic       PCWrite,       // advance the PC
    output logic       regWrite,      // write the register file
    output logic       memWE2,        // data-memory write enable
    output logic       memRDEN1,      // instruction-fetch read enable
    output logic       memRDEN2,      // data read enable
    output logic       reset_out      // reset passthrough
);
    // FSM states
    typedef enum logic [1:0] {
        FETCH,        // read instruction from memory
        EXECUTE,      // do the operation
        WRITEBACK     // write memory data to register file
    } state_t;
    state_t state, next_state;

    // opcode constants
    localparam logic [6:0]
        OP_LUI    = 7'b0110111,
        OP_AUIPC  = 7'b0010111,
        OP_JAL    = 7'b1101111,
        OP_JALR   = 7'b1100111,
        OP_BRANCH = 7'b1100011,
        OP_LOAD   = 7'b0000011,
        OP_STORE  = 7'b0100011,
        OP_IMM    = 7'b0010011,
        OP_REG    = 7'b0110011,
        OP_SYSTEM = 7'b1110011;

    // state register (async reset to FETCH)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) state <= FETCH;
        else       state <= next_state;
    end

    // next-state logic: loads take the extra WRITEBACK cycle
    always_comb begin
        next_state = FETCH;
        case (state)
            FETCH:     next_state = EXECUTE;
            EXECUTE:   next_state = (opcode == OP_LOAD) ? WRITEBACK : FETCH;
            WRITEBACK: next_state = FETCH;
            default:   next_state = FETCH;
        endcase
    end

    // output (control) logic per state
    always_comb begin
        // safe defaults (all control off)
        PCWrite   = 1'b0;
        regWrite  = 1'b0;
        memWE2    = 1'b0;
        memRDEN1  = 1'b0;
        memRDEN2  = 1'b0;
        reset_out = reset;
        case (state)
            FETCH: begin
                memRDEN1 = 1'b1;          // read the instruction
            end
            EXECUTE: begin
                unique case (opcode)
                    OP_LUI, OP_AUIPC, OP_IMM, OP_REG: begin
                        regWrite = 1'b1;  // ALU result to register
                        PCWrite  = 1'b1;
                    end
                    OP_JAL, OP_JALR: begin
                        regWrite = 1'b1;  // PC+4 to register
                        PCWrite  = 1'b1;
                    end
                    OP_BRANCH: PCWrite = 1'b1;       // PC update
                    OP_STORE: begin
                        memWE2  = 1'b1;   // write data memory
                        PCWrite = 1'b1;
                    end
                    OP_LOAD:   memRDEN2 = 1'b1;       // start data read, finish in WB
                    default:   PCWrite  = 1'b1;       // advance
                endcase
            end
            WRITEBACK: begin
                regWrite = 1'b1;          // load data -> register
                PCWrite  = 1'b1;
            end
        endcase
    end
endmodule