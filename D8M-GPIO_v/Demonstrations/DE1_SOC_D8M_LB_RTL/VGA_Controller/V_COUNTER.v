module V_COUNTER  (
input CLK , 
input HS , 
input VS , 
output reg [15:0]  V_CNT , 
output reg [15:0]  rV_CNT
);
reg rHS ; 
reg rVS ; 

always@(posedge CLK) begin 
 rHS <= HS ;
 rVS <= VS ;
      if ( !rVS & VS  ) {rV_CNT , V_CNT } <={ 16'h0 , rV_CNT } ;
 else if ( !rHS & HS  )  rV_CNT<= rV_CNT+1 ; 
end 

endmodule 