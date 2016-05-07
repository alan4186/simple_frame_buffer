module frame_buffer(
	address_a,
	address_b,
	data_a,
	data_b,
	inclock,
	outclock,
	wren_a,
	wren_b,
	q_a,
	q_b
);

	input	[18:0]  address_a;
	input	[18:0]  address_b;
	input	[7:0]  data_a;
	input	[7:0]  data_b;
	input	  inclock;
	input	  outclock;
	input	  wren_a;
	input	  wren_b;
	output reg [7:0]  q_a;
	output reg [7:0]  q_b;
	
	wire [7:0] q_a0, q_a1, q_a2, q_a3, q_a4, q_b0, q_b1, q_b2, q_b3, q_b4;
	
	reg wren_a0, wren_a1, wren_a2, wren_a3, wren_a4, wren_b0, wren_b1, wren_b2, wren_b3, wren_b4;
	
	always@(*) begin
	case(address_a[18:16])
	3'b000: begin
	  q_a = q_a0;
	  wren_a0 = wren_a;
	  wren_a1 = 1'b0;
	  wren_a2 = 1'b0;
	  wren_a3 = 1'b0;
	  wren_a4 = 1'b0;
	  end
	3'b001: begin
	  q_a = q_a1;
	  wren_a0 = 1'b0;
	  wren_a1 = wren_a;
	  wren_a2 = 1'b0;
	  wren_a3 = 1'b0;
	  wren_a4 = 1'b0;
	  end
	3'b010: begin
	  q_a = q_a2;
	  wren_a0 = 1'b0;
	  wren_a1 = 1'b0;
	  wren_a2 = wren_a;
	  wren_a3 = 1'b0;
	  wren_a4 = 1'b0;
	  end
	3'b011: begin
	  q_a = q_a3;
	  wren_a0 = 1'b0;
	  wren_a1 = 1'b0;
	  wren_a2 = 1'b0;
	  wren_a3 = wren_a;
	  wren_a4 = 1'b0;
	  end
	3'b100: begin
	  q_a = q_a4;
	  wren_a0 = 1'b0;
	  wren_a1 = 1'b0;
	  wren_a2 = 1'b0;
	  wren_a3 = 1'b0;
	  wren_a4 = wren_a;
	  end
	default: begin
	  q_a = 8'd0;
	  wren_a0 = 1'b0;
	  wren_a1 = 1'b0;
	  wren_a2 = 1'b0;
	  wren_a3 = 1'b0;
	  wren_a4 = 1'b0;
	  end
	endcase
	
	case(address_b[18:16])
	3'b000: begin
	  q_b = q_b0;
	  wren_b0 = wren_b;
	  wren_b1 = 1'b0;
	  wren_b2 = 1'b0;
	  wren_b3 = 1'b0;
	  wren_b4 = 1'b0;
	  end
	3'b001: begin
	  q_b = q_b1;
	  wren_b0 = 1'b0;
	  wren_b1 = wren_b;
	  wren_b2 = 1'b0;
	  wren_b3 = 1'b0;
	  wren_b4 = 1'b0;
	  end
	3'b010: begin
	  q_b = q_b2;
	  wren_b0 = 1'b0;
	  wren_b1 = 1'b0;
	  wren_b2 = wren_b;
	  wren_b3 = 1'b0;
	  wren_b4 = 1'b0;
	  end
	3'b011: begin
	  q_b = q_b3;
	  wren_b0 = 1'b0;
	  wren_b1 = 1'b0;
	  wren_b2 = 1'b0;
	  wren_b3 = wren_b;
	  wren_b4 = 1'b0;
	  end
	3'b100: begin
	  q_b = q_b4;
	  wren_b0 = 1'b0;
	  wren_b1 = 1'b0;
	  wren_b2 = 1'b0;
	  wren_b3 = 1'b0;
	  wren_b4 = wren_b;
	  end
	default: begin
	  q_b = 8'd0;
	  wren_b0 = 1'b0;
	  wren_b1 = 1'b0;
	  wren_b2 = 1'b0;
	  wren_b3 = 1'b0;
	  wren_b4 = 1'b0;
	  end
	endcase
end
	
	fb_ram ram0(
	address_a[15:0],
	address_b[15:0],
	data_a,
	data_b,
	inclock,
	outclock,
	wren_a0,
	wren_b0,
	q_a0,
	q_b0
	);
	
	fb_ram ram1(
	address_a[15:0],
	address_b[15:0],
	data_a,
	data_b,
	inclock,
	outclock,
	wren_a1,
	wren_b1,
	q_a1,
	q_b1
	);
	
	fb_ram ram2(
	address_a[15:0],
	address_b[15:0],
	data_a,
	data_b,
	inclock,
	outclock,
	wren_a2,
	wren_b2,
	q_a2,
	q_b2
	);
	
	fb_ram ram3(
	address_a[15:0],
	address_b[15:0],
	data_a,
	data_b,
	inclock,
	outclock,
	wren_a3,
	wren_b3,
	q_a3,
	q_b3
	);
	
	fb_ram ram4(
	address_a[15:0],
	address_b[15:0],
	data_a,
	data_b,
	inclock,
	outclock,
	wren_a4,
	wren_b4,
	q_a4,
	q_b4
	);

endmodule
