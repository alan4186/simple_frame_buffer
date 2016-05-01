module simple_frame_buffer (
			CLOCK_50, 
			KEY,// for reset
			VGA_R, 
			VGA_G, 
			VGA_B,
			VGA_HS, 
			VGA_VS,
			VGA_CLK,
			VGA_SYNC_N, 
			VGA_BLANK_N,
			SRAM_ADDR,
			SRAM_DQ, 
			SRAM_CE_N,
			SRAM_OE_N,
			SRAM_WE_N,
			SRAM_UB_N,
			SRAM_LB_N,
			LEDG
		);
input CLOCK_50;
input [3:0] KEY;

//input/output sram data bus
inout [15:0] SRAM_DQ;


// sram output pins
output SRAM_CE_N,SRAM_OE_N,SRAM_WE_N,SRAM_UB_N,SRAM_LB_N;
//vga output pins
output VGA_BLANK_N, VGA_SYNC_N, VGA_CLK, VGA_HS, VGA_VS;
//vga color data
output [7:0] VGA_R, VGA_G, VGA_B;
// green led output to display we signal
output [8:0] LEDG;
//sram address signal
output [19:0] SRAM_ADDR;

wire rst;

//sram wires/regs
wire [15:0] sram_dqW;
wire [19:0] sram_addrW,sram_addrR;
reg [15:0]sram_dq_reg;




//108MHz plls
wire clk108;
//pll108 clkmain(CLOCK_50, clk108);
//pll108 vga(CLOCK_50, VGA_CLK);
// 25.175Mhz PLL
pll25_175 clkmain(CLOCK_50, clk108);// clk108 is actually 25.175mhz
pll25_175 vga(CLOCK_50, VGA_CLK);

assign rst = KEY[0];

// if writing to sram use the sram()module address, else use the vga_sram() moudule address
assign SRAM_ADDR= SRAM_WE_N ? sram_addrR:sram_addrW;
// if reading sram set SRAM_DQ to high impedance mode
assign SRAM_DQ = SRAM_WE_N ? 16'hzzzz:sram_dqW;



//writes a black to red scale to sram 1024bits long
sram sram_scale(clk108, rst,sram_addrW,sram_dqW, SRAM_CE_N,SRAM_OE_N,SRAM_WE_N,SRAM_UB_N,SRAM_LB_N);


assign LEDG[8]=SRAM_WE_N ;
//julia calculator with shifts
//iteratio_tester tester0(clk108, rst,done,sram_addrW,sram_dqW,SRAM_CE_N,SRAM_OE_N,SRAM_WE_N,SRAM_UB_N,SRAM_LB_N,startFlag,rC,iC);
								//clk108



//reads sram and displays on vga monitor
// uses 1280x1024 but sram can only hold data for 2 colors (16bits) at 1024x1024 
//displays a black to red scale on monitor
vga_sram vga0(clk108,rst,VGA_R, VGA_G, VGA_B,VGA_HS, VGA_VS,VGA_SYNC_N, VGA_BLANK_N,sram_addrR,data/*SRAM_DQ*/,SRAM_WE_N);

reg[9:0] data;
always@(posedge clk108 or negedge rst) begin
  if(rst ==1'b0) 
    data <= 10'd0;
  else if(data<10'd800)
    data <= data+10'd1;
  else
    data <= 10'd0;
end



endmodule
