`include "F_reg.v"
`include "fetch.v"
`include "decode_wb.v"
`include "execute.v"
`include "memory.v"
`include "pipeline_control_logic.v"

module testbench;

reg clk;
reg [63:0]F_predPC;
wire [3:0]D_icode,D_ifun,D_rA,D_rB;
wire signed[63:0]D_valP,D_valC,f_predPC;
wire [1:0]D_stat;
wire [3:0]E_icode,E_ifun,E_dstE,E_dstM,E_srcA,E_srcB;
wire signed[63:0]E_valC,E_valA,E_valB,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14;
wire [1:0]E_stat;
wire [3:0]M_icode,M_dstE,M_dstM,e_dstE;
wire signed[63:0]M_valE,M_valA,e_valE;
wire [1:0]M_stat;
wire e_Cnd, M_Cnd;
wire [3:0]W_icode,W_dstE,W_dstM;
wire signed[63:0]W_valE,W_valM;
wire [1:0]W_stat;
wire F_stall,D_stall,D_bubble,E_bubble,M_bubble,W_stall,set_cc;
wire [3:0]d_srcA,d_srcB;
wire signed[63:0]m_valM;
wire [1:0]m_stat;
wire c_z,c_o,c_s;

reg [1:0]stat; // status conditions

// F_reg fr(.clk(clk),.f_predPC(f_predPC),.F_stall(F_stall),.F_predPC(F_predPC));
fetch fet(.clk(clk),.F_predPC(F_predPC),.M_valA(M_valA),.W_valM(W_valM),.M_icode(M_icode),.M_Cnd(M_Cnd),.W_icode(W_icode),.D_stall(D_stall),.D_bubble(D_bubble),.D_icode(D_icode),.D_ifun(D_ifun),.D_rA(D_rA),.D_rB(D_rB),.D_valP(D_valP),.D_valC(D_valC),.f_predPC(f_predPC),.D_stat(D_stat));
decode_wb dw(.clk(clk),.D_stat(D_stat),.D_icode(D_icode),.D_ifun(D_ifun),.D_rA(D_rA),.D_rB(D_rB),.D_valC(D_valC),.D_valP(D_valP),.E_bubble(E_bubble),.e_dstE(e_dstE),.e_valE(e_valE),.M_dstM(M_dstM),.m_valM(m_valM),.M_dstE(M_dstE),.M_valE(M_valE),.W_dstM(W_dstM),.W_valM(W_valM),.W_dstE(W_dstE),
             .W_valE(W_valE),.W_stat(W_stat),.W_icode(W_icode),.W_stall,.E_stat(E_stat),.E_icode(E_icode),.E_ifun(E_ifun),.E_valC(E_valC),.E_valA(E_valA),.E_valB(E_valB),.E_dstE(E_dstE),.E_dstM(E_dstM),.E_srcA(E_srcA),.E_srcB(E_srcB),.rax(rax),.rcx(rcx),.rdx(rdx),.rbx(rbx),.rsp(rsp),.rbp(rbp),
             .rsi(rsi),.rdi(rdi),.r8(r8),.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14),.d_srcA(d_srcA),.d_srcB(d_srcB));
execute exe(.clk(clk),.E_stat(E_stat),.E_icode(E_icode),.E_ifun(E_ifun),.E_valC(E_valC),.E_valA(E_valA),.E_valB(E_valB),.E_dstE(E_dstE),.E_dstM(E_dstM),.set_cc(set_cc),.M_bubble(M_bubble),.M_stat(M_stat),.M_icode(M_icode),.M_Cnd(M_Cnd),.M_valE(M_valE),.M_valA(M_valA),.e_valE(e_valE),.M_dstE(M_dstE),.M_dstM(M_dstM),.e_dstE(e_dstE),.e_Cnd(e_Cnd),.c_z(c_z),.c_s(c_s),.c_o(c_o));
memory mry(.clk(clk),.M_icode(M_icode),.M_valA(M_valA),.M_valE(M_valE),.M_dstE(M_dstE),.M_dstM(M_dstM),.M_stat(M_stat),.W_stall(W_stall),.W_icode(W_icode),.W_valE(W_valE),.W_valM(W_valM),.W_dstE(W_dstE),.W_dstM(W_dstM),.W_stat(W_stat),.m_valM(m_valM),.m_stat(m_stat));
pipe_control_logic pcl(.D_icode(D_icode),.E_icode(E_icode),.M_icode(M_icode),.m_stat(m_stat),.W_stat(W_stat),.d_srcA(d_srcA),.d_srcB(d_srcB),.E_dstM(E_dstM),.e_Cnd(e_Cnd),.F_stall(F_stall),.D_stall(D_stall),.D_bubble(D_bubble),.E_bubble(E_bubble),.M_bubble(M_bubble),.W_stall(W_stall),.set_cc(set_cc));


always @(W_stat)
begin
    stat = W_stat;
end

always @(stat)
begin
    
    if(stat != 0)
    begin
        if(stat == 1)
        begin
            $display($time ," Halt");
            $finish;
        end
        else if(stat == 2)
        begin
            $display($time ," Memory Error");
            $finish;
        end
        else if(stat == 3)
        begin
            $display($time ," Instruction Invalid");
            $finish;
        end
    end
end


always @(posedge clk)
begin
    
    if(F_stall == 0)
    begin
        F_predPC <= f_predPC;
    end
end

always #5 clk = ~clk;

initial
begin
    $dumpfile("pipe.vcd");
    $dumpvars(0,testbench);

    clk = 0;
    F_predPC = 64'd0;
end


always @(negedge clk)
begin
    $display($time," clk : %d",clk);
    $display("FETCH STAGE--------------------------------------------------------------------------------------------------------");
    $display("icode=%d, ifun=%d, rA=%d, rB=%d, valP=%d, valC=%d, predPC=%d, stat=%d", D_icode,D_ifun,D_rA,D_rB,D_valP,D_valC,f_predPC,D_stat);
    $display("DECODE STAGE--------------------------------------------------------------------------------------------------------");
    $display("icode=%d, E_valA=%d, E_valB=%d, stat=%d", E_icode, E_valA, E_valB, E_stat);
    $display("EXECUTE STAGE--------------------------------------------------------------------------------------------------------");
    $display("icode=%d, valE=%d, valA=%d, stat=%d, set_cc=%d", M_icode, M_valE, M_valA, M_stat,set_cc);
    $display("MEMORY STAGE--------------------------------------------------------------------------------------------------------");
    $display("icode=%d, stat=%d, valM=%d", W_icode, W_stat, W_valM);
    $display("F_stall=%d, D_stall=%d, D_bubble=%d, E_bubble=%d, M_bubble=%d, W_stall=%d",F_stall,D_stall,D_bubble,E_bubble,M_bubble,W_stall);
    $display("zf = %d, sf = %d, of = %d",c_z,c_s,c_o);
end

// initial
// begin
//     #200 $finish;
// end

// initial
// begin
//     $monitor($time, " clk =%d,M_icode=%d, e_valE=%d, M_valE=%d, W_valE=%d", clk,M_icode,e_valE,M_valE,W_valE);
// end
endmodule