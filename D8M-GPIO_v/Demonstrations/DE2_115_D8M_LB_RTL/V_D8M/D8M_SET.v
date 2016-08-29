module D8M_SET (
   input       CLOCK_50,	
	input       RESET_SYS_N ,	
	output	   oRESET_N,
	output	   SCLK ,
	inout 	   SDATA,
	
	input [11:0]CCD_DATA  ,
	input       CCD_FVAL  ,
	input	      CCD_LVAL	 ,
	input	      CCD_PIXCLK,
	
   input       VGA_CLK ,
   input       VGA_HS  ,
   input       VGA_VS  ,
   input       READ_Request	, 
	input  [12:0]H_Cont ,
	input  [12:0]V_Cont , 	

	output[11:0]sCCD_R,
	output[11:0]sCCD_G,
	output[11:0]sCCD_B,
	output		sCCD_DVAL,
	output		CCD_DVAL, 
	output		CCD_LDVAL,
	output		CCD_FDVAL
);

//=============================================================================
// REG/WIRE declarations
//=============================================================================
wire 		   mCCD_DVAL;
wire[11:0]  mCCD_DATA;
wire			CCD_MCLK ;	
wire	[31:0]Frame_Cont;
wire			DLY_RST_0 ;
wire			DLY_RST_1 ;
wire			DLY_RST_2 ;
wire [15:0] X_Cont ; 
wire [15:0] Y_Cont ; 

//-------CCD CA--- 
CCD_Capture			u3	(	
         .oDATA      ( mCCD_DATA ),
			.oDVAL      ( CCD_DVAL ),
			.oX_Cont    ( X_Cont ),
			.oY_Cont    ( Y_Cont ),
			.oFrame_Cont( Frame_Cont ),
			.iDATA      ( CCD_DATA ),
			.iFVAL      ( CCD_FVAL ),
			.iLVAL      ( CCD_LVAL ),
			.iSTART     ( 1 ),
			.iEND       ( 0 ),
			.iCLK       ( CCD_PIXCLK ),
			.iRST       ( RESET_SYS_N )
);
						
//--READ Counter --- 	
wire [15:0] READ_Cont ; 
RAM_READ_COUNTER   cnt(
	.CLK (VGA_CLK     ),
	.CLR (VGA_HS      ),
	.EN  (READ_Request),
	.CNT (READ_Cont)
);

//--RAW TO RGB --- 							
RAW2RGB_J				u4	(	
							.RST          ( RESET_SYS_N ),// DLY_RST_1 ),
                     .CCD_PIXCLK   ( CCD_PIXCLK),
							.mCCD_DATA    ( mCCD_DATA ),
							.CCD_FVAL     ( CCD_FVAL ),
							.CCD_LVAL     ( CCD_LVAL ),
							.X_Cont       ( X_Cont ),
							.Y_Cont       ( Y_Cont ),
							//-----------------------------------
                     .VGA_CLK      ( VGA_CLK),
                     .READ_Request ( READ_Request ),
                     .VGA_VS       ( VGA_VS ),	
	                  .READ_Cont    ( READ_Cont ) , 
	                  .V_Cont       ( V_Cont ), 
	                  			
							.oRed         ( sCCD_R ),
							.oGreen       ( sCCD_G ),
							.oBlue        ( sCCD_B ),
							.oDVAL        ( sCCD_DVAL )
						);
						

endmodule

