`include "memory.v"

module testbench;

reg clk,W_stall;
reg [3:0]M_icode,M_dstE,M_dstM;
reg [63:0]M_valA,M_valE;
reg [1:0]M_stat;
wire [3:0]W_icode,W_dstE,W_dstM;
wire [63:0]W_valE,W_valM;
wire [1:0]W_stat;

memory call(.clk(clk), .M_icode(M_icode), .M_valA(M_valA), .M_valE(M_valE), .M_dstE(M_dstE), .M_dstM(M_dstM), .M_stat(M_stat), .W_stall(W_stall), .W_icode(W_icode), .W_valE(W_valE), .W_valM(W_valM), .W_dstE(W_dstE), .W_dstM(W_dstM), .W_stat(W_stat));

initial
begin
    $dumpfile("memory.vcd");
    $dumpvars(0,testbench);
end

always #5 clk = ~clk;
initial
begin
    $monitor($time," clk=%d: icode=%d, valA=%d, valE=%d, valM=%d, stat=%d, W_icode=%d",clk,M_icode,M_valA,M_valE,W_valM,W_stat,W_icode);
end

initial
begin
    clk = 1;

    #5 M_icode = 4'd4; M_valA = 64'd100; M_valE = 64'd24; W_stall = 0;

    #10 M_icode = 4'd5; M_valA = 64'd15; M_valE = 64'd8; W_stall = 0;

    #10 M_icode = 4'd8; M_valA = 64'd6; M_valE = 64'd32; W_stall = 0;

    #10 M_icode = 4'd9; M_valA = 64'd32; M_valE = 64'd0; W_stall = 0;

    #10 M_icode = 4'd10; M_valA = 64'd10; M_valE = 64'd20; W_stall = 0;

    #10 M_icode = 4'd11; M_valA = 64'd20; M_valE = 64'd0; W_stall = 0;

    #10 M_icode = 4'd4; M_valA = 64'd0; M_valE = 64'd1200; W_stall = 1;

    #10 M_icode = 4'd3; M_valA = 64'd1; M_valE = 64'd1; W_stall = 0;
    #5 $finish;
end
endmodule