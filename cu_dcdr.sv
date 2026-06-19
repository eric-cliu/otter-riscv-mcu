`timescale 1ns / 1ps
// Module Name: cu_dcdr
// Author:      Eric Liu
// Created:     6/2/2026 10:25AM

module cu_dcdr (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic       funct7_5,     // ir[30]
    input  logic       br_eq,        // branch flags from BranchCondGen
    input  logic       br_lt,
    input  logic       br_ltu,
    output logic       branch_taken, // 1 when a branch should be taken
    output logic [3:0] alu_fun,      // ALU operation select
    output logic [1:0] alu_srcA,     // ALU A input mux select
    output logic [1:0] alu_srcB,     // ALU B input mux select
    output logic [2:0] pcSource,     // next PC mux select
    output logic [1:0] rf_wr_sel     // register write-back mux select
);
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
        OP_REG    = 7'b0110011;

    // alu_fun codes
    localparam logic [3:0]
        ALU_ADD  = 4'b0000, ALU_SUB  = 4'b1000, ALU_OR   = 4'b0110,
        ALU_AND  = 4'b0111, ALU_XOR  = 4'b0100, ALU_SRL  = 4'b0101,
        ALU_SLL  = 4'b0001, ALU_SRA  = 4'b1101, ALU_SLT  = 4'b0010,
        ALU_SLTU = 4'b0011, ALU_COPY = 4'b1001;

    always_comb begin
        // defaults
        alu_fun      = ALU_ADD;
        alu_srcA     = 2'd0;   // rs1
        alu_srcB     = 2'd0;   // rs2
        pcSource     = 3'd0;   // PC + 4
        rf_wr_sel    = 2'd3;   // ALU result
        branch_taken = 1'b0;

        unique case (opcode)
            OP_LUI: begin                 // rd = imm << 12
                alu_fun   = ALU_COPY;     // pass U-imm (on srcA) through
                alu_srcA  = 2'd1;
                rf_wr_sel = 2'd3;
            end
            OP_AUIPC: begin               // rd = PC + (imm << 12)
                alu_fun   = ALU_ADD;
                alu_srcA  = 2'd1;         // U-imm
                alu_srcB  = 2'd3;         // PC
                rf_wr_sel = 2'd3;
            end
            OP_JAL: begin                 // rd = PC+4, jump
                pcSource  = 3'd3;
                rf_wr_sel = 2'd0;
            end
            OP_JALR: begin                // rd = PC+4, jump to rs1+imm
                pcSource  = 3'd1;
                rf_wr_sel = 2'd0;
            end
            OP_LOAD: begin                // rd = MEM[rs1+imm]
                alu_fun   = ALU_ADD;      // address = rs1 + I-imm
                alu_srcB  = 2'd1;
                rf_wr_sel = 2'd2;         // write-back = memory data
            end
            OP_STORE: begin               // MEM[rs1+imm] = rs2
                alu_fun  = ALU_ADD;       // address = rs1 + S-imm
                alu_srcB = 2'd2;
            end
            OP_BRANCH: begin              // conditional PC update
                unique case (funct3)
                    3'b000: branch_taken =  br_eq;   // beq
                    3'b001: branch_taken = ~br_eq;   // bne
                    3'b100: branch_taken =  br_lt;   // blt
                    3'b101: branch_taken = ~br_lt;   // bge
                    3'b110: branch_taken =  br_ltu;  // bltu
                    3'b111: branch_taken = ~br_ltu;  // bgeu
                    default: branch_taken = 1'b0;
                endcase
                pcSource = branch_taken ? 3'd2 : 3'd0;  // take branch or fall through
            end
            OP_IMM: begin                 // rd = rs1 OP imm
                alu_srcB  = 2'd1;         // I-imm
                rf_wr_sel = 2'd3;
                unique case (funct3)      // pick the operation
                    3'b000: alu_fun = ALU_ADD;                       // addi
                    3'b010: alu_fun = ALU_SLT;                       // slti
                    3'b011: alu_fun = ALU_SLTU;                      // sltiu
                    3'b100: alu_fun = ALU_XOR;                       // xori
                    3'b110: alu_fun = ALU_OR;                        // ori
                    3'b111: alu_fun = ALU_AND;                       // andi
                    3'b001: alu_fun = ALU_SLL;                       // slli
                    3'b101: alu_fun = funct7_5 ? ALU_SRA : ALU_SRL;  // srai / srli
                    default: alu_fun = ALU_ADD;
                endcase
            end
            OP_REG: begin                 // rd = rs1 OP rs2
                alu_srcB  = 2'd0;         // rs2
                rf_wr_sel = 2'd3;
                unique case (funct3)
                    3'b000: alu_fun = funct7_5 ? ALU_SUB : ALU_ADD;  // sub / add
                    3'b001: alu_fun = ALU_SLL;
                    3'b010: alu_fun = ALU_SLT;
                    3'b011: alu_fun = ALU_SLTU;
                    3'b100: alu_fun = ALU_XOR;
                    3'b101: alu_fun = funct7_5 ? ALU_SRA : ALU_SRL;  // sra / srl
                    3'b110: alu_fun = ALU_OR;
                    3'b111: alu_fun = ALU_AND;
                    default: alu_fun = ALU_ADD;
                endcase
            end
            default: begin                
                alu_fun   = ALU_ADD;
                pcSource  = 3'd0;
                rf_wr_sel = 2'd3;
            end
        endcase
    end
endmodule