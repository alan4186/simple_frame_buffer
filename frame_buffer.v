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

	input	[17:0]  address_a;
	input	[17:0]  address_b;
	input	[7:0]  data_a;
	input	[7:0]  data_b;
	input	  inclock;
	input	  outclock;
	input	  wren_a;
	input	  wren_b;
	output reg [7:0]  q_a;
	output reg [7:0]  q_b;
	
	wire [7:0] q_a0, q_a1, q_a2, q_a3, q_b0, q_b1, q_b2, q_b3;
	
	reg wren_a0, wren_a1, wren_a2, wren_a3, wren_b0, wren_b1, wren_b2, wren_b3;
	//reg[7:0] data_a0, data_a1, data_a2, data_a3, data_b0, data_b1, data_b2, data_b3;
	
	always@(*) begin
	case(address_a[17:16])
	2'b00: begin
	  q_a = q_a0;
//	  data_a0 = data_a;
	  wren_a0 = wren_a;
	  wren_a1 = 1'b0;
	  wren_a2 = 1'b0;
	  wren_a3 = 1'b0;
	  end
	2'b01: begin
	  q_a = q_a1;
//	  data_a1 = data_a;
	  wren_a0 = 1'b0;
	  wren_a1 = wren_a;
	  wren_a2 = 1'b0;
	  wren_a3 = 1'b0;
	  end
	2'b10: begin
	  q_a = q_a2;
//	  data_a2 = data_a;
	  wren_a0 = 1'b0;
	  wren_a1 = 1'b0;
	  wren_a2 = wren_a;
	  wren_a3 = 1'b0;
	  end
	3'b11: begin
	  q_a = q_a3;
//	  data_a3 = data_a;
	  wren_a0 = 1'b0;
	  wren_a1 = 1'b0;
	  wren_a2 = 1'b0;
	  wren_a3 = wren_a;
	  end
	endcase
	
	case(address_b[17:16])
	2'b00: begin
	  q_b = q_b0;
//	  data_b0 = data_b;
	  wren_b0 = wren_b;
	  wren_b1 = 1'b0;
	  wren_b2 = 1'b0;
	  wren_b3 = 1'b0;
	  end
	2'b01: begin
	  q_b = q_b1;
//	  data_b1 = data_b;
	  wren_b0 = 1'b0;
	  wren_b1 = wren_b;
	  wren_b2 = 1'b0;
	  wren_b3 = 1'b0;
	  end
	2'b10: begin
	  q_b = q_b2;
//	  data_b2 = data_b;
	  wren_b0 = 1'b0;
	  wren_b1 = 1'b0;
	  wren_b2 = wren_b;
	  wren_b3 = 1'b0;
	  end
	3'b11: begin
	  q_b = q_b3;
//	  data_b3 = data_b;
	  wren_b0 = 1'b0;
	  wren_b1 = 1'b0;
	  wren_b2 = 1'b0;
	  wren_b3 = wren_b;
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
endmodule
