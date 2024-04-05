`include "./ALU/alu.v"

module execute(
    input clk,
    input [3:0]icode,
    input [3:0]ifun,
    input [63:0]valA,
    input [63:0]valB,
    input [63:0]valC,
    output reg[63:0]valE,
    output reg Cnd
);

reg [1:0]control;
reg signed [63:0]A;
reg signed [63:0]B;
wire signed [63:0]result;
wire overflow;

alu call(.control(control), .A(A), .B(B), .result(result), .overflow(overflow));

reg [2:0]CC; // Condition Code [zf, sf, of]
reg zf; // Zero flag
reg sf; // Sign flag
reg of; // Overflow flag

initial begin
    zf = 0;
    sf = 0;
    of = 0;
    // valE = 64'd0;
    Cnd = 1'd0;
    CC = 3'd0;
end

always @(*) begin
    if(icode == 4'd6 && clk == 1) // OPq
    begin
        zf = (result == 64'd0);
        sf = (result < 64'd0);
        // sf = (result[63] == 1);
        of = ((A < 64'd0 == B < 64'd0) && (result < 64'd0 != A < 64'd0));
        // of = (((A[63] == 1) == (B[63] == 1)) && ((result[63] == 1) ~= (A[63] == 1)));
        // of = overflow;
    end
end

always @(*) begin
    if(clk == 1)
    begin
        Cnd = 0;
        if(icode == 4'd2) // cmovXX
        begin
            if(ifun == 4'd0) // rrmovq
            begin
                Cnd = 1;
            end
            else if(ifun == 4'd1) // cmovle
            begin 
                // (sf^of)||zf
                if((sf^of)|zf) begin
                    Cnd = 1;
                end
            end
            else if(ifun == 4'd2) // cmovl
            begin
                // (sf^of)
                if((sf^of)) begin
                    Cnd = 1;
                end
            end
            else if(ifun == 4'd3) // cmove
            begin
                // zf
                if(zf) begin
                    Cnd = 1;
                end
            end
            else if(ifun == 4'd4) // cmovne
            begin
                // !zf
                if(~zf) begin
                    Cnd = 1;
                end
            end
            else if(ifun == 4'd5) // cmovge
            begin
                // !(sf^of)
                if(~(sf^of)) begin
                    Cnd = 1;
                end
            end
            else if(ifun == 4'd6) // cmovg
            begin
                // !(sf^of) && !zf
                if((~(sf^of)) & ~zf) begin
                    Cnd = 1;
                end
            end
            control = 2'd0;
            A = valB;
            B = valA;
            valE = result;
        end
        else if(icode == 4'd3) // irmovq
        begin
            control = 2'd0;
            A = 64'd0;
            B = valC;
            valE = result;
            // valE = 64'd0 + valC;
        end
        else if(icode == 4'd4) // rmmovq
        begin
            control = 2'd0;
            A = valB;
            B = valC;
            valE = result;
            // valE = valB + valC;
        end
        else if(icode == 4'd5) // mrmovq
        begin
            control = 2'd0;
            A = valB;
            B = valC;
            valE = result;
            // valE = valB + valC;
        end
        else if(icode == 4'd6) // OPq
        begin
            A = valA;
            B = valB;
            if(ifun == 4'd0) // add
            begin
                control = 2'd0;
            end
            else if(ifun == 4'd1) // sub
            begin
                A = valB;
                B = valA;
                control = 2'd1;
            end
            else if(ifun == 4'd2) // and
            begin
                control = 2'd2;
            end
            else if(ifun == 4'd3) // xor
            begin
                control = 2'd3;
            end
            valE = result;
        end
        else if(icode == 4'd7) // jxx
        begin
            if(ifun == 4'd0) // jmp
            begin
                Cnd = 1;
            end
            else if(ifun == 4'd1) // jle
            begin 
                // (sf^of)||zf
                if((sf^of)|zf) begin
                    Cnd = 1;
                end
            end
            else if(ifun == 4'd2) // jl
            begin
                // (sf^of)
                if((sf^of)) begin
                    Cnd = 1;
                end
            end
            else if(ifun == 4'd3) //je
            begin
                // zf
                if(zf) begin
                    Cnd = 1;
                end
            end
            else if(ifun == 4'd4) //jne
            begin
                // !zf
                if(!zf) begin
                    Cnd = 1;
                end
            end
            else if(ifun == 4'd5) //jge
            begin
                // !(sf^of)
                if(!(sf^of)) begin
                    Cnd = 1;
                end
            end
            else if(ifun == 4'd6) //jg
            begin
                // !(sf^of) && !zf
                if((!(sf^of)) && !zf) begin
                    Cnd = 1;
                end
            end
        end
        else if(icode == 4'd8) // call
        begin
            control = 2'd1;
            A = valB;
            B = 64'd8;
            valE = result;
        end
        else if(icode == 4'd9) // ret
        begin
            control = 2'd0;
            A = valB;
            B = 64'd8;
            valE = result;
        end
        else if(icode == 4'd10) // pushq
        begin
            control = 2'd1;
            A = valB;
            B = 64'd8;
            valE = result;
        end
        else if(icode == 4'd11) // popq
        begin
            control = 2'd0;
            A = valB;
            B = 64'd8;
            valE = result;
        end
    end
end

endmodule