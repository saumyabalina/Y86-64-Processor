`include "./ALU/adder.v"
`include "./ALU/subtractor.v"
`include "./ALU/and64.v"
`include "./ALU/xor64.v"
`include "./ALU/full_adder.v"

module alu(control, A , B, result, overflow);

input [1:0]control;
input signed[63:0]A;
input signed[63:0]B;
output reg signed[63:0]result;
output reg overflow;

wire signed[63:0]add_result;
wire signed[63:0]sub_result;
wire signed[63:0]and_result;
wire signed[63:0]xor_result;
wire overflow1, overflow2;

// wire [63:0]final_result;
// wire final_overflow;

adder G1(A, B, add_result, overflow1);
subtractor G2(A, B, sub_result, overflow2);
and64 G3(A, B, and_result);
xor64 G4(A, B, xor_result);

always @(*)
begin
    if(control==2'd0)
    begin
        result <= add_result;
        overflow <= overflow1;
    end
    else if(control==2'd1)
    begin
        result <= sub_result;
        overflow <= overflow2;
    end
    else if(control==2'd2)
    begin
        result <= and_result;
        overflow <= 1'd0;
    end
    else if(control==2'd3)
    begin
        result <= xor_result;
        overflow <= 1'd0;
    end
end

endmodule