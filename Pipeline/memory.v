module memory(
input clk,
input [3:0]M_icode,
input signed[63:0]M_valA,
input signed[63:0]M_valE,
input [3:0]M_dstE,
input [3:0]M_dstM,
input [1:0]M_stat,
input W_stall,
output reg [3:0]W_icode,
output reg [63:0]W_valE,
output reg [63:0]W_valM,
output reg [3:0]W_dstE,
output reg [3:0]W_dstM,
output reg [1:0]W_stat,
output reg [63:0]m_valM,
output reg [1:0]m_stat
);

reg [63:0]data_mem[0:1023];
reg read,write;
reg [63:0]data_in;
reg [63:0]address;
reg dmem_error;

initial
begin
    address = 64'd0;
    m_valM = 64'd0;
    data_in = 64'd0;
    dmem_error = 0;
end

always @(*)
begin
    
    read = 0; write = 0;

    if(M_icode == 4'd4) // rmmovq
    begin
        data_in = M_valA;
        address = M_valE;
        write = 1;
    end
    else if(M_icode == 4'd5) // mrmovq
    begin
        address = M_valE;
        read = 1;
    end
    else if(M_icode == 4'd8) // call
    begin
        data_in = M_valA;
        address = M_valE;
        write = 1;
    end
    else if(M_icode == 4'd9) // ret
    begin
        address = M_valA;
        read = 1;
    end
    else if(M_icode == 4'd10) // pushq
    begin
        data_in = M_valA;
        address = M_valE;
        write = 1;
    end
    else if(M_icode == 4'd11) // popq
    begin
        address = M_valA;
        read = 1;
    end

    // $display("address = %d",address);
    // $display("read %d, write = %d",read,write);
    if(address>=0 && address<1024)
    begin
        if(read == 1 && write == 0)
        begin
            m_valM = data_mem[address];
            // $display("m_valM = %d",m_valM);
        end
        else if(write == 1 && read == 0)
        begin
            data_mem[address] = data_in;
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

    if(dmem_error == 1 && M_stat == 0)
    begin
        m_stat = 2'd2;
    end
    else
    begin
        m_stat = M_stat;
    end
end

always @(posedge clk)
begin
    
    if(W_stall == 0)
    begin
        
        W_icode <= M_icode;
        W_valE <= M_valE;
        W_valM <= m_valM;
        W_dstE <= M_dstE;
        W_dstM <= M_dstM;
        W_stat <= m_stat;
    end

end
endmodule