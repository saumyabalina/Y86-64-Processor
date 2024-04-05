module pc_update(
input clk,Cnd,
input [3:0]icode,
input [63:0]valP,
input [63:0]valC,
input [63:0]valM,
output reg[63:0]PC_u
);

always @(*)
begin
    
    PC_u = 64'd0;

    PC_u = valP;
    if(icode == 4'd7) // jXX
    begin
        if(Cnd == 1)
        begin
            PC_u = valC;
        end
    end
    else if(icode == 4'd8) // call
    begin
        PC_u = valC;
    end
    else if(icode == 4'd9) // ret
    begin
        PC_u = valM;
    end
end
endmodule
