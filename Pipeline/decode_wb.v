module decode_wb(
    input clk,
    input [1:0]D_stat,
    input [3:0]D_icode,
    input [3:0]D_ifun,
    input [3:0]D_rA,
    input [3:0]D_rB,
    input signed[63:0]D_valC,
    input [63:0]D_valP,
    input E_bubble,
    input [3:0]e_dstE,
    input signed[63:0]e_valE,
    input [3:0]M_dstM,
    input signed [63:0]m_valM,
    input [3:0]M_dstE,
    input signed[63:0]M_valE,
    input [3:0]W_dstM,
    input signed[63:0]W_valM,
    input [3:0]W_dstE,
    input signed[63:0]W_valE,
    input [1:0]W_stat,
    input [3:0]W_icode,
    input W_stall,
    output reg[1:0]E_stat,
    output reg[3:0]E_icode,
    output reg[3:0]E_ifun,
    output reg[63:0]E_valC,
    output reg[63:0]E_valA,
    output reg[63:0]E_valB,
    output reg[3:0]E_dstE,
    output reg[3:0]E_dstM,
    output reg[3:0]E_srcA,
    output reg[3:0]E_srcB,
    output reg[63:0]rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14,
    output reg[3:0]d_srcA,
    output reg[3:0]d_srcB
);

reg [3:0]icode;
reg [3:0]ifun;
reg [3:0]srcA;
reg [3:0]srcB;
reg [3:0]dstE;
reg [3:0]dstM;
reg signed[63:0]valA;
reg signed[63:0]valB;
reg signed[63:0]valC;
reg signed[63:0]valP;

always @(*) begin
    icode = D_icode;
    ifun = D_ifun;
    valC = D_valC;
    valP = D_valP;
end

reg [63:0]reg_mem[0:14];

initial
begin
    rsp = 64'd32;
    reg_mem[0] = rax;
    reg_mem[1] = rcx;
    reg_mem[2] = rdx;
    reg_mem[3] = rbx;
    reg_mem[4] = rsp;
    reg_mem[5] = rbp;
    reg_mem[6] = rsi;
    reg_mem[7] = rdi;
    reg_mem[8] = r8;
    reg_mem[9] = r9;
    reg_mem[10] = r10;
    reg_mem[11] = r11;
    reg_mem[12] = r12;
    reg_mem[13] = r13;
    reg_mem[14] = r14;
    
end

always @(*)
begin
    if(icode == 4'd2) // cmovXX
    begin
        srcA = D_rA;
        srcB = D_rB;
        dstE = D_rB;
        dstM = 4'd15;
        valA = reg_mem[D_rA];
        valB = 4'd0;
    end
    else if(icode == 4'd3) // irmovq
    begin
        srcA = 4'd15;
        srcB = 4'd15;
        dstE = D_rB;
        dstM = 4'd15;
    end
    else if(icode == 4'd4) // rmmovq
    begin
        srcA = D_rA;
        srcB = D_rB;
        dstE = D_rB;
        dstM = 4'd15;
        valA = reg_mem[D_rA];
        valB = reg_mem[D_rB];
    end
    else if(icode == 4'd5) // mrmovq
    begin
        srcA = 4'd15;
        srcB = D_rB;
        dstE = 4'd15;
        dstM = D_rA;
        valB = reg_mem[D_rB];
    end
    else if(icode == 4'd6) // OPq
    begin
        srcA = D_rA;
        srcB = D_rB;
        dstE = D_rB;
        dstM = 4'd15;
        valA = reg_mem[D_rA];
        valB = reg_mem[D_rB];
    end
    else if(icode == 4'd8) // call
    begin
        srcA = 4'd15;
        srcB = 4'd4;
        dstE = 4'd4;
        dstM = 4'd15;
        valB = reg_mem[4];
    end
    else if(icode == 4'd9) // ret
    begin
        srcA = 4'd4;
        srcB = 4'd4;
        dstE = 4'd4;
        dstM = 4'd15;
        valA = reg_mem[4];
        valB = reg_mem[4];
    end
    else if(icode == 4'd10) // pushq
    begin
        srcA = D_rA;
        srcB = 4'd4;
        dstE = 4'd4;
        dstM = 4'd15;
        valA = reg_mem[D_rA];
        valB = reg_mem[4]; 
    end
    else if(icode == 4'd11) // popq
    begin
        srcA = 4'd4;
        srcB = 4'd4;
        dstE = 4'd4;
        dstM = 4'd15;
        valA = reg_mem[4];
        valB = reg_mem[4];
    end
    else
    begin
        srcA = 4'd15;
        srcB = 4'd15;
        dstE = 4'd15;
        dstM = 4'd15;
    end
    d_srcA = srcA;
    d_srcB = srcB;
end

// Forwarding logic for valA
always @(*) begin
    if(icode == 4'd7 || icode == 4'd8)
    begin
        valA = D_valP;
    end
    else if(srcA == e_dstE && srcA != 4'd15)
    begin
        valA = e_valE;
    end
    else if(srcA == M_dstM && srcA != 4'd15)
    begin
        valA = m_valM;
    end
    else if(srcA == M_dstE && srcA != 4'd15)
    begin
        valA = M_valE;
    end
    else if(srcA == W_dstM && srcA != 4'd15)
    begin
        valA = W_valM;
    end
    else if(srcA == W_dstE && srcA != 4'd15)
    begin
        valA = W_valE;
    end
    // $display("icode=%d, srcA=%d, e_dste=%d, M_dstM=%d, M_dstE=%d, W_dstM=%d, W_dstE=%d",icode,srcA,e_dstE,M_dstM,M_dstE,W_dstM,W_dstE);
end

// Forwarding logic for valB
always @(*) begin
    if(srcB == e_dstE && srcB != 4'd15)
    begin
        valB = e_valE;
    end
    else if(srcB == M_dstM && srcB != 4'd15)
    begin
        valB = m_valM;
    end
    else if(srcB == M_dstE && srcB != 4'd15)
    begin
        valB = M_valE;
    end
    else if(srcB == W_dstM && srcB != 4'd15)
    begin
        valB = W_valM;
    end
    else if(srcB == W_dstE && srcB != 4'd15)
    begin
        valB = W_valE;
    end
    // $display("icode=%d, srcB=%d, M_dstM=%d, valB=%d, m_valM=%d",icode,srcB,M_dstM,W_dstM,W_dstE,e_dstE,M_dstE,valB,m_valM);
end

always @(posedge clk)
begin
    if(E_bubble == 1) begin
        E_stat <= 2'd0;
        E_icode <= 4'd1; // nop
        E_ifun <= 4'd0;
        E_valC <= 64'd0;
        E_valA <= 64'd0;
        E_valB <= 64'd0;
        E_dstE <= 4'd15;
        E_dstM <= 4'd15;
        E_srcA <= 4'd15;
        E_srcB <= 4'd15;
    end
    else begin
        E_stat <= D_stat;
        E_icode <= D_icode;
        E_ifun <= D_ifun;
        E_valC <= D_valC;
        E_valA <= valA;
        E_valB <= valB;
        E_dstE <= dstE;
        E_dstM <= dstM;
        E_srcA <= srcA;
        E_srcB <= srcB;
    end
end

// Write Back
always @(posedge clk)
begin
    if(W_stall == 1)
    begin
    end
    else
    begin
        if(W_icode == 4'd2) // cmovXX
        begin
            reg_mem[W_dstE] = W_valE;
        end
        else if(W_icode == 4'd3) // irmovq
        begin
            reg_mem[W_dstE] = W_valE;
        end
        else if(W_icode == 4'd5) // mrmovq
        begin
            reg_mem[W_dstM] = W_valM;
        end
        else if(W_icode == 4'd6) // OPq
        begin
            reg_mem[W_dstE] = W_valE;
        end
        else if(W_icode == 4'd8) // call
        begin
            reg_mem[W_dstE] = W_valE;
        end
        else if(W_icode == 4'd9) // ret
        begin
            reg_mem[W_dstE] = W_valE;
        end
        else if(W_icode == 4'd10) // pushq
        begin
            reg_mem[W_dstE] = W_valE;
        end
        else if(W_icode == 4'd11) // popq
        begin
            reg_mem[W_dstE] = W_valE;
            reg_mem[W_dstM] = W_valM;
        end
    end

    rax <= reg_mem[0];
    rcx <= reg_mem[1];
    rdx <= reg_mem[2];
    rbx <= reg_mem[3];
    rsp <= reg_mem[4];
    rbp <= reg_mem[5];
    rsi <= reg_mem[6];
    rdi <= reg_mem[7];
    r8 <= reg_mem[8];
    r9 <= reg_mem[9];
    r10 <= reg_mem[10];
    r11 <= reg_mem[11];
    r12 <= reg_mem[12];
    r13 <= reg_mem[13];
    r14 <= reg_mem[14];


end

endmodule