`include "fetch.v"

module testbench;

reg clk;
reg [63:0]PC;
wire [3:0]icode,ifun,rA,rB;
wire [63:0]valP,valC;
wire mem_error,i_error,halt;

fetch call(.clk(clk), .valP(valP), .icode(icode), .ifun(ifun), .rA(rA), .rB(rB), .PC(PC), .valC(valC), .mem_error(mem_error), .i_error(i_error), .halt(halt));

initial
begin
    $dumpfile("fetch.vcd");
    $dumpvars(0,testbench);
end

always #5 clk = ~clk;
initial
begin
    $monitor($time," clk %d: icode=%d, ifun=%d, rA=%d, rB=%d, valP=%d, valC=%d, PC=%d, mem_error=%d, i_error=%d, halt=%d",clk,icode,ifun,rA,rB,valP,valC,PC,mem_error,i_error,halt);
end

initial
begin
    clk = 1;

    #5 PC = 64'd0;

    #10 PC = valP;

    #10 PC = valP;

    #10 PC = valP;

    #10 PC = valP;

    #10 PC = valP;

    #10 PC = valP;

    #10 PC = valP;

    #10 PC = valP;

    #10 PC = valP;

    #10 PC = valP;

    #10 PC = 64'd76;
    #5 $finish;
end
endmodule