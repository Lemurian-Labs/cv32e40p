module synth_cv32e40p_tb_subsystem #(
				     parameter INSTR_RDATA_WIDTH = 32,
				     parameter RAM_ADDR_WIDTH = 20,
				     parameter BOOT_ADDR = 'h180,
				     parameter PULP_XPULP = 0,
				     parameter PULP_CLUSTER = 0,
				     parameter FPU = 0,
				     parameter FPU_ADDMUL_LAT = 0,
				     parameter FPU_OTHERS_LAT = 0,
				     parameter ZFINX = 0,
				     parameter NUM_MHPMCOUNTERS = 1,
				     parameter DM_HALTADDRESS = 32'h1A110800
				     ) (
					input logic 	    clk_i,
					input logic 	    rst_ni,
					input logic 	    fetch_enable_i,
					output logic 	    tests_passed_o,
					output logic 	    tests_failed_o,
					output logic [31:0] exit_value_o,
					output logic 	    exit_valid_o,
					// akaul
					output logic [31:0] csr_wdata,
					output logic 	    alu_en_ex
					// akaul   
					);
  
  // signals connecting core to memory
  logic 			instr_req;
  logic 			instr_gnt;
  logic 			instr_rvalid;
  logic [31:0] 			instr_addr;
  logic [INSTR_RDATA_WIDTH-1:0] instr_rdata;
  logic 			data_req;
  logic 			data_gnt;
  logic 			data_rvalid;
  logic [31:0] 			data_addr;
  logic 			data_we;
  logic [3:0] 			data_be;
  logic [31:0] 			data_rdata;
  logic [31:0] 			data_wdata;
  logic [5:0] 			data_atop;
  // signals to debug unit
  logic 			debug_req_i;
  // irq signals
  logic 			irq_ack;
  logic [4:0] 			irq_id_out;
  logic 			irq_software;
  logic 			irq_timer;
  logic 			irq_external;
  logic [15:0] 			irq_fast;
  logic 			core_sleep_o;

  assign data_atop = 6'b0;
  assign debug_req_i = 1'b0;

  // instantiate the core
  cv32e40p_top #(
		 .COREV_PULP      (PULP_XPULP),
		 .COREV_CLUSTER    (PULP_CLUSTER),
		 .FPU             (FPU),
		 .FPU_ADDMUL_LAT  (FPU_ADDMUL_LAT),
		 .FPU_OTHERS_LAT  (FPU_OTHERS_LAT),
		 .ZFINX           (ZFINX),
		 .NUM_MHPMCOUNTERS(NUM_MHPMCOUNTERS)
		 ) 
  top_i (
	 .clk_i              (clk_i),
	 .rst_ni             (rst_ni),
	 .pulp_clock_en_i    (1'b1),
	 .scan_cg_en_i       (1'b0),
	 .boot_addr_i        (BOOT_ADDR),
	 .mtvec_addr_i       (32'h0),
	 .dm_halt_addr_i     (DM_HALTADDRESS),
	 .hart_id_i          (32'h0),
	 .dm_exception_addr_i(32'h0),
	 .instr_addr_o       (instr_addr),
	 .instr_req_o        (instr_req),
	 .instr_rdata_i      (instr_rdata),
	 .instr_gnt_i        (instr_gnt),
	 .instr_rvalid_i     (instr_rvalid),
	 .data_addr_o        (data_addr),
	 .data_wdata_o       (data_wdata),
	 .data_we_o          (data_we),
	 .data_req_o         (data_req),
	 .data_be_o          (data_be),
	 .data_rdata_i       (data_rdata),
	 .data_gnt_i         (data_gnt),
	 .data_rvalid_i      (data_rvalid),
	 .irq_i              ({irq_fast, 4'b0, irq_external, 3'b0, irq_timer, 3'b0, irq_software, 3'b0}),
	 .irq_ack_o          (irq_ack),
	 .irq_id_o           (irq_id_out),
	 .debug_req_i        (debug_req_i),
	 .debug_havereset_o  (),
	 .debug_running_o    (),
	 .debug_halted_o     (),
         .fetch_enable_i     (fetch_enable_i),
         .core_sleep_o       (core_sleep_o),
	 // akaul
	 .csr_wdata          (csr_wdata),
	 .alu_en_ex          (alu_en_ex)
	 // akaul	   
	 );



  // this handles read to RAM and memory mapped pseudo peripherals
  synth_mm_ram #(
		 .RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
		 .INSTR_RDATA_WIDTH(INSTR_RDATA_WIDTH)
		 ) 
  synth_mm_ram (
		.clk         (clk_i),
		.rst_n       (rst_ni),		  
		.instr_req   (instr_req),
		.instr_addr  (instr_addr[RAM_ADDR_WIDTH-1:0]),
		.instr_rdata (instr_rdata),
		.instr_rvalid(instr_rvalid),
		.instr_gnt   (instr_gnt),
		.data_req    (data_req),
		.data_addr   (data_addr),
		.data_we     (data_we),
		.data_be     (data_be),
		.data_wdata  (data_wdata),
		.data_rdata  (data_rdata),
		.data_rvalid (data_rvalid),
		.data_gnt    (data_gnt),
		.data_atop   (data_atop),
		.irq_id      (irq_id_out),
		.irq_ack     (irq_ack),	  
		// output irq lines to Core
		.irq_software(irq_software),
		.irq_timer   (irq_timer),
		.irq_external(irq_external),
		.irq_fast    (irq_fast),
		.pc_core_id  ({32{1'b0}}),
		.tests_passed(tests_passed_o),
		.tests_failed(tests_failed_o),
		.exit_valid  (exit_valid_o),
		.exit_value  (exit_value_o)
		);
  
endmodule
