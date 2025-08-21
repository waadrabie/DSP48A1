module DSP_async(A,B,D,C,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,
                BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);

parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG  = 1;
parameter DREG  = 1;
parameter MREG  = 1;
parameter PREG  = 1;
parameter CARRYINREG  = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG   = 1;
parameter CARRYINSEL  = "OPMODE5"; //OPMODE5 OR CARRYIN
parameter B_INPUT     = "DIRECT";  //DIRECT OR CASCADE
parameter RSTTYPE     = "SYNC";    //SYNC OR ASYNC

input [17:0] A,B,D,BCIN;
input [47:0] C , PCIN;
input [7:0]  OPMODE;
input CARRYIN,CLK,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE ;
output  [17:0] BCOUT;
output  [35:0] M;
output  [47:0] PCOUT;
output [47:0] P ;
output  CARRYOUTF;
output CARRYOUT;
wire [17:0] D_mux,B0_mux,A0_mux,A1_mux,B1_mux,B_input;
wire [47:0] C_mux;
wire [35:0] Multiplier_out,M_mux;
wire [7:0]  OPMODE_mux;
wire        CARRYIN_mux1,CIN;
reg [17:0] Pre_Adder_out, Pre_Adder_mux;
reg [47:0] Z_mux, X_mux, Post_Adder_out;
reg COUT;

gray_mux_async #(.WIDTH(18),.SEL(DREG))D_REG(D,D_mux,CED,RSTD,CLK);
gray_mux_async #(.WIDTH(18),.SEL(B0REG))B0_REG(B_input,B0_mux,CEB,RSTB,CLK);
gray_mux_async #(.WIDTH(18),.SEL(A0REG))A0_REG(A,A0_mux,CEA,RSTA,CLK);
gray_mux_async #(.WIDTH(48),.SEL(CREG))C_REG(C,C_mux,CEC,RSTC,CLK);
gray_mux_async #(.WIDTH(18),.SEL(B1REG))B1_REG(Pre_Adder_mux,B1_mux,CEB,RSTB,CLK);
gray_mux_async #(.WIDTH(18),.SEL(A1REG))A1_REG(A0_mux,A1_mux,CEA,RSTA,CLK);
gray_mux_async #(.WIDTH(36),.SEL(MREG))M_REG(Multiplier_out,M_mux,CEM,RSTM,CLK);
gray_mux_async #(.WIDTH(1),.SEL(CARRYINREG))CYI_REG(CARRYIN_mux1,CIN,CECARRYIN,RSTCARRYIN,CLK);
gray_mux_async #(.WIDTH(1),.SEL(CARRYOUTREG))CYO_REG(COUT,CARRYOUT,CECARRYIN,RSTCARRYIN,CLK);
gray_mux_async #(.WIDTH(48),.SEL(PREG))P_REG(Post_Adder_out,P,CEP,RSTP,CLK);
gray_mux_async #(.WIDTH(8),.SEL(OPMODEREG))OPMODE_REG(OPMODE,OPMODE_mux,CEOPMODE,RSTOPMODE,CLK);

assign B_input = (B_INPUT =="DIRECT")?B : (B_INPUT =="CASCADE")?BCIN : 0;
assign CARRYIN_mux1 = (CARRYINSEL =="OPMODE5")?OPMODE[5] : (CARRYINSEL =="CARRYIN")?CARRYIN: 0;
assign Multiplier_out = B1_mux * A1_mux;
assign CARRYOUTF = CARRYOUT;
assign PCOUT = P;
assign BCOUT = B1_mux;
assign M = M_mux;

always@(*) begin
case (OPMODE_mux[6])
 0 : Pre_Adder_out = D_mux + B0_mux;
 1 : Pre_Adder_out = D_mux - B0_mux;
 default : Pre_Adder_out = 0;
endcase
end

always@(*) begin
case (OPMODE_mux[4])
 0 : Pre_Adder_mux = B0_mux;
 1 : Pre_Adder_mux = Pre_Adder_out;
 default : Pre_Adder_mux = 0;
    
endcase
end

always@(*) begin
case (OPMODE_mux[1:0])
 0 : X_mux = 0;
 1 : X_mux = M;
 2 : X_mux = P;
 3 : X_mux = {D_mux[11:0],A1_mux[17:0],B1_mux[17:0]};
 default: X_mux =0;
endcase
end

always@(*) begin
case (OPMODE_mux[3:2])
 0 : Z_mux = 0;
 1 : Z_mux = PCIN;
 2 : Z_mux = P;
 3 : Z_mux = C_mux;
 default : Z_mux =0;
endcase
end

always@(*) begin
case (OPMODE_mux[7])
 0 : {COUT,Post_Adder_out} = Z_mux + X_mux + CIN;
 1 :  {COUT,Post_Adder_out} = Z_mux -(X_mux + CIN);
 default : {COUT,Post_Adder_out} = 0;
endcase
end
endmodule

