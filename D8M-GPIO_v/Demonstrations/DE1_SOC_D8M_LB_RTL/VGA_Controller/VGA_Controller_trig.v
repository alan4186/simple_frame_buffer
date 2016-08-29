
module VGA_Controller_trig(	//	Host Side
        input           iHS, 
        input           iVS,
        input		 [9:0]iRed,
        input		 [9:0]iGreen,
        input		 [9:0]iBlue,
        output	reg 		oRequest,
        output		[9:0]	oVGA_R,
        output		[9:0]	oVGA_G,
        output		[9:0]	oVGA_B,
        output				oVGA_H_SYNC,
        output				oVGA_V_SYNC,
        output				oVGA_SYNC,
        output				oVGA_BLANK,
        output				oTR_V ,
        output				oTR_H ,
        
        //	Control Signal
        input				iCLK,
        input				iRST_N,
        output          oVGA_CLOCK,
        output reg[12:0]H_Cont_,
        output reg[12:0]V_Cont_

);
`include "VGA_Param.h"

//=============================================================================
// REG/WIRE declarations
//=============================================================================

wire		[9:0]	mVGA_R;
wire		[9:0]	mVGA_G;
wire		[9:0]	mVGA_B;
reg				mVGA_H_SYNC;
reg				mVGA_V_SYNC;
wire				mVGA_SYNC;
wire				mVGA_BLANK;
wire	  [12:0]	v_mask;
reg            rVS ;
reg            rHS ;
reg            rVGA_H_SYNC ;
reg		[12:0]H_Cont;
reg		[12:0]V_Cont;
wire           IN_V_RTR ;
wire           IN_H_RTR ; 
wire     [15:0]H_T_TOL ;
wire           oTR_V_C ; 
wire           oTR_V_N ; 
wire     [7:0 ]H_OFF ; 
   
//--	
assign  oVGA_CLOCK	 = iCLK ; 

//--
always @(posedge iCLK ) begin 
     H_Cont_     <= H_Cont;
     V_Cont_     <= V_Cont;
     rVS         <= iVS ; 
     rHS         <= iHS ; 
	  rVGA_H_SYNC <= mVGA_H_SYNC ; 
end 

//--H_RECNT  
RE_COUNTER_H    hcn (  .CLK ( iCLK), .CLR ( oTR_H),    .TOL (H_T_TOL) , .R_TR()  );
RE_COUNTER_HS   hcs (  .CLK ( iCLK), .CLR ( oTR_H),    .TOL () ,        .R_TR( IN_H_RTR) );
RE_COUNTER_V    vcn (  .CLK ( iCLK), .CLR ( oTR_V_N ), .TOL () ,        .R_TR( IN_V_RTR) );

//-----
assign  oTR_V_C  = ( !rVGA_H_SYNC & mVGA_H_SYNC  ) ?1:0 ;  
assign  oTR_V    = ( !rVS & iVS  )?1 :0 ; 
assign  oTR_V_N  = (  rVS & ~iVS )?1 :0 ; 
assign  oTR_H    = (  rHS & !iHS )?1 :0 ; 
		
//	Internal Registers and Wires

assign v_mask = 13'd0;

////////////////////////////////////////////////////////

assign	mVGA_BLANK	=	mVGA_H_SYNC & mVGA_V_SYNC;
assign	mVGA_SYNC	=	1'b0;

assign	mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iRed	:	0;
assign	mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iGreen	:	0;
assign	mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iBlue	:	0;

assign oVGA_R      = mVGA_R;
assign oVGA_G      = mVGA_G;
assign  oVGA_B     = mVGA_B;
assign oVGA_BLANK  = mVGA_BLANK;
assign oVGA_SYNC   = mVGA_SYNC;
assign oVGA_H_SYNC = mVGA_H_SYNC;
assign oVGA_V_SYNC = mVGA_V_SYNC;				

//REV_H hg( . result(H_OFF) );
assign H_OFF =0; 

//	Pixel LUT Address Generator

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	oRequest	<=	0;
	else
	begin
		if(	
		      ( H_Cont>= X_START+H_OFF &&  H_Cont<X_START+H_SYNC_ACT+H_OFF)  &&
			   ( V_Cont>= Y_START     &&  V_Cont<Y_START+V_SYNC_ACT  ) 
		   )
		oRequest	<=	1;
		else
		oRequest	<=	0;
	end
end


//	H_Sync Generator, Ref. 25.175 MHz Clock
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		H_Cont		<=	0;
		mVGA_H_SYNC	<=	0;
	end
	else
	begin
		//	H_Sync Counter
		if ( IN_H_RTR )   
		  H_Cont	<=	0; 
		else if( H_Cont < H_T_TOL )  // H_SYNC_TOTAL ) 
		  H_Cont	<=	H_Cont+1;
		else H_Cont	<=	0;
		//	H_Sync Generator
		mVGA_H_SYNC	<=	( H_Cont < H_SYNC_CYC )?0 :1 ; 
	end
end

//	V_Sync Generator, Ref. H_Sync
always@( posedge iCLK or negedge iRST_N )
begin
	if(!iRST_N)
	begin
		V_Cont		<=	0;
		mVGA_V_SYNC	<=	0;
	end
	else
	begin
		//	When H_Sync Re-start
		     if  ( IN_V_RTR ) V_Cont <=	0;  
		else if  (( oTR_V_C ) && ( V_Cont < V_SYNC_TOTAL ) )  V_Cont	<=	V_Cont+1;
           
		//	V_Sync Generator
	 	
	     mVGA_V_SYNC <= (	V_Cont < V_SYNC_CYC )?0:1  ;  
			
	end
end

endmodule
