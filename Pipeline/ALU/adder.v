// `include "full_adder.v"

module adder(A,B,Sum,Carry);

input signed [63:0]A;
input signed [63:0]B;
output signed [63:0]Sum;
output Carry;
wire [63:0]Cout;
wire Cin = 1'b0;

full_adder f0(A[0],B[0],Cin,Sum[0],Cout[0]);
genvar i;
generate
    for(i=1; i<64; i=i+1)
    begin
        full_adder f(A[i],B[i],Cout[i-1],Sum[i],Cout[i]);
    end
endgenerate

// xor G1(Carry,Cout[63]);
assign Carry = Cout[63];

endmodule