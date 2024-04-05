`include "fetch.v"

module testbench;

reg clk,M_Cnd,D_stall,D_bubble;
reg [63:0]F_predPC,M_valA,W_valM;
reg [3:0]M_icode,W_icode;
wire [3:0]D_icode,D_ifun,D_rA,D_rB;
wire [63:0]D_valP,D_valC,f_predPC;
wire [1:0]D_stat;

fetch call(.clk(clk),.M_Cnd(M_Cnd),.D_stall(D_stall),.D_bubble(D_bubble),.F_predPC(F_predPC),.M_valA(M_valA), .W_valM(W_valM), .M_icode(M_icode), .W_icode(W_icode), .D_icode(D_icode), .D_ifun(D_ifun), .D_rA(D_rA), .D_rB(D_rB), .D_valP(D_valP), .D_valC(D_valC), .f_predPC(f_predPC), .D_stat(D_stat));

initial
begin
    $dumpfile("fetch.vcd");
    $dumpvars(0,testbench);
end

always #5 clk = ~clk;
initial
begin
    $monitor($time,"clk =%d: icode=%d, ifun=%d, rA=%d, rB=%d, valP=%d, valC=%d, predPC=%d,stat=%d", clk,D_icode,D_ifun,D_rA,D_rB,D_valP,D_valC,f_predPC,D_stat);
end

initial 
begin
    clk = 0;

    #5 F_predPC = 64'd0;

    #10 F_predPC = f_predPC; 

    #10 F_predPC = f_predPC; 

    #10 F_predPC = f_predPC;

    #10 F_predPC = f_predPC;

    #10 F_predPC = f_predPC;

    #10 F_predPC = f_predPC; D_stall = 1;

    #10 F_predPC = f_predPC; D_stall= 1;
 

    #5 $finish;
end
endmodule