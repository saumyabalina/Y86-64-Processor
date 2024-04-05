`include "decode_wb.v"

module testbench;

reg clk;
reg [1:0]D_stat;
reg [3:0]D_icode;
reg [3:0]D_ifun;
reg[3:0] D_rA;
reg[3:0] D_rB;
reg signed [63:0]D_valC;
reg [63:0]D_valP;
reg E_bubble;
reg [3:0]e_dstE;
reg signed [63:0]e_valE;
reg [3:0]M_dstM;
reg signed [63:0]m_valM;
reg [3:0]M_dstE;
reg signed [63:0]M_valE;
reg [3:0]W_dstM;
reg signed [63:0]W_valM;
reg [3:0]W_dstE;
reg signed [63:0]W_valE;
reg [1:0]W_stat;
reg [3:0]W_icode;
reg W_stall;

wire [1:0]E_stat;
wire [3:0]E_icode;
wire [3:0]E_ifun;
wire [63:0]E_valC;
wire [63:0]E_valA;
wire [63:0]E_valB;
wire [3:0]E_dstE;
wire [3:0]E_dstM;
wire [3:0]E_srcA;
wire [3:0]E_srcB;
wire [63:0]rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14;

decode_wb call(.clk(clk), .D_stat(D_stat), .D_icode(D_icode), .D_ifun(D_ifun), .D_rA(D_rA), .D_rB(D_rB), .D_valC(D_valC), .D_valP(D_valP), .E_bubble(E_bubble), .e_dstE(e_dstE), .e_valE(e_valE), .M_dstM(M_dstM), .m_valM(m_valM), .M_dstE(M_dstE), .M_valE(M_valE), .W_dstM(W_dstM), .W_valM(W_valM), .W_valE(W_valE), .W_stat(W_stat), .W_icode(W_icode), .W_stall(W_stall), .E_stat(E_stat), .E_icode(E_icode), .E_ifun(E_ifun), .E_valC(E_valC), .E_valA(E_valA), .E_valB(E_valB), .E_dstE(E_dstE), .E_dstM(E_dstM), .E_srcA(E_srcA), .E_srcB(E_srcB),
            .rax(rax), .rcx(rcx), .rdx(rdx), .rbx(rbx), .rsp(rsp), .rbp(rbp), .rsi(rsi), .rdi(rdi), .r8(r8), .r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14));

initial
begin
    $dumpfile("decode_wb.vcd");
    $dumpvars(0,testbench);
end

always #5 clk = ~clk;
initial
begin
    $monitor($time," clk %d: D_stat=%d, D_icode=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, E_bubble=%d, E_stat=%d, E_icode=%d, E_valC=%d, E_valA=%d, E_valB=%d",clk,D_stat,D_icode,D_rA,D_rB,D_valC,D_valP,E_bubble, E_stat, E_icode, E_valC, E_valA, E_valB);
end

initial
begin
    // clk = 1;
    // D_stat = 2'd0; D_ifun = 4'd0; E_bubble = 0;
    // e_dstE = 4'd15; e_valE = 0;
    // M_dstM = 4'd15; m_valM = 0;
    // M_dstE = 4'd15; M_valE = 0;
    // W_dstM = 4'd15; W_valM = 0;
    // W_dstE = 4'd15; W_valE = 0;
    // W_stat = 2'd0; W_icode = 4'd1; W_stall = 0;
    // D_valC = 64'd1; D_valP = 64'd0;

    // #5 D_icode = 4'd2; D_rA = 4'd0; D_rB = 4'd1;

    // #10 D_icode = 4'd4; D_rA = 4'd1; D_rB = 4'd2;

    // #10 icode = 4'd5; rA = 4'd0; rB = 4'd3;

    // #10 icode = 4'd6; rA = 4'd1; rB = 4'd3;

    // #10 icode = 4'd8; rA = 4'd8; rB = 4'd0;

    // #10 icode = 4'd9; rA = 4'd9; rB = 4'd10;

    // #10 icode = 4'd10; rA = 4'd2; rB = 4'd0;

    // #10 icode = 4'd11; rA = 4'd9; rB = 4'd1;

    // #10 icode = 4'd3; rA = 4'd2; rB = 4'd8;
    #5 $finish;
end

endmodule