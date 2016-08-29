module START_AUTO_FADJ ( 
input CLOCK_50 , 
input START_TR , 
output AUTO_GO  

);
reg [31:0]PULSE ; 
always @(negedge START_TR or posedge CLOCK_50 ) begin 
if       (! START_TR ) PULSE <=0;
else if  (PULSE < 50000000*4)  PULSE <=PULSE+1 ; 
end 


assign AUTO_GO  = (PULSE < 50000000*2 )?0 : 1 ; 

endmodule 
