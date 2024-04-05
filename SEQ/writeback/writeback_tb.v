`include "writeback.v"

module testbench;

    reg clk;
    reg [3:0]icode;
    reg [3:0]rA;
    reg [3:0]rB;
    reg [63:0]valE;
    reg [63:0]valM;
    reg[63:0]valA,valB,valC;
    reg[3:0]ifun;
    reg Cnd;
    wire [63:0]rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14;

    writeback call(.clk(clk), .icode(icode), .rA(rA), .rB(rB), .valE(valE), .valM(valM), .Cnd(Cnd), .rax(rax), .rcx(rcx), .rdx(rdx), .rbx(rbx), .rsp(rsp), .rbp(rbp), .rsi(rsi), .rdi(rdi), .r8(r8), .r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14));

    initial
    begin
        $dumpfile("writeback.vcd");
        $dumpvars(0,testbench);
    end

    always #5 clk = ~clk;
    always@(negedge clk)
    begin
        #1
        $monitor($time," clk %d: icode=%d, rA=%d, rB=%d, valE=%d, valM=%d, Cnd=%d, rax=%d, rcx=%d, rdx=%d, rbx=%d, rsp=%d, rbp=%d, rsi=%d, rdi=%d, r8=%d, r9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d",clk,icode,rA,rB,valE,valM,Cnd,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14);
    end

    initial
    begin
        
        clk = 1;
        #5 icode = 4'd2; rA = 4'd0; rB = 4'd1; valE = 64'd100; valM = 64'd10; Cnd = 0;

        #10 icode = 4'd2; rA = 4'd0; rB = 4'd1; valE = 64'd100; valM = 64'd10; Cnd = 1;

        #10 icode = 4'd3; rA = 4'd2; rB = 4'd3; valE = 64'd200; valM = 64'd20; Cnd = 0;

        #10 icode = 4'd5; rA = 4'd0; rB = 4'd2; valE = 64'd300; valM = 64'd30; Cnd = 0;

        #10 icode = 4'd6; rA = 4'd1; rB = 4'd2; valE = 64'd400; valM = 64'd40; Cnd = 0;

        #10 icode = 4'd8; rA = 4'd8; rB = 4'd9; valE = 64'd500; valM = 64'd50; Cnd = 0;

        #10 icode = 4'd9; rA = 4'd2; rB = 4'd1; valE = 64'd600; valM = 64'd60; Cnd = 1;

        #10 icode = 4'd10; rA = 4'd3; rB = 4'd1; valE = 64'd700; valM = 64'd70; Cnd = 0;

        #10 icode = 4'd11; rA = 4'd0; rB = 4'd2; valE = 64'd800; valM = 64'd80; Cnd = 0;

        #10 icode = 4'd7; rA = 4'd0; rB = 4'd1; valE = 64'd100; valM = 64'd10; Cnd = 0;
        #5 $finish;
    end
endmodule