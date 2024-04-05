module writeback(
input clk,
input [3:0]icode,
input [3:0]rA,
input [3:0]rB,
input [63:0]valE,
input [63:0]valM,
input Cnd,
output reg[63:0]rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14
);

reg [63:0]r_bank[0:14];

initial
begin
    r_bank[0] = 64'hf;
    r_bank[1] = 64'hf;
    r_bank[2] = 64'hf;
    r_bank[3] = 64'hf;
    r_bank[4] = 64'd32;
    r_bank[5] = 64'hf;
    r_bank[6] = 64'hf;
    r_bank[7] = 64'hf;
    r_bank[8] = 64'hf;
    r_bank[9] = 64'hf;
    r_bank[10] = 64'hf;
    r_bank[11] = 64'hf;
    r_bank[12] = 64'hf;
    r_bank[13] = 64'hf;
    r_bank[14] = 64'hf;
end

always @(negedge clk)
begin

    if(icode == 4'd2) // cmovXX
    begin
        if(Cnd == 1)
        begin
            r_bank[rB] = valE;
        end
    end
    else if(icode == 4'd3) // irmovq
    begin
        r_bank[rB] = valE;
    end
    else if(icode == 4'd5) // mrmovq
    begin
        r_bank[rA] = valM;
    end
    else if(icode == 4'd6) // OPq
    begin
        r_bank[rB] = valE;
    end
    else if(icode == 4'd8) // call
    begin
        r_bank[4] = valE;
    end
    else if(icode == 4'd9) // ret
    begin
        r_bank[4] = valE;
    end
    else if(icode == 4'd10) // pushq
    begin
        r_bank[4] = valE;
    end
    else if(icode == 4'd11) // popq
    begin
        r_bank[4] = valE;
        r_bank[rA] = valM;
    end

    rax = r_bank[0];
    rcx = r_bank[1];
    rdx = r_bank[2];
    rbx = r_bank[3];
    rsp = r_bank[4];
    rbp = r_bank[5];
    rsi = r_bank[6];
    rdi = r_bank[7];
    r8 = r_bank[8];
    r9 = r_bank[9];
    r10 = r_bank[10];
    r11 = r_bank[11];
    r12 = r_bank[12];
    r13 = r_bank[13];
    r14 = r_bank[14];

end

endmodule