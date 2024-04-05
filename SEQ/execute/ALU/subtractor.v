// `include "full_adder.v"

module subtractor(A,B,Diff,Carry);

input signed [63:0]A;
input signed [63:0]B;
output signed [63:0]Diff;
output Carry;
wire [63:0]Cout;
wire signed [63:0]b;
wire x = 1'b1;
wire Cin = 1'b1;

xor G0(b[0],B[0],x);
full_adder f0(A[0],b[0],Cin,Diff[0],Cout[0]);
genvar i;
generate
    for(i=1; i<64; i=i+1)
    begin
        xor G(b[i],B[i],x);
        full_adder f(A[i],b[i],Cout[i-1],Diff[i],Cout[i]);
    end
endgenerate
xor G1(Carry,Cout[63],x);
endmodule