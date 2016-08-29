// Qsys_alt_vip_cl_cvo_0.v

// This file was auto-generated from alt_vip_cl_cvo_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 15.0 145

`timescale 1 ps / 1 ps
module Qsys_alt_vip_cl_cvo_0 #(
		parameter NUMBER_OF_COLOUR_PLANES       = 3,
		parameter COLOUR_PLANES_ARE_IN_PARALLEL = 1,
		parameter BPS                           = 8,
		parameter INTERLACED                    = 0,
		parameter H_ACTIVE_PIXELS               = 640,
		parameter V_ACTIVE_LINES                = 480,
		parameter ACCEPT_COLOURS_IN_SEQ         = 0,
		parameter FIFO_DEPTH                    = 3200,
		parameter CLOCKS_ARE_SAME               = 0,
		parameter USE_CONTROL                   = 0,
		parameter NO_OF_MODES                   = 1,
		parameter THRESHOLD                     = 3199,
		parameter STD_WIDTH                     = 1,
		parameter GENERATE_SYNC                 = 0,
		parameter USE_EMBEDDED_SYNCS            = 0,
		parameter AP_LINE                       = 0,
		parameter V_BLANK                       = 0,
		parameter H_BLANK                       = 0,
		parameter H_SYNC_LENGTH                 = 96,
		parameter H_FRONT_PORCH                 = 16,
		parameter H_BACK_PORCH                  = 49,
		parameter V_SYNC_LENGTH                 = 2,
		parameter V_FRONT_PORCH                 = 10,
		parameter V_BACK_PORCH                  = 33,
		parameter F_RISING_EDGE                 = 0,
		parameter F_FALLING_EDGE                = 0,
		parameter FIELD0_V_RISING_EDGE          = 0,
		parameter FIELD0_V_BLANK                = 0,
		parameter FIELD0_V_SYNC_LENGTH          = 0,
		parameter FIELD0_V_FRONT_PORCH          = 0,
		parameter FIELD0_V_BACK_PORCH           = 0,
		parameter ANC_LINE                      = 0,
		parameter FIELD0_ANC_LINE               = 0,
		parameter SRC_WIDTH                     = 8,
		parameter DST_WIDTH                     = 8,
		parameter CONTEXT_WIDTH                 = 8,
		parameter TASK_WIDTH                    = 8
	) (
		input  wire        clocked_video_vid_clk,       //     clocked_video.vid_clk
		output wire [23:0] clocked_video_vid_data,      //                  .vid_data
		output wire        clocked_video_underflow,     //                  .underflow
		output wire        clocked_video_vid_datavalid, //                  .vid_datavalid
		output wire        clocked_video_vid_v_sync,    //                  .vid_v_sync
		output wire        clocked_video_vid_h_sync,    //                  .vid_h_sync
		output wire        clocked_video_vid_f,         //                  .vid_f
		output wire        clocked_video_vid_h,         //                  .vid_h
		output wire        clocked_video_vid_v,         //                  .vid_v
		input  wire        main_clock_clk,              //        main_clock.clk
		input  wire        main_reset_reset,            //        main_reset.reset
		input  wire [23:0] din_data,                    //               din.data
		input  wire        din_valid,                   //                  .valid
		input  wire        din_startofpacket,           //                  .startofpacket
		input  wire        din_endofpacket,             //                  .endofpacket
		output wire        din_ready,                   //                  .ready
		output wire        status_update_irq_irq        // status_update_irq.irq
	);

	wire         video_in_av_st_dout_valid;              // video_in:av_st_dout_valid -> cvo_core:av_st_din_valid
	wire  [55:0] video_in_av_st_dout_data;               // video_in:av_st_dout_data -> cvo_core:av_st_din_data
	wire         video_in_av_st_dout_ready;              // cvo_core:av_st_din_ready -> video_in:av_st_dout_ready
	wire         video_in_av_st_dout_startofpacket;      // video_in:av_st_dout_startofpacket -> cvo_core:av_st_din_startofpacket
	wire         video_in_av_st_dout_endofpacket;        // video_in:av_st_dout_endofpacket -> cvo_core:av_st_din_endofpacket
	wire         scheduler_cmd_vib_valid;                // scheduler:cmd_vib_valid -> video_in:av_st_cmd_valid
	wire  [63:0] scheduler_cmd_vib_data;                 // scheduler:cmd_vib_data -> video_in:av_st_cmd_data
	wire         scheduler_cmd_vib_ready;                // video_in:av_st_cmd_ready -> scheduler:cmd_vib_ready
	wire         scheduler_cmd_vib_startofpacket;        // scheduler:cmd_vib_startofpacket -> video_in:av_st_cmd_startofpacket
	wire         scheduler_cmd_vib_endofpacket;          // scheduler:cmd_vib_endofpacket -> video_in:av_st_cmd_endofpacket
	wire         scheduler_cmd_mark_valid;               // scheduler:cmd_mark_valid -> cvo_core:cmd_mark_valid
	wire  [63:0] scheduler_cmd_mark_data;                // scheduler:cmd_mark_data -> cvo_core:cmd_mark_data
	wire         scheduler_cmd_mark_ready;               // cvo_core:cmd_mark_ready -> scheduler:cmd_mark_ready
	wire         scheduler_cmd_mark_startofpacket;       // scheduler:cmd_mark_startofpacket -> cvo_core:cmd_mark_startofpacket
	wire         scheduler_cmd_mark_endofpacket;         // scheduler:cmd_mark_endofpacket -> cvo_core:cmd_mark_endofpacket
	wire         video_in_av_st_resp_valid;              // video_in:av_st_resp_valid -> scheduler:resp_vib_valid
	wire  [63:0] video_in_av_st_resp_data;               // video_in:av_st_resp_data -> scheduler:resp_vib_data
	wire         video_in_av_st_resp_ready;              // scheduler:resp_vib_ready -> video_in:av_st_resp_ready
	wire         video_in_av_st_resp_startofpacket;      // video_in:av_st_resp_startofpacket -> scheduler:resp_vib_startofpacket
	wire         video_in_av_st_resp_endofpacket;        // video_in:av_st_resp_endofpacket -> scheduler:resp_vib_endofpacket
	wire         scheduler_cmd_mode_banks_valid;         // scheduler:cmd_mode_banks_valid -> cvo_core:cmd_mode_banks_valid
	wire  [63:0] scheduler_cmd_mode_banks_data;          // scheduler:cmd_mode_banks_data -> cvo_core:cmd_mode_banks_data
	wire         scheduler_cmd_mode_banks_ready;         // cvo_core:cmd_mode_banks_ready -> scheduler:cmd_mode_banks_ready
	wire         scheduler_cmd_mode_banks_startofpacket; // scheduler:cmd_mode_banks_startofpacket -> cvo_core:cmd_mode_banks_startofpacket
	wire         scheduler_cmd_mode_banks_endofpacket;   // scheduler:cmd_mode_banks_endofpacket -> cvo_core:cmd_mode_banks_endofpacket
	wire         cvo_core_resp_mode_banks_valid;         // cvo_core:resp_mode_banks_valid -> scheduler:resp_mode_banks_valid
	wire  [63:0] cvo_core_resp_mode_banks_data;          // cvo_core:resp_mode_banks_data -> scheduler:resp_mode_banks_data
	wire         cvo_core_resp_mode_banks_ready;         // scheduler:resp_mode_banks_ready -> cvo_core:resp_mode_banks_ready
	wire         cvo_core_resp_mode_banks_startofpacket; // cvo_core:resp_mode_banks_startofpacket -> scheduler:resp_mode_banks_startofpacket
	wire         cvo_core_resp_mode_banks_endofpacket;   // cvo_core:resp_mode_banks_endofpacket -> scheduler:resp_mode_banks_endofpacket

	generate
		// If any of the display statements (or deliberately broken
		// instantiations) within this generate block triggers then this module
		// has been instantiated this module with a set of parameters different
		// from those it was generated for.  This will usually result in a
		// non-functioning system.
		if (NUMBER_OF_COLOUR_PLANES != 3)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					number_of_colour_planes_check ( .error(1'b1) );
		end
		if (COLOUR_PLANES_ARE_IN_PARALLEL != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					colour_planes_are_in_parallel_check ( .error(1'b1) );
		end
		if (BPS != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					bps_check ( .error(1'b1) );
		end
		if (INTERLACED != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					interlaced_check ( .error(1'b1) );
		end
		if (H_ACTIVE_PIXELS != 640)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					h_active_pixels_check ( .error(1'b1) );
		end
		if (V_ACTIVE_LINES != 480)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					v_active_lines_check ( .error(1'b1) );
		end
		if (ACCEPT_COLOURS_IN_SEQ != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					accept_colours_in_seq_check ( .error(1'b1) );
		end
		if (FIFO_DEPTH != 3200)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					fifo_depth_check ( .error(1'b1) );
		end
		if (CLOCKS_ARE_SAME != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					clocks_are_same_check ( .error(1'b1) );
		end
		if (USE_CONTROL != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_control_check ( .error(1'b1) );
		end
		if (NO_OF_MODES != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					no_of_modes_check ( .error(1'b1) );
		end
		if (THRESHOLD != 3199)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					threshold_check ( .error(1'b1) );
		end
		if (STD_WIDTH != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					std_width_check ( .error(1'b1) );
		end
		if (GENERATE_SYNC != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					generate_sync_check ( .error(1'b1) );
		end
		if (USE_EMBEDDED_SYNCS != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_embedded_syncs_check ( .error(1'b1) );
		end
		if (AP_LINE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					ap_line_check ( .error(1'b1) );
		end
		if (V_BLANK != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					v_blank_check ( .error(1'b1) );
		end
		if (H_BLANK != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					h_blank_check ( .error(1'b1) );
		end
		if (H_SYNC_LENGTH != 96)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					h_sync_length_check ( .error(1'b1) );
		end
		if (H_FRONT_PORCH != 16)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					h_front_porch_check ( .error(1'b1) );
		end
		if (H_BACK_PORCH != 49)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					h_back_porch_check ( .error(1'b1) );
		end
		if (V_SYNC_LENGTH != 2)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					v_sync_length_check ( .error(1'b1) );
		end
		if (V_FRONT_PORCH != 10)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					v_front_porch_check ( .error(1'b1) );
		end
		if (V_BACK_PORCH != 33)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					v_back_porch_check ( .error(1'b1) );
		end
		if (F_RISING_EDGE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					f_rising_edge_check ( .error(1'b1) );
		end
		if (F_FALLING_EDGE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					f_falling_edge_check ( .error(1'b1) );
		end
		if (FIELD0_V_RISING_EDGE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_v_rising_edge_check ( .error(1'b1) );
		end
		if (FIELD0_V_BLANK != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_v_blank_check ( .error(1'b1) );
		end
		if (FIELD0_V_SYNC_LENGTH != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_v_sync_length_check ( .error(1'b1) );
		end
		if (FIELD0_V_FRONT_PORCH != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_v_front_porch_check ( .error(1'b1) );
		end
		if (FIELD0_V_BACK_PORCH != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_v_back_porch_check ( .error(1'b1) );
		end
		if (ANC_LINE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					anc_line_check ( .error(1'b1) );
		end
		if (FIELD0_ANC_LINE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_anc_line_check ( .error(1'b1) );
		end
		if (SRC_WIDTH != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					src_width_check ( .error(1'b1) );
		end
		if (DST_WIDTH != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					dst_width_check ( .error(1'b1) );
		end
		if (CONTEXT_WIDTH != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					context_width_check ( .error(1'b1) );
		end
		if (TASK_WIDTH != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					task_width_check ( .error(1'b1) );
		end
	endgenerate

	alt_vip_video_input_bridge #(
		.BITS_PER_SYMBOL              (8),
		.NUMBER_OF_COLOR_PLANES       (3),
		.COLOR_PLANES_ARE_IN_PARALLEL (1),
		.PIXELS_IN_PARALLEL           (1),
		.DEFAULT_LINE_LENGTH          (3200),
		.VIDEO_PROTOCOL_NO            (1),
		.RESP_SRC_ADDRESS             (1),
		.RESP_DST_ADDRESS             (1),
		.DATA_SRC_ADDRESS             (2),
		.SRC_WIDTH                    (8),
		.DST_WIDTH                    (8),
		.CONTEXT_WIDTH                (8),
		.TASK_WIDTH                   (8)
	) video_in (
		.clock                       (main_clock_clk),                    //    main_clock.clk
		.reset                       (main_reset_reset),                  //    main_reset.reset
		.av_st_cmd_valid             (scheduler_cmd_vib_valid),           //     av_st_cmd.valid
		.av_st_cmd_startofpacket     (scheduler_cmd_vib_startofpacket),   //              .startofpacket
		.av_st_cmd_endofpacket       (scheduler_cmd_vib_endofpacket),     //              .endofpacket
		.av_st_cmd_data              (scheduler_cmd_vib_data),            //              .data
		.av_st_cmd_ready             (scheduler_cmd_vib_ready),           //              .ready
		.av_st_resp_valid            (video_in_av_st_resp_valid),         //    av_st_resp.valid
		.av_st_resp_startofpacket    (video_in_av_st_resp_startofpacket), //              .startofpacket
		.av_st_resp_endofpacket      (video_in_av_st_resp_endofpacket),   //              .endofpacket
		.av_st_resp_data             (video_in_av_st_resp_data),          //              .data
		.av_st_resp_ready            (video_in_av_st_resp_ready),         //              .ready
		.av_st_dout_valid            (video_in_av_st_dout_valid),         //    av_st_dout.valid
		.av_st_dout_startofpacket    (video_in_av_st_dout_startofpacket), //              .startofpacket
		.av_st_dout_endofpacket      (video_in_av_st_dout_endofpacket),   //              .endofpacket
		.av_st_dout_data             (video_in_av_st_dout_data),          //              .data
		.av_st_dout_ready            (video_in_av_st_dout_ready),         //              .ready
		.av_st_vid_din_data          (din_data),                          // av_st_vid_din.data
		.av_st_vid_din_valid         (din_valid),                         //              .valid
		.av_st_vid_din_startofpacket (din_startofpacket),                 //              .startofpacket
		.av_st_vid_din_endofpacket   (din_endofpacket),                   //              .endofpacket
		.av_st_vid_din_ready         (din_ready)                          //              .ready
	);

	alt_vip_cvo_scheduler #(
		.SRC_WIDTH     (8),
		.DST_WIDTH     (8),
		.CONTEXT_WIDTH (8),
		.TASK_WIDTH    (8)
	) scheduler (
		.clock                            (main_clock_clk),                         //         main_clock.clk
		.reset                            (main_reset_reset),                       //         main_reset.reset
		.cmd_vib_valid                    (scheduler_cmd_vib_valid),                //            cmd_vib.valid
		.cmd_vib_startofpacket            (scheduler_cmd_vib_startofpacket),        //                   .startofpacket
		.cmd_vib_endofpacket              (scheduler_cmd_vib_endofpacket),          //                   .endofpacket
		.cmd_vib_data                     (scheduler_cmd_vib_data),                 //                   .data
		.cmd_vib_ready                    (scheduler_cmd_vib_ready),                //                   .ready
		.cmd_mark_valid                   (scheduler_cmd_mark_valid),               //           cmd_mark.valid
		.cmd_mark_startofpacket           (scheduler_cmd_mark_startofpacket),       //                   .startofpacket
		.cmd_mark_endofpacket             (scheduler_cmd_mark_endofpacket),         //                   .endofpacket
		.cmd_mark_data                    (scheduler_cmd_mark_data),                //                   .data
		.cmd_mark_ready                   (scheduler_cmd_mark_ready),               //                   .ready
		.cmd_mode_banks_valid             (scheduler_cmd_mode_banks_valid),         //     cmd_mode_banks.valid
		.cmd_mode_banks_startofpacket     (scheduler_cmd_mode_banks_startofpacket), //                   .startofpacket
		.cmd_mode_banks_endofpacket       (scheduler_cmd_mode_banks_endofpacket),   //                   .endofpacket
		.cmd_mode_banks_data              (scheduler_cmd_mode_banks_data),          //                   .data
		.cmd_mode_banks_ready             (scheduler_cmd_mode_banks_ready),         //                   .ready
		.cmd_control_slave_valid          (),                                       //  cmd_control_slave.valid
		.cmd_control_slave_startofpacket  (),                                       //                   .startofpacket
		.cmd_control_slave_endofpacket    (),                                       //                   .endofpacket
		.cmd_control_slave_data           (),                                       //                   .data
		.cmd_control_slave_ready          (),                                       //                   .ready
		.resp_vib_valid                   (video_in_av_st_resp_valid),              //           resp_vib.valid
		.resp_vib_startofpacket           (video_in_av_st_resp_startofpacket),      //                   .startofpacket
		.resp_vib_endofpacket             (video_in_av_st_resp_endofpacket),        //                   .endofpacket
		.resp_vib_data                    (video_in_av_st_resp_data),               //                   .data
		.resp_vib_ready                   (video_in_av_st_resp_ready),              //                   .ready
		.resp_control_slave_valid         (),                                       // resp_control_slave.valid
		.resp_control_slave_startofpacket (),                                       //                   .startofpacket
		.resp_control_slave_endofpacket   (),                                       //                   .endofpacket
		.resp_control_slave_data          (),                                       //                   .data
		.resp_control_slave_ready         (),                                       //                   .ready
		.resp_mode_banks_valid            (cvo_core_resp_mode_banks_valid),         //    resp_mode_banks.valid
		.resp_mode_banks_startofpacket    (cvo_core_resp_mode_banks_startofpacket), //                   .startofpacket
		.resp_mode_banks_endofpacket      (cvo_core_resp_mode_banks_endofpacket),   //                   .endofpacket
		.resp_mode_banks_data             (cvo_core_resp_mode_banks_data),          //                   .data
		.resp_mode_banks_ready            (cvo_core_resp_mode_banks_ready)          //                   .ready
	);

	alt_vip_cvo_core #(
		.NUMBER_OF_COLOUR_PLANES       (3),
		.COLOUR_PLANES_ARE_IN_PARALLEL (1),
		.BPS                           (8),
		.INTERLACED                    (0),
		.H_ACTIVE_PIXELS               (640),
		.V_ACTIVE_LINES                (480),
		.ACCEPT_COLOURS_IN_SEQ         (0),
		.FIFO_DEPTH                    (3200),
		.CLOCKS_ARE_SAME               (0),
		.USE_CONTROL                   (0),
		.NO_OF_MODES                   (1),
		.THRESHOLD                     (3199),
		.STD_WIDTH                     (1),
		.GENERATE_SYNC                 (0),
		.USE_EMBEDDED_SYNCS            (0),
		.AP_LINE                       (0),
		.V_BLANK                       (0),
		.H_BLANK                       (0),
		.H_SYNC_LENGTH                 (96),
		.H_FRONT_PORCH                 (16),
		.H_BACK_PORCH                  (49),
		.V_SYNC_LENGTH                 (2),
		.V_FRONT_PORCH                 (10),
		.V_BACK_PORCH                  (33),
		.F_RISING_EDGE                 (0),
		.F_FALLING_EDGE                (0),
		.FIELD0_V_RISING_EDGE          (0),
		.FIELD0_V_BLANK                (0),
		.FIELD0_V_SYNC_LENGTH          (0),
		.FIELD0_V_FRONT_PORCH          (0),
		.FIELD0_V_BACK_PORCH           (0),
		.ANC_LINE                      (0),
		.FIELD0_ANC_LINE               (0),
		.PIXELS_IN_PARALLEL            (1),
		.UHD_MODE                      (1),
		.SRC_WIDTH                     (8),
		.DST_WIDTH                     (8),
		.CONTEXT_WIDTH                 (8),
		.TASK_WIDTH                    (8)
	) cvo_core (
		.is_clk                        (main_clock_clk),                         //        main_clock.clk
		.rst                           (main_reset_reset),                       //        main_reset.reset
		.cmd_mark_valid                (scheduler_cmd_mark_valid),               //          cmd_mark.valid
		.cmd_mark_startofpacket        (scheduler_cmd_mark_startofpacket),       //                  .startofpacket
		.cmd_mark_endofpacket          (scheduler_cmd_mark_endofpacket),         //                  .endofpacket
		.cmd_mark_data                 (scheduler_cmd_mark_data),                //                  .data
		.cmd_mark_ready                (scheduler_cmd_mark_ready),               //                  .ready
		.cmd_mode_banks_valid          (scheduler_cmd_mode_banks_valid),         //    cmd_mode_banks.valid
		.cmd_mode_banks_startofpacket  (scheduler_cmd_mode_banks_startofpacket), //                  .startofpacket
		.cmd_mode_banks_endofpacket    (scheduler_cmd_mode_banks_endofpacket),   //                  .endofpacket
		.cmd_mode_banks_data           (scheduler_cmd_mode_banks_data),          //                  .data
		.cmd_mode_banks_ready          (scheduler_cmd_mode_banks_ready),         //                  .ready
		.resp_mode_banks_valid         (cvo_core_resp_mode_banks_valid),         //   resp_mode_banks.valid
		.resp_mode_banks_startofpacket (cvo_core_resp_mode_banks_startofpacket), //                  .startofpacket
		.resp_mode_banks_endofpacket   (cvo_core_resp_mode_banks_endofpacket),   //                  .endofpacket
		.resp_mode_banks_data          (cvo_core_resp_mode_banks_data),          //                  .data
		.resp_mode_banks_ready         (cvo_core_resp_mode_banks_ready),         //                  .ready
		.status_update_int             (status_update_irq_irq),                  // status_update_irq.irq
		.av_st_din_valid               (video_in_av_st_dout_valid),              //         av_st_din.valid
		.av_st_din_startofpacket       (video_in_av_st_dout_startofpacket),      //                  .startofpacket
		.av_st_din_endofpacket         (video_in_av_st_dout_endofpacket),        //                  .endofpacket
		.av_st_din_data                (video_in_av_st_dout_data),               //                  .data
		.av_st_din_ready               (video_in_av_st_dout_ready),              //                  .ready
		.vid_clk                       (clocked_video_vid_clk),                  //     clocked_video.export
		.vid_data                      (clocked_video_vid_data),                 //                  .export
		.underflow                     (clocked_video_underflow),                //                  .export
		.vid_datavalid                 (clocked_video_vid_datavalid),            //                  .export
		.vid_v_sync                    (clocked_video_vid_v_sync),               //                  .export
		.vid_h_sync                    (clocked_video_vid_h_sync),               //                  .export
		.vid_f                         (clocked_video_vid_f),                    //                  .export
		.vid_h                         (clocked_video_vid_h),                    //                  .export
		.vid_v                         (clocked_video_vid_v)                     //                  .export
	);

endmodule
