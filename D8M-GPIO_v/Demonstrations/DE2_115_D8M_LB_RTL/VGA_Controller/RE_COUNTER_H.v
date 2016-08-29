module RE_COUNTER_H   ( 
input CLK , 
input CLR , 
output reg [15:0] TOL 

);
reg [15:0] CNT ;
      

always @(posedge CLK ) begin 
	      if ( CLR ) {CNT ,  TOL}  <= {16'h0 , CNT }; 
	      else  CNT <=CNT +1 ;  
	
end 

endmodule 
