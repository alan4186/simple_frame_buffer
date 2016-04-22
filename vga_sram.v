//reads sram and displays on vga monitor
module vga_sram(clk108 ,rst,VGA_R, VGA_G, VGA_B,VGA_HS, VGA_VS,VGA_SYNC, VGA_BLANK,sram_addr,sram_dq,we_nIN);



input clk108,rst;

reg [15:0]sram_dq_reg;
input we_nIN;
input [15:0] sram_dq;



output VGA_BLANK, VGA_SYNC, VGA_HS, VGA_VS;
output [7:0] VGA_R, VGA_G, VGA_B;
output [19:0] sram_addr;


reg [7:0] VGA_R, VGA_G, VGA_B;
reg  VGA_HS, VGA_VS, h_blank, v_blank, status;
reg [31:0] pixelcount, linecount;
reg red_value;

reg [9:0] rdaddress;
reg [9:0] wraddress;
reg [19:0] sram_addr;
reg [7:0] Rdata, Bdata;
reg UBwe, LBwe;

wire clk108,we_nIN;
wire VGA_BLANK, VGA_SYNC;
wire [7:0] Rq,Bq, gray;

// VGA parameters
// horizontal
parameter H_FRONT = 48;
parameter H_SYNC = 112;
parameter H_BACK = 248;
parameter H_ACT = 1280;
parameter H_BLANK = H_FRONT + H_SYNC + H_BACK;
parameter H_TOTAL = H_FRONT + H_SYNC + H_BACK + H_ACT;

// vertical
parameter V_FRONT = 1;
parameter V_SYNC = 3;
parameter V_BACK = 38;
parameter V_ACT = 1024;
parameter V_BLANK = V_FRONT + V_SYNC + V_BACK;
parameter V_TOTAL = V_FRONT + V_SYNC + V_BACK + V_ACT;


//vga pin  assigns
assign VGA_SYNC = VGA_HS || VGA_VS,
		 VGA_BLANK = h_blank || v_blank;
		 

//sram pin assigns
//assign ce_n=1'b0,//the chip is always selected
	//	 oe_n=1'b0,//dont car in write state, 0 in read state
	//	 ub_n=1'b0,//the upper byte [15:8] will be read/writed each read/write command
	//	 lb_n=1'b0;//the lower byte [7:0] will be read/writed each read/write command

rgb2gray r2g( Rdata, 8'd0, Bdata,gray);		 
		 
//linebuffer ram					rdclock 				wrclock
linebuffer red(gray,rdaddress,clk108,wraddress,clk108,LBwe,Rq);
linebuffer blue(gray,rdaddress,clk108,wraddress,clk108,UBwe,Bq);	 



// pixel counter and line counter
always@(posedge clk108 or negedge rst)
begin
	if (rst==1'b0)
		begin
		pixelcount<=32'd0;
		linecount<=32'd0;
		end
	else
		if(we_nIN==1'b1)
			if (pixelcount>32'd1688)
				begin
					pixelcount<=32'd0;
					if (linecount>32'd1066)
						linecount<=32'd0;
					else
						linecount<= linecount+1;
				end
			else
				pixelcount<= pixelcount+1;
		else
			begin
				pixelcount<=32'd0;
				linecount<=32'd0;
			end
end

//horizontal outputs
always@(posedge clk108 or negedge rst)
begin
	if (rst == 1'b0)
		begin 
		VGA_HS<=1'b0;
		h_blank<=1'b1;
		VGA_R<=8'h00;
		VGA_G<=8'h00;
		VGA_B<=8'h00;
		rdaddress<=10'b0000000100;
		end
	else
	
	begin
	
	
	//HSYNC
	if (pixelcount< H_SYNC)
		VGA_HS<=1'b0;
	else
		VGA_HS<=1'b1;
	
	//Back porch and Front porch
	if ((pixelcount>=H_SYNC && pixelcount<32'd360)|| (pixelcount>=32'd1640))
		h_blank<=1'b0;
	else
		h_blank<=1'b1;
	
	// horizontal visible area 
	//if (pixelcount>=32'd360 && pixelcount<32'd1640)
	//change to make a square 1024x1024													//<=
	if (linecount>=32'd41&&linecount<32'd1065&&pixelcount>=32'd488 && pixelcount<32'd1512&&we_nIN==1'b1)
		begin
		//read linebuffer
			//VGA_R<=8'h00;
			VGA_R<=Rq;//Rq and Bq should be equal and grayscale
			VGA_G<=Rq;
			VGA_B<=Bq;
		//incriment LB addr
			rdaddress<=rdaddress+10'd1;
		end
	else
		begin
		//dont read frame buffer
		//included to remove infered latch
		VGA_R<=8'h00;
		VGA_G<=8'h00;
		VGA_B<=8'h00;
		rdaddress<=rdaddress;
		end
	end// end else rst
end//always



// vertical outputs
always@(posedge clk108 or negedge rst)
begin 
	if (rst ==1'b0)
		begin
		VGA_VS<=1'b0;
		v_blank <= 1'b0;
		end
	else
	
	begin
	
	//vsync
	if (linecount<32'd3)
		VGA_VS<=1'b0;
	else
		VGA_VS <= 1'b1;
	
	// Back porch or front porch
	if ((linecount >=V_SYNC && linecount<32'd41)|| linecount>=32'd1065)
		v_blank<=1'b1;
	else
		v_blank <= 1'b0;
	
	//vertical visible area
		// nothing else needs to be done
		//linecount >= 32'd29 && linecount< 32'd629
		
	end// end rst else

end

//fill line buffer
always@(posedge clk108 or negedge rst)
begin
	if(rst==1'b0)
		begin
			wraddress<=10'd0;
			//sram_addr<=20'd0;
			sram_addr<=20'h00000;

		end
	else
		// fill line buffer in the first 1024 pixels of row (only on visible rows)
		if(linecount>=32'd41&&linecount<32'd1065&&pixelcount<32'd1024&&we_nIN==1'b1)
			begin
				Rdata<=sram_dq[15:8];
				Bdata<=sram_dq[7:0];
				//incriment on-chip ram address
				wraddress<=wraddress+10'd1;
				//incriment sram address
				sram_addr<=sram_addr+20'd1;
				//enable writing to on chip rams
				UBwe<=1'b1;
				LBwe<=1'b1;
			end
		else
			begin
				//disable writing to on chip rams
				UBwe<=1'b0;
				LBwe<=1'b0;	
			end
end//always


endmodule