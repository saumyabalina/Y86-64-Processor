module memory(
input clk,
input [3:0]icode,
input [63:0]valA,
input [63:0]valE,
input [63:0]valP,
output reg[63:0]valM,
output reg dmem_error
);

reg [63:0]data_mem[0:1023];
reg read,write;
reg [63:0]address;
reg [63:0]data_w;

initial
begin
    data_mem[0] = 64'd0;
    data_mem[1] = 64'd1;
    data_mem[2] = 64'd2;
    data_mem[3] = 64'd3;
    data_mem[4] = 64'd4;
    data_mem[5] = 64'd5;
    data_mem[6] = 64'd6;
    data_mem[7] = 64'd7;
    data_mem[8] = 64'd8;
    data_mem[9] = 64'd9;
    data_mem[10] = 64'd10;
end

always @(negedge clk)
begin
    
    address = 64'hf;
    data_w = 64'hf;
    read = 0; write = 0;
    valM = 64'hf;
    dmem_error = 0;

    if(icode == 4'd4) // rmmovq
    begin
        data_w = valA;
        address = valE;
        write = 1;
    end
    else if(icode == 4'd5) // mrmovq
    begin
        address = valE;
        read = 1;
    end
    else if(icode == 4'd8) // call
    begin
        data_w = valP;
        address = valE;
        write = 1;
    end
    else if(icode == 4'd9) // ret
    begin
        address = valA;
        read = 1;
    end
    else if(icode == 4'd10) // pushq
    begin
        data_w = valA;
        address = valE;
        write = 1;
    end
    else if(icode == 4'd11) // popq
    begin
        address = valA;
        read = 1;
    end

        // $display($time ," address=%d, data_w=%d, valA=%d, valE=%d",address, data_w,valA,valE);

    if(address>=0 && address<1024)
    begin
        if(read == 1 && write == 0)
        begin
            valM = data_mem[address];
        end
        else if(read == 0 && write == 1)
        begin
            data_mem[address] = data_w;
        end
        else if(read == 1 && write == 1)
        begin
            dmem_error = 1;
        end
    end
    else
    begin
        dmem_error = 1;
    end

        // $display($time, "dmem_error=%d", dmem_error);

end
endmodule