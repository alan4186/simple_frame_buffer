module RE_COUNTER_HS   ( 
input CLK , 
input CLR , 
output reg [15:0] TOL  , 
output reg        R_TR  

);
reg   [15:0] CNT ;
      
//wire  [15:0]FIH;
//R_FIXHD RE(
//	.result (FIH) );

always @(posedge CLK ) begin 
         R_TR <=  ( CNT == 10 ) ? 1: 0 ; 
	      if ( CLR ) {CNT ,  TOL}  <= {16'h0 , CNT }; 
         else CNT <=CNT+1 ; 
	
end 

endmodule 
