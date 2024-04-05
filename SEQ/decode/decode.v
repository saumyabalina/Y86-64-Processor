module decode(
input clk,
input [3:0]icode,
input [3:0]rA,
input [3:0]rB,
output reg[63:0]valA,
output reg[63:0]valB
);

reg [63:0]reg_mem[0:14];

initial
begin
    reg_mem[0] = 64'd0;
    reg_mem[1] = 64'd1;
    reg_mem[2] = 64'd2;
    reg_mem[3] = 64'd3;
    reg_mem[4] = 64'd32;
    reg_mem[5] = 64'd5;
    reg_mem[6] = 64'd6;
    reg_mem[7] = 64'd7;
    reg_mem[8] = 64'd8;
    reg_mem[9] = 64'd9;
    reg_mem[10] = 64'd10;
    reg_mem[11] = 64'd11;
    reg_mem[12] = 64'd12;
    reg_mem[13] = 64'd13;
    reg_mem[14] = 64'd14;
end


always @(*)
begin
    
    // valA = 64'hf;
    // valB = 64'hf;
    
    if(clk == 1)
    begin
        if(icode == 4'd2) // cmovXX
        begin
            valA = reg_mem[rA];
            valB = 0;
        end
        else if(icode == 4'd4) // rmmovq
        begin
            valA = reg_mem[rA];
            valB = reg_mem[rB];
        end
        else if(icode == 4'd5) // mrmovq
        begin
            valB = reg_mem[rB];
        end
        else if(icode == 4'd6) // OPq
        begin
            valA = reg_mem[rA];
            valB = reg_mem[rB];
        end
        else if(icode == 4'd8) // call
        begin
            valB = reg_mem[4]; 
        end
        else if(icode == 4'd9) // ret
        begin
            valA = reg_mem[4];
            valB = reg_mem[4];
        end
        else if(icode == 4'd10) // pushq
        begin
            valA = reg_mem[rA];
            valB = reg_mem[4];
        end
        else if(icode == 4'd11) // popq
        begin
            valA = reg_mem[4];
            valB = reg_mem[4];
        end
    end

end
endmodule