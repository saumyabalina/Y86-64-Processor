`include "execute.v"

module testbench;

    reg clk;
    reg [3:0]icode;
    reg [3:0]ifun;
    reg [63:0]valA;
    reg [63:0]valB;
    reg [63:0]valC;
    wire signed[63:0]valE;
    wire Cnd;

    execute call(.clk(clk), .icode(icode), .ifun(ifun), .valA(valA), .valB(valB), .valC(valC), .valE(valE), .Cnd(Cnd));

    initial
    begin
        $dumpfile("execute.vcd");
        $dumpvars(0,testbench);

        clk = 0;
        icode = 4'd0;
        ifun = 4'd0;
        valA = 64'd0;
        valB = 64'd0;
        valC = 64'd0;
    end

    initial
    begin
        $monitor($time," clk %d: icode=%d, ifun=%d, valA=%d, valB=%d, valC=%d, valE=%d, Cnd=%d",clk,icode,ifun,valA,valB,valC,valE,Cnd);
    end

    initial
    begin
        #10 clk=~clk;
        icode=4'b0110;
        ifun=4'b0001;
        valA=64'd10;
        valB=64'd50;
        valC=64'd20;
        #10 clk=~clk;
        #10 clk=~clk;
        icode=4'b0111;
        ifun=4'b0100;
        valA=64'd10;
        valB=64'd50;
        valC=64'd20;
        #10 clk=~clk;
        #10 clk=~clk;
        icode=4'b1000;
        ifun=4'b0000; 
        valA=64'd10;
        valB=64'd50;
        valC=64'd20;
        #10 clk=~clk;
    end

endmodule