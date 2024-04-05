module pipe_control_logic(
    input [3:0]D_icode,
    input [3:0]E_icode,
    input [3:0]M_icode,
    input [1:0]m_stat,
    input [1:0]W_stat,
    input [3:0]d_srcA,
    input [3:0]d_srcB,
    input [3:0]E_dstM,
    input e_Cnd,
    output reg F_stall,
    output reg D_stall,
    output reg D_bubble,
    output reg E_bubble,
    output reg M_bubble,
    output reg W_stall,
    output reg set_cc
);

always@(*) begin

    F_stall = 0;
    D_stall = 0;
    D_bubble = 0;
    E_bubble = 0;
    M_bubble = 0;
    W_stall = 0;
    set_cc = 0;

    if(((E_icode == 4'd5 || E_icode == 4'd11) && (E_dstM == d_srcA || E_dstM == d_srcB)) || (D_icode == 4'd9 || E_icode == 4'd9 || M_icode == 4'd9))
    begin
        F_stall = 1;
    end
    if((E_icode == 4'd5 || E_icode == 4'd11) && (E_dstM == d_srcA || E_dstM == d_srcB))
    begin
        D_stall = 1;
    end
    if((E_icode == 4'd7 && e_Cnd == 0) || (!((E_icode == 4'd5 || E_icode == 4'd11) && (E_dstM == d_srcA || E_dstM == d_srcB)) && (D_icode == 4'd9 || E_icode == 4'd9 || M_icode == 4'd9)))
    begin
        D_bubble = 1;
    end
    if((E_icode == 4'd7 && e_Cnd == 0) || ((E_icode == 4'd5 || E_icode == 4'd11) && (E_dstM == d_srcA || E_dstM == d_srcB)))
    begin
        E_bubble = 1;
    end
    if(m_stat == 2'd1 || m_stat == 2'd2 || m_stat == 2'd3 || W_stat == 2'd1 || W_stat == 2'd2 || W_stat == 2'd3)
    begin
        M_bubble = 1;
    end
    if(W_stat == 2'd1 || W_stat == 2'd2 || W_stat == 2'd3)
    begin
        W_stall = 1;
    end
    if(E_icode == 4'd6 && !(m_stat == 2'd1 || m_stat == 2'd2 || m_stat == 2'd3) || !(W_stat == 2'd1 || W_stat == 2'd2 || W_stat == 2'd3))
    begin
        set_cc = 1;
    end
end

endmodule