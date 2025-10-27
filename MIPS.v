`timescale 1ns / 1ps
`define MAX_PC 14
`define OUTPUT_REG 2

module MIPS( clk , leds
    );

    input clk ;
    output [7:0] leds ;
    reg [7:0] leds = 0 ;

    reg [31:0] i_cache[13:0] ; 
    reg [7:0] d_cache[10:0] ; 
    reg [7:0] RegisterFile[31:0] ;
    reg [7:0] PC ;
    reg [31:0] Instruction ;
    reg [2:0] state ;

    reg [5:0] opcode ;
    reg [4:0] rs ;
    reg [4:0] rt ;
    reg [4:0] rd ;
    reg [5:0] func ;
    reg [7:0] immediate ;
    reg [7:0] jump ;

    reg [7:0] sourceRegister1 ;
    reg [7:0] sourceRegister2 ;
    reg [7:0] MemoryAddress ;
    reg [7:0] ExeResult ;

    initial begin
        i_cache[0]  = 32'b001001_00000_00010_0000000000000000 ;
        i_cache[1]  = 32'b001001_00000_00011_0000000000000000 ;
        i_cache[2]  = 32'b000000_00011_00001_00100_00000_101010 ;
        i_cache[3]  = 32'b000100_00100_00000_0000000000001000 ;
        i_cache[4]  = 32'b001001_00000_00101_0000000000001010 ;
        i_cache[5]  = 32'b000100_00011_00101_0000000000000110 ;
        i_cache[6]  = 32'b010111_00011_00110_0000000000000000 ;
        i_cache[7]  = 32'b000000_00010_00110_00010_00000_100001 ;
        i_cache[8]  = 32'b001001_00011_00011_0000000000000001 ;
        i_cache[9]  = 32'b000000_00011_00001_00100_00000_101010 ;
        i_cache[10] = 32'b000101_00010_00000_1111111111111011 ;
        i_cache[11] = 32'b000000_11111_00000_00000_00000_001000 ;
        i_cache[12] = 32'b010111_00000_00001_0000000000001010 ;
        i_cache[13] = 32'b000011_00000000000000000000000000 ;

        d_cache[0]  = 8'b00000001 ;
        d_cache[1]  = 8'b00000001 ;
        d_cache[2]  = 8'b00000001 ;
        d_cache[3]  = 8'b00000001 ;
        d_cache[4]  = 8'b00000001 ;
        d_cache[5]  = 8'b00000001 ;
        d_cache[6]  = 8'b00000001 ;
        d_cache[7]  = 8'b00000001 ;
        d_cache[8]  = 8'b11111111 ;
        d_cache[9]  = 8'b11111111 ;
        d_cache[10] = 8'b00001010 ;

        RegisterFile[0]  = 8'b00000000 ;
        RegisterFile[1]  = 8'b00000000 ;
        RegisterFile[2]  = 8'b00000000 ;
        RegisterFile[3]  = 8'b00000000 ;
        RegisterFile[4]  = 8'b00000000 ;
        RegisterFile[5]  = 8'b00000000 ;
        RegisterFile[6]  = 8'b00000000 ;
        RegisterFile[7]  = 8'b00000000 ;
        RegisterFile[8]  = 8'b00000000 ;
        RegisterFile[9]  = 8'b00000000 ;
        RegisterFile[10] = 8'b00000000 ;
        RegisterFile[11] = 8'b00000000 ;
        RegisterFile[12] = 8'b00000000 ;
        RegisterFile[13] = 8'b00000000 ;
        RegisterFile[14] = 8'b00000000 ;
        RegisterFile[15] = 8'b00000000 ;
        RegisterFile[16] = 8'b00000000 ;
        RegisterFile[17] = 8'b00000000 ;
        RegisterFile[18] = 8'b00000000 ;
        RegisterFile[19] = 8'b00000000 ;
        RegisterFile[20] = 8'b00000000 ;
        RegisterFile[21] = 8'b00000000 ;
        RegisterFile[22] = 8'b00000000 ;
        RegisterFile[23] = 8'b00000000 ;
        RegisterFile[24] = 8'b00000000 ;
        RegisterFile[25] = 8'b00000000 ;
        RegisterFile[26] = 8'b00000000 ;
        RegisterFile[27] = 8'b00000000 ;
        RegisterFile[28] = 8'b00000000 ;
        RegisterFile[29] = 8'b00000000 ;
        RegisterFile[30] = 8'b00000000 ;
        RegisterFile[31] = 8'b00000000 ;

        state <= 0 ;
        PC <= 8'b00001100 ;

    end


    always @(posedge clk) begin

        if (state == 0) begin
            Instruction <= i_cache[PC] ;
            state <= 1 ;
        end

        else if (state == 1) begin
            opcode <= Instruction[31:26] ;
            rs <= Instruction[25:21] ;
            rt <= Instruction[20:16] ;
            rd <= Instruction[15:11] ;
            func <= Instruction[5:0] ;
            immediate <= Instruction[7:0] ;
            jump <= Instruction[7:0] ;
            state <= 2 ;
        end

        else if (state == 2) begin
            sourceRegister1 <= RegisterFile[rs] ;
            sourceRegister2 <= RegisterFile[rt] ;
            state <= 3 ;
        end

        else if (state == 3) begin

            if(opcode == 6'b000000) begin

                if(func == 6'b101010) begin
                    if($signed(sourceRegister1) < $signed(sourceRegister2)) begin
                        ExeResult <= 8'b1 ;
                    end
                    else begin
                        ExeResult <= 8'b0 ;
                    end
                    PC <= PC + 1 ;
                    state <= 4 ;
                end

                else if(func == 6'b100001) begin
                    ExeResult <= sourceRegister1 + sourceRegister2 ;
                    PC <= PC + 1 ;
                    state <= 4 ;
                end

                else if(func == 6'b001000) begin
                    PC <= RegisterFile[31] ;
                    state <= 4 ;
                end
            end

            else if(opcode == 6'b001001) begin
                ExeResult <= sourceRegister1 + immediate ;
                PC <= PC + 1 ;
                state <= 4 ;
            end

            else if(opcode == 6'b000100) begin
                if(sourceRegister1 == sourceRegister2) begin
                    PC <= PC + immediate ;
                end
                else begin
                    PC <= PC + 1 ;
                end
                state <= 4 ;
            end

            else if(opcode == 6'b010111) begin
                MemoryAddress <= immediate + sourceRegister1 ;
                PC <= PC + 1 ;
                state <= 4 ;
            end

            else if(opcode == 6'b000101) begin
                if(sourceRegister1 != sourceRegister2) begin
                    PC <= PC + immediate ;
                end
                else begin
                    PC <= PC + 1 ;
                end
                state <= 4 ;
            end

            else if(opcode == 6'b000011) begin
                PC <= jump ;
                RegisterFile[31] <= PC + 1 ;
                state <= 4 ;
            end

        end

        else if (state == 4) begin
            if(opcode == 6'b010111) begin
                ExeResult <= d_cache[MemoryAddress] ;
            end
            state <= 5 ;
        end

        else if (state == 5) begin
            if(opcode == 6'b000000 ) begin
                if( func == 6'b100001 & rd!=0 ) begin
                    RegisterFile[rd] <= ExeResult ;
                end
                else if( func == 6'b101010 & rd!=0 ) begin
                    RegisterFile[rd] <= ExeResult ;
                end
            end

            else if(opcode == 6'b001001 & rt!=0) begin
                RegisterFile[rt] <= ExeResult ;
            end

            else if(opcode == 6'b010111 & rt!=0 ) begin
                RegisterFile[rt] <= d_cache[MemoryAddress] ;
            end

            if(PC < `MAX_PC) begin
                state <= 0 ;
            end
            else begin
                state <= 6 ;
            end
        end

        else if(state == 6) begin
            leds <= RegisterFile[`OUTPUT_REG] ;
            $display("Output: %d", $signed(RegisterFile[`OUTPUT_REG])) ;
        end                
                     
    end

endmodule
