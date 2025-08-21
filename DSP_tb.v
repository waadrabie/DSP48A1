module DSP_tb();

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

reg [17:0] A,B,D,BCIN;
reg [47:0] C , PCIN;
reg [7:0]  OPMODE;
reg CARRYIN,CLK,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE ;
wire [17:0] BCOUT;
wire [35:0] M;
wire [47:0] PCOUT,P ;
wire CARRYOUTF,CARRYOUT;
reg [17:0] BCOUT_expected;
reg [35:0] M_expected;
reg [47:0] PCOUT_expected,P_expected ;
reg CARRYOUTF_expected,CARRYOUT_expected;

DSP_sync #(.A0REG(A0REG),.A1REG(A1REG),.B0REG(B0REG),.B1REG(B1REG),.CREG(CREG),.DREG(DREG),.MREG(MREG),.PREG(PREG),.CARRYINREG(CARRYINREG),.CARRYOUTREG(CARRYOUTREG)
           ,.OPMODEREG(OPMODEREG),.CARRYINSEL(CARRYINSEL) ,.B_INPUT(B_INPUT),.RSTTYPE(RSTTYPE)) DUT(A,B,D,C,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,
           RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);

initial begin
    CLK = 0;
    forever begin
      #1 CLK = ~CLK;
    end
end

initial begin
RSTA =1;
RSTB =1;
RSTM =1;
RSTP =1;
RSTC =1;
RSTD =1;
RSTCARRYIN =1;
RSTOPMODE  =1;
A = $random;
B = $random;
D = $random;
C = $random;
CARRYIN = $random;
OPMODE = $random;
BCIN  = $random;
PCIN  = $random;
BCOUT_expected = 0;
M_expected = 0;
PCOUT_expected =0;
P_expected =0 ;
CARRYOUTF_expected =0;
CARRYOUT_expected =0;
@(negedge CLK);
if((BCOUT!= 0) || (M!=0) || (PCOUT!=0) || (P!=0) || (CARRYOUT!=0) || (CARRYOUTF!=0)) begin
 $display("Error in reset functionality");
 $stop;
end
RSTA = 0;
RSTB = 0;
RSTM = 0;
RSTP = 0;
RSTC = 0;
RSTD = 0;
RSTCARRYIN = 0;
RSTOPMODE  = 0;
CEA = 1;
CEB = 1;
CEM = 1;
CEP = 1;
CEC = 1;
CED = 1;
CECARRYIN = 1;
CEOPMODE = 1;
OPMODE = 8'b11011101;
A = 20;
B = 10;
C = 350;
D = 25;
CARRYIN = $random;
BCIN  = $random;
PCIN  = $random;
BCOUT_expected = 'hf;
M_expected = 'h12c;
P_expected = 'h32;
PCOUT_expected = 'h32;
CARRYOUT_expected = 0;
CARRYOUTF_expected = 0 ;
repeat(4)@(negedge CLK);
if((BCOUT!= BCOUT_expected) || (M!=M_expected) || (PCOUT!=PCOUT_expected) || (P!=P_expected) || (CARRYOUT!=CARRYOUT_expected) || (CARRYOUTF!=CARRYOUTF_expected)) begin
 $display("Error in path 1 functionality");
 $stop;
end

OPMODE = 8'b00010000;
A = 20;
B = 10;
C = 350;
D = 25;
CARRYIN = $random;
BCIN  = $random;
PCIN  = $random;
BCOUT_expected = 'h23;
M_expected = 'h2bc;
P_expected = 0;
PCOUT_expected = 0;
CARRYOUT_expected = 0;
CARRYOUTF_expected = 0 ;
repeat(3)@(negedge CLK);
if((BCOUT!= BCOUT_expected) || (M!=M_expected) || (PCOUT!=PCOUT_expected) || (P!=P_expected) || (CARRYOUT!=CARRYOUT_expected) || (CARRYOUTF!=CARRYOUTF_expected)) begin
 $display("Error in path 2 functionality");
 $stop;
end

OPMODE = 8'b00001010;
A = 20;
B = 10;
C = 350;
D = 25;
CARRYIN = $random;
BCIN  = $random;
PCIN  = $random;
BCOUT_expected = 'ha;
M_expected = 'hc8;
P_expected = P_expected;
PCOUT_expected = PCOUT_expected;
CARRYOUT_expected = CARRYOUT_expected;
CARRYOUTF_expected = CARRYOUTF_expected ;
repeat(3)@(negedge CLK);
if((BCOUT!= BCOUT_expected) || (M!=M_expected) || (PCOUT!=PCOUT_expected) || (P!=P_expected) || (CARRYOUT!=CARRYOUT_expected) || (CARRYOUTF!=CARRYOUTF_expected)) begin
 $display("Error in path 3 functionality");
 $stop;
end

OPMODE =8'b10100111;
A = 5;
B = 6;
C = 350;
D = 25;
CARRYIN = $random;
BCIN  = $random;
PCIN  = 3000;
BCOUT_expected = 'h6;
M_expected = 'h1e;
P_expected = 'hfe6fffec0bb1;
PCOUT_expected = 'hfe6fffec0bb1;
CARRYOUT_expected = 1;
CARRYOUTF_expected = 1;
repeat(3)@(negedge CLK);
if((BCOUT!= BCOUT_expected) || (M!=M_expected) || (PCOUT!=PCOUT_expected) || (P!=P_expected) || (CARRYOUT!=CARRYOUT_expected) || (CARRYOUTF!=CARRYOUTF_expected)) begin
 $display("Error in path 4 functionality");
 $stop;
end
$stop;
end

initial begin
$monitor("BCOUT=%h, M=%h, PCOUT=%h,  P=%h, CARYYOUT=%h, CARRYOUTF=%h,BCOUT_expected=%h, M_expected=%h, PCOUT_expected=%h,  P_expected=%h, CARYYOUT_expected=%h,CARRYOUTF_expected=%h"
         ,BCOUT,M,PCOUT,P,CARRYOUT,CARRYOUTF,BCOUT_expected,M_expected,PCOUT_expected,P_expected,CARRYOUT_expected,CARRYOUTF_expected);
end
endmodule



