`include "alu.v"

module testbench;

    reg [1:0]control;
    reg signed[63:0]A, B;
    wire signed[63:0]result;
    wire overflow;

    alu call(.control(control), .A(A), .B(B), .result(result), .overflow(overflow));
    
    initial
    begin
        $dumpfile("alu.vcd");
        $dumpvars(0,testbench);
    end

    initial 
    begin
        $monitor($time," Control %d: A=%d, B=%d, Result=%d, Overflow=%d",control,A,B,result,overflow);
    end

    initial
    begin
        #5 control=2'd0; A=64'd0; B=64'd1;
        #5 control=2'd1; A=64'd4; B=64'd4;
        #5 control=2'd2; A=64'd10; B=64'd7;
        #5 control=2'd3; A=64'd15; B=64'd10;
        #5 $finish;
    end

endmodule