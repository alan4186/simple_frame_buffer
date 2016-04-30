module image_processing(
  input CLOCK_50,
  input RESET,
  
  input [7:0] IM_DATA, OBJ_DATA, 
  input [9:0] OBJ_X, OBJ_Y,
  input [18:0] IM_ADDR, OBJ_ADDR,
  
  output [7:0] FB_DATA,
  output [18:0] FB_ADDR,
  
  
  );
  
  wire cs_rdempty, os_rdempty,
  wire fifo_rst;
  
  
  
   
  
  assign FB_ADDR = OBJ_X + (OBJ_Y * 640);
  
  video_stream_fifo composite_stream(
    .aclr(fifo_rst),
    .data({IM_DATA, IM_ADDR}),
    .rdclk,
    .rdreq,
    .wrclk,
    .wrreq,
    .q,
    .rdempty(cs_rdempty),
    .wrfull);
    
  video_stream_fifo objec_stream(
    .aclr(fifo_rst),
    .data({OBJ_DATA, OBJ_ADDR}),
    .rdclk,
    .rdreq,
    .wrclk,
    .wrreq,
    .q,
    .rdempty(os_rdempty),
    .wrfull);
  
  always@(posedge CLOCK_50 or negedge RESET) begin
    if(RESET == 1'b0) begin
	   fifo_rst <= 1'b0;
	 end else begin
     fifo_rst <= 1'b1;
   
	 
	 
	 
	 end
  end
  
  always@(posedge CLOCK_RFIFO or negedge RESET) begin
    if (RESET == 1'b0) begin
      stream_state <= 1'b0; 
    else end begin
      if(os_rdempty) begin
        stream_state <= 1'b0; // stream the composite video signal
      end else begin
        stream_state <= !stream_state;
      end
    end // rst if
  end // always
  