module full_adder(A,B,Cin,S,Cout);

input signed A,B,Cin;
output signed S,Cout;
wire t1,t2,t3;

xor G0(t1,A,B);
xor G1(S,t1,Cin);
and G2(t2,t1,Cin);
and G3(t3,A,B);
or G4(Cout,t2,t3);

endmodule