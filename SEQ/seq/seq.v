`include "fetch.v"
`include "decode_wb.v"
`include "execute.v"
`include "memory.v"
`include "pc_update.v"

module testbench;

reg clk;
reg [63:0]PC;
wire [3:0]icode,ifun,rA,rB;
wire [63:0]valP,valC,valA,valB,valE,valM,PC_u;
wire mem_error,i_error,halt,dmem_error,Cnd;
wire [63:0]rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14;

reg [1:0]s_c; // status conditions

fetch fet(.clk(clk), .valP(valP), .icode(icode), .ifun(ifun), .rA(rA), .rB(rB), .PC(PC), .valC(valC), .mem_error(mem_error), .i_error(i_error), .halt(halt));
decode_wb dw(.clk(clk), .Cnd(Cnd), .icode(icode), .rA(rA), .rB(rB), .valE(valE), .valM(valM), .valA(valA), .valB(valB), .rax(rax), .rcx(rcx), .rdx(rdx), .rbx(rbx), .rsp(rsp), .rbp(rbp), .rsi(rsi), .rdi(rdi), .r8(r8), .r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14));
execute exe(.clk(clk), .icode(icode), .ifun(ifun), .valA(valA), .valB(valB), .valC(valC), .valE(valE), .Cnd(Cnd));
memory mem(.clk(clk), .icode(icode), .valA(valA), .valE(valE), .valP(valP), .valM(valM), .dmem_error(dmem_error));
pc_update pcu(.clk(clk), .Cnd(Cnd), .icode(icode), .valP(valP), .valC(valC), .valM(valM), .PC_u(PC_u));


initial
begin
    $dumpfile("seq.vcd");
    $dumpvars(0,testbench);

    clk = 1;
    PC = 64'd0;
    s_c = 2'd0; // 0->AOK, 1->HLT, 2->ADR, 3->INS
end

always #5 clk = ~clk;

always @(*)
begin
    PC = PC_u;
end

always @(*)
begin
    if(halt == 1)
    begin
        s_c = 2'd1;
    end
    else if((dmem_error == 1) || (mem_error == 1))
    begin
        s_c = 2'd2;
        // $display($time, " mem_error=%d, dmem_error=%d",mem_error, dmem_error);
    end
    else if(i_error == 1)
    begin
        s_c = 2'd3;
    end

    if(s_c != 0)
    begin
        $finish;
    end
end


initial
begin
    $monitor($time," clk %d: icode=%d, ifun=%d, rA=%d, rB=%d, valP=%d, valC=%d, PC=%d, mem_error=%d, i_error=%d, halt=%d",clk,icode,ifun,rA,rB,valP,valC,PC,mem_error,i_error,halt);
    // $monitor($time, " clk %d: icode=%d: Cnd=%d: valA=%d: valB=%d: valM=%d: valE=%d: rsp=%d ",clk,icode,Cnd,valA,valB,valM,valE,rsp);
    // $monitor($time," clk %d: icode=%d, ifun=%d, valA=%d, valB=%d, valC=%d, valE=%d, Cnd=%d",clk,icode,ifun,valA,valB,valC,valE,Cnd);
    // $monitor($time," clk %d: icode=%d, valA=%d, valE=%d, valP=%d, valM=%d, dmem_error=%d",clk,icode,valA,valE,valP,valM,dmem_error);
    // $monitor($time," clk %d; icode=%d; Cnd=%d; valP=%d; valC=%d; valM=%d; PC=%d",clk,icode,Cnd,valP,valC,valM,PC_u);
    // $monitor($time," clk %d: s_c=%d: i_error=%d: dmem_error=%d: halt=%d: mem_error=%d",clk,s_c,i_error,dmem_error,halt,mem_error);
end

// initial
// begin
//     #40 $finish;
// end

endmodule