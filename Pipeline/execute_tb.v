`include "decode_wb.v"

module testbench;

reg clk;
reg [1:0]E_stat;
reg [3:0]E_icode;
reg [3:0]E_ifun;
reg signed [63:0]E_valC;
reg signed [63:0]E_valA;
reg signed [63:0]E_valB;
reg [3:0]E_dstE;
reg [3:0]E_dstM;
reg set_cc;
reg M_bubble;

wire [1:0]M_stat;
wire [3:0]M_icode;
wire [3:0]M_Cnd;
wire [63:0]M_valE;
wire [63:0]M_valA;
wire [63:0]e_valE;
wire [3:0]M_dstE;
wire [3:0]M_dstM;
wire [3:0]e_dstE;
wire e_Cnd;

decode_wb call(.clk(clk), .E_stat(E_stat), .E_icode(E_icode), .E_ifun(E_ifun), 
.E_valC(E_valC), .E_valA(E_valA), .E_valB(E_valB), .E_dstE(E_dstE), 
.E_dstM(E_dstM), .set_cc(set_cc), .M_bubble(M_bubble), .M_stat(M_stat), .M_icode(M_icode), 
.M_valE(M_valE), .M_valA(M_valA), .e_valE(e_valE), .e_dstE(e_dstE), .M_dstM(M_dstM), .e_dstE(e_dstE), 
.e_Cnd(e_Cnd));

initial
begin
    $dumpfile("execute.vcd");
    $dumpvars(0,testbench);
end

always #5 clk = ~clk;
initial
begin
    $monitor($time," clk %d: E_stat=%d, E_icode=%d, E_valC=%d, E_valA=%d, E_valB=%d, set_cc=%d, M_bubble=%d, M_stat=%d, M_icode=%d, M_Cnd=%d, M_valE=%d, M_valA=%d, e_valE=%d",clk,D_stat,D_icode,E_valC,E_valA,E_valB, set_cc, M_bubble, M_stat, M_icode, M_Cnd, M_valE, M_valA, e_valE);
end

initial
begin
    clk = 0; E_stat = 2'd0; 
    #5 $finish;
end

endmodule