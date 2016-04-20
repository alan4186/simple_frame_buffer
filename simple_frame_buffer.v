module simple_frame_buffer (clk, rst,VGA_R, VGA_G, VGA_B,VGA_HS, VGA_VS,VGA_CLK,VGA_SYNC, VGA_BLANK,sram_addrF,sram_dqF, ce_n,oe_n,we_n,ub_n,lb_n,ledwe);
input clk, rst;


//input/output sram data bus
inout [15:0] sram_dqF;


// sram output pins
output ce_n,oe_n,we_n,ub_n,lb_n,ledwe;
//vga output pins
output VGA_BLANK, VGA_SYNC, VGA_CLK, VGA_HS, VGA_VS;
//vga color data
output [7:0] VGA_R, VGA_G, VGA_B;
//sram address signal
output [19:0] sram_addrF;


//sram wires/regs
wire [15:0] sram_dqW;
wire [19:0] sram_addrW,sram_addrR;
reg [15:0]sram_dq_reg;




//108MHz plls
wire clk108;
pll108 clkmain(clk, clk108);
pll108 vga(clk, VGA_CLK);

// if writing to sram use the sram()module address, else use the vga_sram() moudule address
assign sram_addrF= we_n ? sram_addrR:sram_addrW;
// if reading sram set sram_dqF to high impedance mode
assign sram_dqF= we_n ? 16'hzzzz:sram_dqW;



//writes a black to red scale to sram 1024bits long
sram sram_scale(clk108, rst,sram_addrW,sram_dqW, ce_n,oe_n,we_n,ub_n,lb_n);


assign ledwe=we_n ;
//julia calculator with shifts
//iteratio_tester tester0(clk108, rst,done,sram_addrW,sram_dqW,ce_n,oe_n,we_n,ub_n,lb_n,startFlag,rC,iC);
								//clk108



//reads sram and displays on vga monitor
// uses 1280x1024 but sram can only hold data for 2 colors (16bits) at 1024x1024 
//displays a black to red scale on monitor
vga_sram vga0(clk108,rst,VGA_R, VGA_G, VGA_B,VGA_HS, VGA_VS,VGA_SYNC, VGA_BLANK,sram_addrR,sram_dqF,we_n);




endmodule
