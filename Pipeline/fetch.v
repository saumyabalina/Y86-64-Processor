module fetch(
input clk,
input [63:0]F_predPC,
input signed[63:0]M_valA,
input signed[63:0]W_valM,
input [3:0]M_icode,
input M_Cnd,
input [3:0]W_icode,
input D_stall,
input D_bubble,
output reg[3:0]D_icode,
output reg[3:0]D_ifun,
output reg[3:0]D_rA,
output reg[3:0]D_rB,
output reg[63:0]D_valP,
output reg[63:0]D_valC,
output reg[63:0]f_predPC,
output reg [1:0]D_stat
);

reg [7:0]mem[0:1023];
reg [0:79]inst;
reg [63:0]f_pc;
reg imem_error;
reg instr_valid;

reg[3:0]f_icode;
reg[3:0]f_ifun;
reg[3:0]f_rA;
reg[3:0]f_rB;
reg[63:0]f_valP;
reg[63:0]f_valC;
reg [1:0]f_stat;

initial
begin
    // $readmemb("call_ret.txt",mem);
    // $readmemb("mrmovq.txt",mem);
    // $readmemb("jXX.txt",mem);
    // $readmemb("push_pop.txt",mem);
    // $readmemb("exp_hdl1.txt",mem);

    imem_error = 0;
    f_icode = 4'hf;
    f_ifun = 4'hf;
    instr_valid = 0;
    f_valP = 64'd0;
    f_valC = 64'd0;
    f_predPC = 64'd0;
    f_rA = 4'hf;
    f_rB = 4'hf;
end

always @(*)
begin

    imem_error = 0; instr_valid = 0; f_stat = 0;

    if(M_icode == 4'd7 && M_Cnd == 0) // Mispredicted Branch
    begin
        f_pc = M_valA;
    end
    else if(W_icode == 4'd9) // Return
    begin
        f_pc = W_valM;
    end
    else
    begin
        f_pc = F_predPC;
    end

    
    if(f_pc>=0 && f_pc<1024)
    begin

        inst = {
            mem[f_pc],
            mem[f_pc+1],
            mem[f_pc+9],
            mem[f_pc+8],
            mem[f_pc+7],
            mem[f_pc+6],
            mem[f_pc+5],
            mem[f_pc+4],
            mem[f_pc+3],
            mem[f_pc+2]
        };

        f_icode = inst[0:3];
        f_ifun = inst[4:7];
        
        if((f_icode == 4'd7) || (f_icode == 4'd8))
        begin
            inst = {
                mem[f_pc],
                mem[f_pc+8],
                mem[f_pc+7],
                mem[f_pc+6],
                mem[f_pc+5],
                mem[f_pc+4],
                mem[f_pc+3],
                mem[f_pc+2],
                mem[f_pc+1],
                mem[f_pc]
            };
        end

        if(f_icode == 4'd0 && f_ifun == 4'd0) // halt
        begin
            f_valP = f_pc+64'd1;
            f_predPC = f_valP;
            f_stat = 2'd1;
        end
        else if(f_icode == 4'd1 && f_ifun == 4'd0) // nop
        begin
            f_valP = f_pc+64'd1;
            f_predPC = f_valP;
        end
        else if(f_icode == 4'd2 && f_ifun < 4'd7) // cmovXX
        begin
            f_rA = inst[8:11];
            f_rB = inst[12:15];
            f_valP = f_pc+64'd2;
            f_predPC = f_valP;
        end
        else if(f_icode == 4'd3 && f_ifun == 4'd0) // irmovq
        begin
            f_rA = inst[8:11];
            f_rB = inst[12:15];
            f_valC = inst[16:79];
            f_valP = f_pc+64'd10;
            f_predPC = f_valP;
        end
        else if(f_icode == 4'd4 && f_ifun == 4'd0) // rmmovq
        begin
            f_rA = inst[8:11];
            f_rB = inst[12:15];
            f_valC = inst[16:79];
            f_valP = f_pc+64'd10;
            f_predPC = f_valP;
        end
        else if(f_icode == 4'd5 && f_ifun == 4'd0) // mrmovq
        begin
            f_rA = inst[8:11];
            f_rB = inst[12:15];
            f_valC = inst[16:79];
            f_valP = f_pc+64'd10;
            f_predPC = f_valP;
        end
        else if(f_icode == 4'd6 && f_ifun < 4'd4) // OPq
        begin
            f_rA = inst[8:11];
            f_rB = inst[12:15];
            f_valP = f_pc+64'd2;
            f_predPC = f_valP;
        end
        else if(f_icode == 4'd7 && f_ifun < 4'd7) // jXX
        begin
            f_valC = inst[8:71];
            f_valP = f_pc+64'd9;
            f_predPC = f_valC;
        end
        else if(f_icode == 4'd8 && f_ifun == 4'd0) // call
        begin
            f_valC = inst[8:71];
            f_valP = f_pc+64'd9;
            f_predPC = f_valC;
        end
        else if(f_icode == 4'd9 && f_ifun == 4'd0) // ret
        begin
            f_valP = f_pc+64'd1;
            f_predPC = f_valP;
        end
        else if(f_icode == 4'd10 && f_ifun == 4'd0) // pushq
        begin
            f_rA = inst[8:11];
            f_rB = inst[12:15];
            f_valP = f_pc+64'd2;
            f_predPC = f_valP;
        end
        else if(f_icode == 4'd11 && f_ifun == 4'd0) // popq
        begin
            f_rA = inst[8:11];
            f_rB = inst[12:15];
            f_valP = f_pc+64'd2;
            f_predPC = f_valP;
        end
        else
        begin
            instr_valid = 1;
        end
    end
    else
    begin
        imem_error = 1;
    end

    if(imem_error == 1)
    begin
        f_stat = 2'd2;
    end
    else if(instr_valid == 1)
    begin
        f_stat = 2'd3;
    end
end

always @(posedge clk)
begin
    
    if(D_stall == 1)
    begin
        // f_predPC <= F_predPC;
    end
    else if(D_bubble == 1)
    begin
        
        D_icode <= 4'd1; // nop
        D_ifun <= 4'd0;
        D_rA <= 4'hf;
        D_rB <= 4'hf;
        D_valC <= 64'd0;
        D_valP <= 64'd0;
        D_stat <= 2'd0;
    end
    else
    begin
        D_icode <= f_icode;
        D_ifun <= f_ifun;
        D_rA <= f_rA;
        D_rB <= f_rB;
        D_valC <= f_valC;
        D_valP <= f_valP;
        D_stat <= f_stat;
    end

end
endmodule