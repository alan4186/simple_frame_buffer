
module RAW2RGB_J(	
//---ccd 
input	  [11:0]	 mCCD_DATA,
input			    CCD_PIXCLK ,
input		       CCD_FVAL,
input		       CCD_LVAL,
input	  [15:0]	 X_Cont,
input	  [15:0]	 Y_Cont,
input			    DVAL,
input			    RST,
input           VGA_CLK, // 25M 
input           READ_Request ,
input           VGA_VS ,	
input   [12:0]  READ_Cont ,
input   [12:0]  V_Cont , 
output	[11:0] oRed,
output 	[11:0] oGreen,
output	 [11:0]oBlue,
output	   	 oDVAL

);
//----- WIRE /REG 
wire	   [11:0]	mDAT0_0;
wire	   [11:0]	mDAT0_1;
wire	   [11:0]	mDAT0_2;
reg		[11:0]	mDAT1_0;
reg		[11:0]	mDAT1_1;
reg		[11:0]	mDAT1_2;
reg		[11:0]	mDAT2_0;
reg		[11:0]	mDAT2_1;
reg		[11:0]	mDAT2_2;
reg		[11:0]	mDAT3_0;
reg		[11:0]	mDAT3_1;
reg		[11:0]	mDAT3_2;
wire 		[11:0]	mCCD_R;
wire 		[13:0]	mCCD_G; 
wire 		[11:0]	mCCD_B;
reg				   mDVAL;


//-------- RGB OUT ---- 
assign   oRed	 = mCCD_R[11:0];
assign  oGreen  = mCCD_G[11:0] ;// ] ( mCCD_G >= 8189 )?4095 : mCCD_G/2 ;
assign	oBlue	 =	mCCD_B[11:0];

//-------- VALID OUT ---- 
assign	oDVAL	 =	mDVAL;

//----3 2-PORT-LINE-BUFFER----  
Line_Buffer_J 	u0	(	
						.CCD_PIXCLK( CCD_PIXCLK ),
						.mCCD_FVAL ( CCD_FVAL) ,
                  .mCCD_LVAL ( CCD_LVAL) , 	
						.X_Cont    ( X_Cont) , 
						.mCCD_DATA ( mCCD_DATA),
						.VGA_CLK   ( VGA_CLK), // 25M ) , // 25M 
                  .READ_Request (READ_Request),
                  .VGA_VS    ( VGA_VS),	
                  .READ_Cont ( READ_Cont),
                  .V_Cont    ( V_Cont),
					
						.taps0x    ( mDAT0_0),
						.taps1x    ( mDAT0_1)
						);					
/*		
//------RAW TO RGB------ 		
always@(negedge RST or posedge VGA_CLK)  // 25M  or negedge iRST)
begin
	if(!RST)
	begin
		mCCD_R	<=	0;
		mCCD_G	<=	0;
		mCCD_B	<=	0;
		mDAT1_0 <=	0;
		mDAT1_1 <=	0;
		mDAT1_2 <=	0;
		mDVAL	  <=	0;
	end
	else
	begin
		{mDAT3_0,mDAT2_0, mDAT1_0}	<=	{mDAT2_0,mDAT1_0,mDAT0_0};
		{mDAT3_1,mDAT2_1, mDAT1_1}	<=	{mDAT2_1,mDAT1_1,mDAT0_1};
		//{mDAT3_2,mDAT2_2, mDAT1_2}	<=	{mDAT2_2,mDAT1_2,mDAT0_2};
		//mDVAL		<=	{V_Cont[0]|H_Cont[0]}	?	1'b0	:	DVAL;
		if({V_Cont[0],READ_Cont[0]}     ==2'h3) //0
		begin
			mCCD_B	<=	(mDAT0_1);
			mCCD_G	<=	(mDAT0_0);//+mDAT1_1)/2;
			mCCD_R	<=	(mDAT1_0);
		end
		
		else if({V_Cont[0],READ_Cont[0]}==2'h0)//1
		begin
			mCCD_B	<=(mDAT1_1);
			mCCD_G	<=(mDAT0_1);//  + mDAT1_0)/2;
			mCCD_R	<=(mDAT0_0);
		end

		else if({V_Cont[0],READ_Cont[0]}==2'h1)//2
		begin
			mCCD_B	<=	(mDAT0_0);
			mCCD_G	<=	(mDAT1_0 );//+ mDAT0_1)/2;
			mCCD_R	<=	(mDAT1_1);
		end	
		else if({V_Cont[0],READ_Cont[0]}==2'h2)//2
		begin
			mCCD_B	<=(mDAT1_0);
			mCCD_G	<=(mDAT1_1);// + mDAT0_0)/2;
			mCCD_R	<=(mDAT0_1);
		end	
	end
end
*/
/*
Line_Buffer 	u0	(	.clken(iDVAL),
						.clock(iCLK),
						.shiftin(iDATA),
						.taps0x(mDATA_1),
						.taps1x(mDATA_0)	);
*/

			
						
RAW_RGB_BIN  bin(
      .CLK  ( VGA_CLK ), 
      .RST_N( RST ) , 
      .D0   ( mDAT0_0),
      .D1   ( mDAT0_1),
      .X    ( READ_Cont[0]) ,
      .Y    ( V_Cont[0]),
       
      .R    ( mCCD_B),
      .G    ( mCCD_G), 
      .B    ( mCCD_R)
); 


endmodule
