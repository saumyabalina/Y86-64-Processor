module fetch(
input clk,
input [63:0]PC,
output reg[3:0]icode,
output reg[3:0]ifun,
output reg[3:0]rA,
output reg[3:0]rB,
output reg[63:0]valP,
output reg[63:0]valC,
output reg mem_error,
output reg i_error,
output reg halt
);

reg [7:0]mem[0:1023];
reg [0:79]inst;
// 4 bits -> icode inst[0:3]
// 4 bits -> ifun inst[4:7]
// 4 bits -> rA inst[8:11]
// 4 bits -> rB inst[12:15]
// 64 bits -> Constant Value[16:79]

initial begin

// FILE INPUT
$readmemb("1.txt",mem);

// Testbench

// //Computing the Fibonacci sequence

// //movq $18, %rcx
// mem[0] = 8'b00110000; // 3 0
// mem[1] = 8'b11110001; // F %rcx -> 15 1
// mem[2] = 8'b00010010;
// mem[3] = 8'b00000000;
// mem[4] = 8'b00000000;
// mem[5] = 8'b00000000;
// mem[6] = 8'b00000000;
// mem[7] = 8'b00000000;
// mem[8] = 8'b00000000;
// mem[9] = 8'b00000000; // V -> 18

// //movq $8, %r8
// mem[10] = 8'b00110000; // 3 0
// mem[11] = 8'b11111000; // F %r8 -> 15 8
// mem[12] = 8'b00001000;
// mem[13] = 8'b00000000;
// mem[14] = 8'b00000000;
// mem[15] = 8'b00000000;
// mem[16] = 8'b00000000;
// mem[17] = 8'b00000000;
// mem[18] = 8'b00000000;
// mem[19] = 8'b00000000; // V -> 8

// //movq $1, %r9
// mem[20] = 8'b00110000; // 3 0
// mem[21] = 8'b11111001; // F %r9 -> 15 9
// mem[22] = 8'b00000001;
// mem[23] = 8'b00000000;
// mem[24] = 8'b00000000;
// mem[25] = 8'b00000000;
// mem[26] = 8'b00000000;
// mem[27] = 8'b00000000;
// mem[28] = 8'b00000000;
// mem[29] = 8'b00000000; // V -> 1

// //movq (%rbx), %rax
// mem[30] = 8'b01010000; // 5 0
// mem[31] = 8'b00000011; // %rax %rbx -> 0 3
// mem[32] = 8'b00010000;
// mem[33] = 8'b00000000;
// mem[34] = 8'b00000000;
// mem[35] = 8'b00000000;
// mem[36] = 8'b00000000;
// mem[37] = 8'b00000000;
// mem[38] = 8'b00000000;
// mem[39] = 8'b00000000; // D = 16; -> prev

// // movq 8(%rbx), %rdx
// mem[40] = 8'b01010000; // 5 0
// mem[41] = 8'b00100011; // %rdx %rbx -> 2 3
// mem[42] = 8'b00011000;
// mem[43] = 8'b00000000;
// mem[44] = 8'b00000000;
// mem[45] = 8'b00000000;
// mem[46] = 8'b00000000;
// mem[47] = 8'b00000000;
// mem[48] = 8'b00000000;
// mem[49] = 8'b00000000; // D = 24; -> curr

// // addq %rdx, %rax
// mem[50] = 8'b01100000; // 6 0
// mem[51] = 8'b00100000; // %rdx %rax -> 2 0

// // addq %r8, %rbx
// mem[52] = 8'b01100000; // 6 0
// mem[53] = 8'b10000011; // %r8 %rbx -> 8 3

// // movq %rax, 8(%rbx)
// mem[54] = 8'b01000000; // 4 0
// mem[55] = 8'b00000011; // %rax %rbx -> 0 3
// mem[56] = 8'b00100000;
// mem[57] = 8'b00000000;
// mem[58] = 8'b00000000;
// mem[59] = 8'b00000000;
// mem[60] = 8'b00000000;
// mem[61] = 8'b00000000;
// mem[62] = 8'b00000000;
// mem[63] = 8'b00000000; // D = 32; -> next

// // decq %rcx
// mem[64] = 8'b01100001; // 6 1
// mem[65] = 8'b00011001; // %rcx %r9 -> 1 9

// // jnz (Jump if counter is not 0)
// mem[66] = 8'b01110100; // 7 4
// mem[67] = 8'b00000000;
// mem[68] = 8'b00011110;
// mem[69] = 8'b00000000;
// mem[70] = 8'b00000000;
// mem[71] = 8'b00000000;
// mem[72] = 8'b00000000;
// mem[73] = 8'b00000000;
// mem[74] = 8'b00000000; // D = 30;

// // ret
// mem[75] = 8'b10010000; // 9 0

// // Code for call and return
// // irmovq $10, %rbx
// mem[0] = 8'b00110000; // 3 0
// mem[1] = 8'b11110011; // F %rbx -> 15 3
// mem[2] = 8'b00001010;
// mem[3] = 8'b00000000;
// mem[4] = 8'b00000000;
// mem[5] = 8'b00000000;
// mem[6] = 8'b00000000;
// mem[7] = 8'b00000000;
// mem[8] = 8'b00000000;
// mem[9] = 8'b00000000; // V -> 10

// // irmovq $5, %rdx
// mem[10] = 8'b00110000; // 3 0
// mem[11] = 8'b11110010; // F %rdx -> 15 2
// mem[12] = 8'b00000101;
// mem[13] = 8'b00000000;
// mem[14] = 8'b00000000;
// mem[15] = 8'b00000000;
// mem[16] = 8'b00000000;
// mem[17] = 8'b00000000;
// mem[18] = 8'b00000000;
// mem[19] = 8'b00000000; // V -> 5

// // call func
// mem[20] = 8'b10000000; // 8 0
// mem[21] = 8'b00101000;
// mem[22] = 8'b00000000;
// mem[23] = 8'b00000000;
// mem[24] = 8'b00000000;
// mem[25] = 8'b00000000;
// mem[26] = 8'b00000000;
// mem[27] = 8'b00000000;
// mem[28] = 8'b00000000; // D = 40;

// // irmovq $25, %rcx
// mem[29] = 8'b00110000; // 3 0
// mem[30] = 8'b11110001; // F %rcx -> 15 1
// mem[31] = 8'b00011001;
// mem[32] = 8'b00000000;
// mem[33] = 8'b00000000;
// mem[34] = 8'b00000000;
// mem[35] = 8'b00000000;
// mem[36] = 8'b00000000;
// mem[37] = 8'b00000000;
// mem[38] = 8'b00000000; // V -> 25;

// // halt
// mem[39] = 8'b00000000; // 0 0

// // func : 
// // addq %rbx %rdx
// mem[40] = 8'b01100000; // 6 0
// mem[41] = 8'b00110010; // %rbx %rdx -> 3 2

// // ret
// mem[42] = 8'b10010000; // 9 0

// // Code for push,pop and nop
// //pushq %rdx
// mem[0] = 8'b10100000; // A 0
// mem[1] = 8'b00101111; // %rdx F -> 2 15

// //popq % rbx
// mem[2] = 8'b10110000; // B 0
// mem[3] = 8'b00111111; // %rbx F -> 3 15

// // nop
// mem[4] = 8'b00010000;

end


always @(posedge clk)
begin

    if(PC>=0 && PC<1024)
    begin

        mem_error = 0;
        halt = 0;
        icode = 4'hf;
        ifun = 4'hf;

        inst = {
            mem[PC],
            mem[PC+1],
            mem[PC+9],
            mem[PC+8],
            mem[PC+7],
            mem[PC+6],
            mem[PC+5],
            mem[PC+4],
            mem[PC+3],
            mem[PC+2]
            };

        icode = inst[0:3];
        ifun = inst[4:7];
        i_error = 0;
        valP = 64'hf;
        valC = 64'hf;
        rA = 4'hf;
        rB = 4'hf;


        if((icode == 4'd7) || (icode == 4'd8))
        begin
            inst = {
                mem[PC],
                mem[PC+8],
                mem[PC+7],
                mem[PC+6],
                mem[PC+5],
                mem[PC+4],
                mem[PC+3],
                mem[PC+2],
                mem[PC+1],
                mem[PC]
            };
        end


        if(icode == 4'd0 && ifun == 4'd0) // halt
        begin
            valP = PC+64'd1;
            halt = 1;
        end
        else if(icode == 4'd1 && ifun == 4'd0) // nop
        begin
            valP = PC+64'd1;
        end
        else if(icode == 4'd2 && ifun < 4'd7) // cmovXX
        begin
            rA = inst[8:11];
            rB = inst[12:15];
            valP = PC+64'd2;
        end
        else if(icode == 4'd3 && ifun == 4'd0) // irmovq
        begin
            rA = inst[8:11];
            rB = inst[12:15];
            valC = inst[16:79];
            valP = PC+64'd10;
        end
        else if(icode == 4'd4 && ifun == 4'd0) // rmmovq
        begin
            rA = inst[8:11];
            rB = inst[12:15];
            valC = inst[16:79];
            valP = PC+64'd10;
        end
        else if(icode == 4'd5 && ifun == 4'd0) // mrmovq
        begin
            rA = inst[8:11];
            rB = inst[12:15];
            valC = inst[16:79];
            valP = PC+64'd10;
        end
        else if(icode == 4'd6 && ifun < 4'd4) // OPq
        begin
            rA = inst[8:11];
            rB = inst[12:15];
            valP = PC+64'd2;
        end
        else if(icode == 4'd7 && ifun < 4'd7) // jXX
        begin
            valC = inst[8:71]; 
            valP = PC+64'd9;
        end
        else if(icode == 4'd8 && ifun == 4'd0) // call
        begin
            valC = inst[8:71];
            valP = PC+64'd9;
        end
        else if(icode == 4'd9 && ifun == 4'd0) // ret
        begin
            valP = PC+64'd1;
        end
        else if(icode == 4'd10 && ifun == 4'd0) // pushq
        begin
            rA = inst[8:11];
            rB = inst[12:15];
            valP = PC+64'd2;
        end
        else if(icode == 4'd11 && ifun == 4'd0) // popq
        begin
            rA = inst[8:11];
            rB = inst[12:15];
            valP = PC+64'd2;
        end
        else
        begin
            i_error = 1;
            halt = 1;
        end
    end
    else
    begin
        mem_error = 1;
        halt = 1;
    end
    
end
endmodule