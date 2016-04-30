//reads ram and displays on vga monitor
module vga_sram(CLOCK_PX ,rst,VGA_R, VGA_G, VGA_B,VGA_HS, VGA_VS,VGA_SYNC, VGA_BLANK,FB_ADDR,fb_data,we_nIN);



input CLOCK_PX,rst;

//reg [7:0]fb_data_reg;
input we_nIN;
input [7:0] fb_data;



output VGA_BLANK, VGA_SYNC, VGA_HS, VGA_VS;
output [7:0] VGA_R, VGA_G, VGA_B;
output [19:0] FB_ADDR;


reg [7:0] VGA_R, VGA_G, VGA_B;
reg  VGA_HS, VGA_VS, h_blank, v_blank, status;
reg [31:0] pixelcount, linecount;
reg red_value;

reg [9:0] rdaddress;
reg [9:0] wraddress;
reg [19:0] FB_ADDR;
reg [7:0] Rdata, Bdata;
reg UBwe, LBwe;

wire CLOCK_PX,we_nIN;
wire VGA_BLANK, VGA_SYNC;
wire [7:0] Rq,Bq, gray;

// VGA parameters 1280 x 1024
// horizontal
parameter H_FRONT = 16;
parameter H_SYNC = 96;
parameter H_BACK = 48;
parameter H_ACT = 640;
parameter H_BLANK = H_FRONT + H_SYNC + H_BACK;
parameter H_TOTAL = H_FRONT + H_SYNC + H_BACK + H_ACT;

// vertical
parameter V_FRONT = 10;
parameter V_SYNC = 2;
parameter V_BACK = 33;
parameter V_ACT = 480;
parameter V_BLANK = V_FRONT + V_SYNC + V_BACK;
parameter V_TOTAL = V_FRONT + V_SYNC + V_BACK + V_ACT;


// VGA parameters 1280 x 1024
// horizontal
//parameter H_FRONT = 48;
//parameter H_SYNC = 112;
//parameter H_BACK = 248;
//parameter H_ACT = 1280;
//parameter H_BLANK = H_FRONT + H_SYNC + H_BACK;
//parameter H_TOTAL = H_FRONT + H_SYNC + H_BACK + H_ACT;
//
//// vertical
//parameter V_FRONT = 1;
//parameter V_SYNC = 3;
//parameter V_BACK = 38;
//parameter V_ACT = 1024;
//parameter V_BLANK = V_FRONT + V_SYNC + V_BACK;
//parameter V_TOTAL = V_FRONT + V_SYNC + V_BACK + V_ACT;

parameter FB_SIZE = V_ACT * H_ACT;

// parameters to force a square image
parameter SH_ACT = 0;//V_ACT; // make the horizontal resolution the same as the vertical resolution
parameter S_FILLER = 0;//SH_ACT/2;

//vga pin  assigns
assign VGA_SYNC = VGA_HS || VGA_VS,
		 VGA_BLANK = h_blank || v_blank;
		 

//sram pin assigns
//assign ce_n=1'b0,//the chip is always selected
	//	 oe_n=1'b0,//dont car in write state, 0 in read state
	//	 ub_n=1'b0,//the upper byte [15:8] will be read/writed each read/write command
	//	 lb_n=1'b0;//the lower byte [7:0] will be read/writed each read/write command

//rgb2gray r2g( Rdata, 8'd0, Bdata,gray);		 
		 
//linebuffer ram					rdclock 				wrclock
//linebuffer red(gray,rdaddress,CLOCK_PX,wraddress,CLOCK_PX,LBwe,Rq);
//linebuffer blue(gray,rdaddress,CLOCK_PX,wraddress,CLOCK_PX,UBwe,Bq);	 
linebuffer red(Rdata,rdaddress,CLOCK_PX,wraddress,CLOCK_PX,LBwe,Rq);// only need one channel for grayscale
//linebuffer blue(Bdata,rdaddress,CLOCK_PX,wraddress,CLOCK_PX,UBwe,Bq);


// pixel counter and line counter
always@(posedge CLOCK_PX or negedge rst)
begin
	if (rst==1'b0)
		begin
		pixelcount<=32'd0;
		linecount<=32'd0;
		end
	else
		if(we_nIN==1'b1)
			if (pixelcount>H_TOTAL)
				begin
					pixelcount<=32'd0;
					if (linecount>V_TOTAL)
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
always@(posedge CLOCK_PX or negedge rst)
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
	if ((pixelcount>=H_SYNC && pixelcount<(H_SYNC+H_BACK))|| (pixelcount>=(H_SYNC+H_BACK+H_ACT)))
		h_blank<=1'b0;
	else
		h_blank<=1'b1;
	
	// horizontal visible area 
	//if (pixelcount>=32'd360 && pixelcount<32'd1640)
	//change to make a square 1024x1024													//<=
	if (linecount>=(V_BACK+V_SYNC)&&linecount<(V_BACK+V_SYNC+V_ACT)&&pixelcount>=(H_BACK+H_SYNC/*+S_FILLER*/) && pixelcount<(H_BACK+H_SYNC+H_ACT/*-S_FILLER*/)&&we_nIN==1'b1)
		begin
		//read linebuffer
			//VGA_R<=8'h00;
			VGA_R<=Rq;//Rq and Bq should be equal and grayscale
			VGA_G<=Rq;
			VGA_B<=Rq;//Bq;
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
always@(posedge CLOCK_PX or negedge rst)
begin 
	if (rst ==1'b0)
		begin
		VGA_VS<=1'b0;
		v_blank <= 1'b0;
		end
	else
	
	begin
	
	//vsync
	if (linecount<V_SYNC)
		VGA_VS<=1'b0;
	else
		VGA_VS <= 1'b1;
	
	// Back porch or front porch
	if ((linecount >=V_SYNC && linecount<(V_BACK+V_SYNC))|| linecount>=(V_BACK+V_SYNC+V_ACT))
		v_blank<=1'b1;
	else
		v_blank <= 1'b0;
	
	//vertical visible area
		// nothing else needs to be done
		//linecount >= 32'd29 && linecount< 32'd629
		
	end// end rst else

end

//fill line buffer
always@(posedge CLOCK_PX or negedge rst)
begin
	if(rst==1'b0)
		begin
			wraddress<=10'd0;
			FB_ADDR<=20'd0;
		end
	else
		// fill line buffer in the first 1024 pixels of row (only on visible rows)  \/ is this right?
		// commented out part that makes screen square
		if(linecount>=(V_SYNC+V_BACK)&&linecount<(V_SYNC+V_BACK+V_ACT)/*&&pixelcount<SH_ACT*/&&we_nIN==1'b1)
			begin
				Rdata<=fb_data;
				//Bdata<=fb_data;// only need one channel for grayscale
				//incriment on-chip ram address
				wraddress<=wraddress+10'd1;
				//incriment sram address
				if(FB_ADDR > FB_SIZE) begin
				  FB_ADDR <= 20'd0;// FB_ADDR might be less than 20 bits
				end else begin 
  				  FB_ADDR<=FB_ADDR+20'd1;
				end 
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