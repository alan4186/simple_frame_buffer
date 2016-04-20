// writes to sram
module sram(clk, rst,sram_addr,sram_dq, ce_n,oe_n,we_n,ub_n,lb_n);
input clk, rst;



inout [15:0] sram_dq;

output [19:0] sram_addr;
output ce_n,oe_n,we_n,ub_n,lb_n;


reg [19:0] sram_addr;
reg [15:0]sram_dq_reg;
reg oe_n,we_n;
reg reading, done, error;

wire ce_n,ub_n,lb_n;
wire dbsw;
wire clk10;
wire[7:0] count_flip;

assign sram_dq = we_n ? 16'hzzzz:sram_dq_reg;

assign ce_n=1'b0,//the chip is always selected
		 ub_n=1'b0,//the upper byte [15:8] will be read/writed each read/write command
		 lb_n=1'b0;//the lower byte [7:0] will be read/writed each read/write command

assign count_flip = {count[2], count[3], count[4], count[5], count[6], count[7], count[8], count[9]};	 

always@(posedge clk or negedge rst)
begin
	if (rst==1'b0)
		begin
			oe_n<=1'b0;//dont care in write state
			we_n<=1'b0;//enter write state on rst
			sram_addr<=20'd0;

		end
	else
				begin
					oe_n<=1'b0;//dont care
					sram_addr<=count;//set address on sram
					sram_dq_reg<={count[9:2],/*8'd0*/count_flip};//write to selected sram
					if(count==20'hfffff)
						we_n<=1'b1;// when every address has been writen to, start reading
				end

		
		
end


reg [19:0] count;

always@(posedge clk or negedge rst)
begin
	if(rst==1'b0)
		count<=19'd0;
	else
		count<=count+19'd1;

end






endmodule