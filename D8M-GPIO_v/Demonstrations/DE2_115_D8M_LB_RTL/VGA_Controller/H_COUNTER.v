module H_COUNTER  (
input CLK , 
input HS , 
output reg [15:0]  H_CNT,
output reg [15:0]  rH_CNT

);
reg rHS ; 
always@(posedge CLK) begin 
 rHS <= HS ;
 if ( !rHS & HS  )  { rH_CNT , H_CNT} <= { 16'h0 , rH_CNT } ;
 else rH_CNT<= rH_CNT+1 ; 

end 
endmodule 