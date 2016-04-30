// ============================================================================
// Copyright (c) 2012 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//
//
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
//
// Major Functions:	DE2_115_Default
//
// ============================================================================
//
// Revision History :
// ============================================================================
//   Ver  :| Author              :| Mod. Date :| Changes Made:
//   V1.1 :| HdHuang             :| 05/12/10  :| Initial Revision
//   V2.0 :| Eko       				:| 05/23/12  :| version 11.1
// ============================================================================
//  Modified by Alan Ehret to output grayscale video
module DE2_115_TV
	(
		//////// CLOCK //////////
		CLOCK_50,
//		CLOCK2_50,
//		CLOCK3_50,
//		ENETCLK_25,

		//////// LED //////////
		LEDG,
//		LEDR,

		//////// KEY //////////
		KEY,

		//////// I2C for Audio and Tv-Decode //////////
		I2C_SCLK,
		I2C_SDAT,

		//////// TV Decoder //////////
		TD_CLK27,
		TD_DATA,
		TD_HS,
		TD_RESET_N,
		TD_VS,

	);

//===========================================================================
// PARAMETER declarations
//===========================================================================
parameter LINEWIDTH = 640;

//===========================================================================
// PORT declarations
//===========================================================================
 
//////////// CLOCK //////////
input		          		CLOCK_50;

//////////// LED //////////
output		     [8:0]		LEDG;
//output		    [17:0]		LEDR;

//////////// KEY //////////
input		     [3:0]		KEY;

//////////// I2C for Audio and Tv-Decode //////////
output		          		I2C_SCLK;
inout		          		I2C_SDAT;

//////////// TV Decoder 1 //////////
input		          		TD_CLK27;
input		     [7:0]		TD_DATA;
input		          		TD_HS;
output		          		TD_RESET_N;
input		          		TD_VS;


///////////////////////////////////////////////////////////////////
//=============================================================================
// REG/WIRE declarations
//=============================================================================

wire	CPU_CLK;
wire	CPU_RESET;
wire	CLK_18_4;
wire	CLK_25;

//	For ITU-R 656 Decoder
wire	[15:0]	YCbCr;
wire	[9:0]	TV_X;
wire			TV_DVAL;

//	For Delay Timer
wire			TD_Stable;
wire			DLY0;
wire			DLY1;
wire			DLY2;

//	For Down Sample
wire	[3:0]	Remain;
wire	[9:0]	Quotient;

wire			mDVAL;

wire            NTSC;
wire            PAL;
//=============================================================================
// Structural coding
//=============================================================================
 //////// Alan's Stuff ///////
assign LEDG	=	{1'b1, YCbCr[15:8]};
assign 

//	Turn On TV Decoder
assign	TD_RESET_N	=	1'b1;
assign addr_a = TV_X + ( TV_Y * LINEWIDTH); 
assign wren_a = TV_DVAL;

assign data_b = 8'hff;

//  Frame buffer 
frame_buffer fb(
    .address_a(addr_a),
    .address_b(addr_b),
    .data_a(YCbCr[15:8]),
    .data_b(data_b),
    .inclock(),
    .outclock(),
    .wren_a(),
    .wren_b(),
    .q_a(),
    .q_b() 
    );
//	TV Decoder Stable Check
TD_Detect			u2	(	.oTD_Stable(TD_Stable),
							.oNTSC(NTSC),
							.oPAL(PAL),
							.iTD_VS(TD_VS),
							.iTD_HS(TD_HS),
							.iRST_N(KEY[0])	);

//	Reset Delay Timer
Reset_Delay			u3	(	.iCLK(CLOCK_50),
							.iRST(TD_Stable),
							.oRST_0(DLY0),
							.oRST_1(DLY1),
							.oRST_2(DLY2));

//	ITU-R 656 to YUV 4:2:2
ITU_656_Decoder		u4	(	//	TV Decoder Input
							.iTD_DATA(TD_DATA),
							//	Position Output
							.oTV_X(TV_X),
              .oTV_Y(TV_Y),
							//	YUV 4:2:2 Output
							.oYCbCr(YCbCr),
							.oDVAL(TV_DVAL),
							//	Control Signals
							.iSwap_CbCr(Quotient[0]),
							.iSkip(Remain==4'h0),
							.iRST_N(DLY1),
							.iCLK_27(TD_CLK27)	);

//	For Down Sample 720 to 640
DIV 				u5	(	.aclr(!DLY0),	
							.clock(TD_CLK27),
							.denom(4'h9),
							.numer(TV_X),
							.quotient(Quotient),
							.remain(Remain));


//	Audio CODEC and video decoder setting
I2C_AV_Config 	u1	(	//	Host Side
						.iCLK(CLOCK_50),
						.iRST_N(KEY[0]),
						//	I2C Side
						.I2C_SCLK(I2C_SCLK),
						.I2C_SDAT(I2C_SDAT)	);	

endmodule

