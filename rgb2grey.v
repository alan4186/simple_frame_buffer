module rgb2gray(

input [7:0] red, green, blue,
output[7:0] grey

);

wire [14:0] r, g, b;
reg [14:0] sum, g_scale;

assign r = {2'b00, red, 5'b00000};
assign g = {2'b00, green, 5'b00000};
assign b = {2'b00, blue, 5'b00000};
assign grey = (g_scale[14:13] == 2'b00) ? g_scale[12:5] : 8'hff;

always@(*) begin
  sum = {2'd0, r, 5'd0} + {2'd0, g, 5'd0} + {2'd0, b, 5'd0};
  g_scale = sum * {10'd0, 5'd01011};
end 

endmodule
