`include "decode.v"

module testbench;

reg clk;
reg [3:0]icode,rA,rB;
wire [63:0]valA,valB;

decode call (.clk(clk), .icode(icode), .rA(rA), .rB(rB), .valA(valA), .valB(valB));

initial
begin
    $dumpfile("decode.vcd");
    $dumpvars(0,testbench);
end

always #5 clk = ~clk;
initial
begin
    $monitor($time," clk %d: icode=%d, rA=%d, rB=%d, valA=%d, valB=%d",clk,icode,rA,rB,valA,valB);
end

initial
begin

    clk = 1;
    #5 icode = 4'd2; rA = 4'd0; rB = 4'd1;

    #10 icode = 4'd4; rA = 4'd1; rB = 4'd2;

    #10 icode = 4'd5; rA = 4'd0; rB = 4'd3;

    #10 icode = 4'd6; rA = 4'd1; rB = 4'd3;

    #10 icode = 4'd8; rA = 4'd8; rB = 4'd0;

    #10 icode = 4'd9; rA = 4'd9; rB = 4'd10;

    #10 icode = 4'd10; rA = 4'd2; rB = 4'd0;

    #10 icode = 4'd11; rA = 4'd9; rB = 4'd1;

    #10 icode = 4'd3; rA = 4'd2; rB = 4'd8;
    #5 $finish;

end
endmodule
