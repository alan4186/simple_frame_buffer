module RE_COUNTER_V   ( 
input CLK , 
input CLR , 
output reg [15:0] TOL  , 
output reg        R_TR  

);
reg [15:0] CNT ;
      
wire  [15:0]FI;
//R_FIX RE(
//	.result (FI) );

assign FI = 16'h5175	 ; 
	
always @(posedge CLK ) begin 
         R_TR <=  ( CNT == FI ) ? 1: 0 ; 
	      if ( CLR ) {CNT ,  TOL}  <= {16'h0 , CNT }; 
	      else if ( CNT < 50*525 ) CNT <=CNT +1 ;  
	
end 

endmodule 
