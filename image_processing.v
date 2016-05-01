module image_processing(
  input CLOCK_50,
  input RESET,
  
  input [7:0] IM_DATA, 
  input [9:0] OBJ_X, OBJ_Y,
  input [18:0] FB_ADDR,
  
  output [7:0] FB_DATA,
  
  );
  
  
  reg [7:0] overwrite
  reg [18:0] obj_origin
  
  assign obj_origin = OBJ_X + (OBJ_Y * 640);
  
  assign overwrite[0] = (FB_ADDR == obj_origin[18:3] + (640*0)) ? 1'b1 : 1'b0;
  assign overwrite[1] = (FB_ADDR == obj_origin[18:3] + (640*1)) ? 1'b1 : 1'b0;
  assign overwrite[2] = (FB_ADDR == obj_origin[18:3] + (640*2)) ? 1'b1 : 1'b0;
  assign overwrite[3] = (FB_ADDR == obj_origin[18:3] + (640*3)) ? 1'b1 : 1'b0;
  assign overwrite[4] = (FB_ADDR == obj_origin[18:3] + (640*4)) ? 1'b1 : 1'b0;
  assign overwrite[5] = (FB_ADDR == obj_origin[18:3] + (640*5)) ? 1'b1 : 1'b0;
  assign overwrite[6] = (FB_ADDR == obj_origin[18:3] + (640*6)) ? 1'b1 : 1'b0;
  assign overwrite[7] = (FB_ADDR == obj_origin[18:3] + (640*7)) ? 1'b1 : 1'b0;
  
  assign FB_DATA = (overwrite > 8'h00) ? 8'hff : IM_DATA;
  
endmodule