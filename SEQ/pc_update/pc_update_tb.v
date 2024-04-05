`include "pc_update.v"

module testbench;

reg clk,Cnd;
reg [3:0]icode;
reg [63:0]valP,valC,valM;
wire [63:0]PC_u;

pc_update call(.clk(clk), .Cnd(Cnd), .icode(icode), .valP(valP), .valC(valC), .valM(valM), .PC_u(PC_u));

initial
begin
    $dumpfile("pc_update.vcd");
    $dumpvars(0,testbench);
end

always #5 clk = ~clk;
initial
begin
    $monitor($time," clk %d; icode=%d; Cnd=%d; valP=%d; valC=%d; valM=%d; PC=%d",clk,icode,Cnd,valP,valC,valM,PC_u);
end

initial
begin
    clk = 1;
    #5 icode = 4'd7; Cnd = 0; valP = 64'd4; valC = 64'd8; valM = 64'd0;

    #10 icode = 4'd7; Cnd = 1; valP = 64'd4; valC = 64'd8; valM = 64'd0;

    #10 icode = 4'd8; Cnd = 0; valP = 64'd1; valC = 64'd2; valM = 64'd3;

    #10 icode = 4'd9; Cnd = 1; valP = 64'd3; valC = 64'd6; valM = 64'd9;

    #10 icode = 4'd3; Cnd = 0; valP = 64'd10; valC = 64'd20; valM = 64'd30;

    #10 icode = 4'd5; Cnd = 0; valP = 64'd5; valC = 64'd10; valM = 64'd15;
    #5 $finish;
end
endmodule