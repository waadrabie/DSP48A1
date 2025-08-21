module gray_mux_async(in,out,clk_en,rst,clk);

parameter WIDTH = 18;
parameter SEL = 1;
input clk,rst,clk_en;
input      [WIDTH-1 :0] in;
output  [WIDTH-1 :0] out;
 reg       [WIDTH-1 :0] in_reg;

always @(posedge clk or posedge rst) begin
    if(rst)
     in_reg <= 0;
    else if(clk_en)
     in_reg <= in; 
     else
     in_reg <= 0;  
end

assign out = (SEL == 1)?in_reg : in;
endmodule










