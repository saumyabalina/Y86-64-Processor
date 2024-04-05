`include "memory.v"

module testbench;

reg clk;
reg [3:0]icode;
reg [63:0]valA,valE,valP;
wire [63:0]valM;
wire dmem_error;

memory call(.clk(clk), .icode(icode), .valA(valA), .valE(valE), .valP(valP), .valM(valM), .dmem_error(dmem_error));

initial
begin
    $dumpfile("memory.vcd");
    $dumpvars(0,testbench);
end

always #5 clk = ~clk;
initial
begin
    $monitor($time," clk %d: icode=%d, valA=%d, valE=%d, valP=%d, valM=%d, dmem_error=%d",clk,icode,valA,valE,valP,valM,dmem_error);
end

initial
begin
    clk = 1;

    #5 icode = 4'd4; valA = 64'd100; valE = 64'd24; valP = 64'd0;

    #10 icode = 4'd5; valA = 64'd0; valE = 64'd8; valP = 64'd3;

    #10 icode = 4'd8; valA = 64'd0; valE = 64'd32; valP = 64'd64;

    #10 icode = 4'd9; valA = 64'd32; valE = 64'd0; valP = 64'd1;

    #10 icode = 4'd10; valA = 64'd10; valE = 64'd20; valP = 64'd2;

    #10 icode = 4'd11; valA = 64'd20; valE = 64'd0; valP = 64'd7;

    #10 icode = 4'd4; valA = 64'd0; valE = 64'd1200; valP = 64'd0;

    #10 icode = 4'd3; valA = 64'd1; valE = 64'd1; valP = 64'd1;
    #5 $finish;
end
endmodule