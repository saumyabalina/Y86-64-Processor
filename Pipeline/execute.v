`include "./ALU/alu.v"

module execute(
    input clk,
    input [1:0]E_stat,
    input [3:0]E_icode,
    input [3:0]E_ifun,
    input signed[63:0]E_valC,
    input signed[63:0]E_valA,
    input signed[63:0]E_valB,
    input [3:0]E_dstE,
    input [3:0]E_dstM,
    input set_cc,
    input M_bubble,
    output reg[1:0]M_stat,
    output reg[3:0]M_icode,
    output reg M_Cnd,
    output reg[63:0]M_valE,
    output reg[63:0]M_valA,
    output reg[63:0]e_valE,
    output reg[3:0]M_dstE,
    output reg[3:0]M_dstM, 
    output reg[3:0]e_dstE,
    output reg e_Cnd,
    output reg c_z,
    output reg c_s,
    output reg c_o
);

reg [1:0]control;
reg signed [63:0]A;
reg signed [63:0]B;
wire signed [63:0]result;
wire overflow;

alu call(.control(control), .A(A), .B(B), .result(result), .overflow(overflow));

reg zf; // Zero flag
reg sf; // Sign flag
reg of; // Overflow flag

reg [3:0]icode;
reg [3:0]ifun;
reg signed [63:0]valA;
reg signed [63:0]valB;
reg [63:0]valC;
reg signed [63:0]valE;
reg Cnd;

initial begin
    zf = 0;
    sf = 0;
    of = 0;
    Cnd = 1'd0;
    valE = 64'd0;
end

always @(*) begin
    if(icode == 4'd6 && clk == 1 && set_cc == 1) // OPq
    begin
        zf = (result == 64'd0);
        sf = (result < 64'd0);
        // sf = (result[63] == 1);
        of = ((A < 64'd0 == B < 64'd0) && (result < 64'd0 != A < 64'd0));
        // of = (((A[63] == 1) == (B[63] == 1)) && ((result[63] == 1) ~= (A[63] == 1)));
        // of = overflow;
    end
    // $display("icode=%d,ifun=%d,zf=%d, sf=%d, of=%d",icode,ifun,zf,sf,of);
    c_z = zf; c_s = sf; c_o = of;
    
end

always @(*) begin
    e_dstE = E_dstE;
    icode = E_icode;
    ifun = E_ifun;
    valA = E_valA;
    valB = E_valB;
    valC = E_valC;
    e_valE = valE;
    e_Cnd = Cnd;
end

always @(*) begin
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
        // control = 2'd0;
        // A = valB;
        // B = valA;
        // valE = result;
        if(e_Cnd == 1)
        begin
            e_dstE = E_dstE;
        end
        else
        begin
            e_dstE = 4'd15;
        end
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
        if(e_Cnd == 1)
        begin
            e_dstE = E_dstE;
        end
        else
        begin
            e_dstE = 4'd15;
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

always @(posedge clk)
begin
    if(M_bubble == 1) begin
        M_stat <= 2'd0;
        M_icode <= 4'd1; // nop
        M_Cnd <= 1'd0;
        M_valE <= 64'd0;
        M_valA <= 64'd0;
        M_dstE <= 4'd15;
        M_dstM <= 4'd15;
    end
    else begin
        M_stat <= E_stat;
        M_icode <= E_icode;
        M_Cnd <= e_Cnd;
        M_valE <= e_valE;
        M_valA <= E_valA;
        M_dstE <= e_dstE;
        M_dstM <= E_dstM;
    end
end

endmodule