module RE_COUNTER   ( 
input CLK , 
input CLR , 
output reg [15:0] TOL  , 
output reg        R_TR  

);
reg [15:0] CNT ;
      
wire  [15:0]FI;
R_FIX EE(
	.result (FI) );

always @(posedge CLK ) begin 
         R_TR <=  ( CNT == FI ) ? 1: 0 ; 
	      if ( CLR ) {CNT ,  TOL}  <= {16'h0 , CNT }; 
	      else if ( CNT < 50 ) CNT <=CNT +1 ;  
	
end 

endmodule 
