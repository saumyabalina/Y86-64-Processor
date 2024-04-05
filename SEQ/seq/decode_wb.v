module decode_wb(
input clk,Cnd,
input [3:0]icode,
input [3:0]rA,
input [3:0]rB,
input [63:0]valE,
input [63:0]valM,
output reg[63:0]valA,
output reg[63:0]valB,
output reg[63:0]rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14
);

reg [63:0]reg_mem[0:14];

initial
begin
    reg_mem[0] = 64'd0;
    reg_mem[1] = 64'd1;
    reg_mem[2] = 64'd2;
    reg_mem[3] = 64'd3;
    reg_mem[4] = 64'd32;
    reg_mem[5] = 64'd5;
    reg_mem[6] = 64'd6;
    reg_mem[7] = 64'd7;
    reg_mem[8] = 64'd8;
    reg_mem[9] = 64'd9;
    reg_mem[10] = 64'd10;
    reg_mem[11] = 64'd11;
    reg_mem[12] = 64'd12;
    reg_mem[13] = 64'd13;
    reg_mem[14] = 64'd14;
end

always @(*)
begin
    
    // valA = 64'hf;
    // valB = 64'hf;
    
    if(clk == 1)
    begin
        if(icode == 4'd2) // cmovXX
        begin
            valA = reg_mem[rA];
            valB = 0;
        end
        else if(icode == 4'd4) // rmmovq
        begin
            valA = reg_mem[rA];
            valB = reg_mem[rB];
        end
        else if(icode == 4'd5) // mrmovq
        begin
            valB = reg_mem[rB];
        end
        else if(icode == 4'd6) // OPq
        begin
            valA = reg_mem[rA];
            valB = reg_mem[rB];
        end
        else if(icode == 4'd8) // call
        begin
            valB = reg_mem[4]; 
        end
        else if(icode == 4'd9) // ret
        begin
            valA = reg_mem[4];
            valB = reg_mem[4];
        end
        else if(icode == 4'd10) // pushq
        begin
            valA = reg_mem[rA];
            valB = reg_mem[4];
        end
        else if(icode == 4'd11) // popq
        begin
            valA = reg_mem[4];
            valB = reg_mem[4];
        end
    end
end

always @(negedge clk)
begin

    if(icode == 4'd2) // cmovXX
    begin
        if(Cnd == 1)
        begin
            reg_mem[rB] = valE;
        end
    end
    else if(icode == 4'd3) // irmovq
    begin
        reg_mem[rB] = valE;
    end
    else if(icode == 4'd5) // mrmovq
    begin
        reg_mem[rA] = valM;
    end
    else if(icode == 4'd6) // OPq
    begin
        reg_mem[rB] = valE;
    end
    else if(icode == 4'd8) // call
    begin
        reg_mem[4] = valE;
    end
    else if(icode == 4'd9) // ret
    begin
        reg_mem[4] = valE;
    end
    else if(icode == 4'd10) // pushq
    begin
        reg_mem[4] = valE;
    end
    else if(icode == 4'd11) // popq
    begin
        reg_mem[4] = valE;
        reg_mem[rA] = valM;
    end

    rax = reg_mem[0];
    rcx = reg_mem[1];
    rdx = reg_mem[2];
    rbx = reg_mem[3];
    rsp = reg_mem[4];
    rbp = reg_mem[5];
    rsi = reg_mem[6];
    rdi = reg_mem[7];
    r8 = reg_mem[8];
    r9 = reg_mem[9];
    r10 = reg_mem[10];
    r11 = reg_mem[11];
    r12 = reg_mem[12];
    r13 = reg_mem[13];
    r14 = reg_mem[14];

end

endmodule