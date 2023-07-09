module synth_mm_ram #(
		      parameter RAM_ADDR_WIDTH = 16,
		      parameter INSTR_RDATA_WIDTH = 128
		      ) (
			 input logic 			      clk,
			 input logic 			      rst_n,	
			 input logic 			      instr_req,
			 input logic [ RAM_ADDR_WIDTH-1:0]    instr_addr,
			 output logic [INSTR_RDATA_WIDTH-1:0] instr_rdata,
			 output logic 			      instr_rvalid,
			 output logic 			      instr_gnt,
			 input logic 			      data_req,
			 input logic [31:0] 		      data_addr,
			 input logic 			      data_we,
			 input logic [ 3:0] 		      data_be,
			 input logic [31:0] 		      data_wdata,
			 output logic [31:0] 		      data_rdata,
			 output logic 			      data_rvalid,
			 output logic 			      data_gnt,
			 input logic [ 5:0] 		      data_atop,
			 input logic [4:0] 		      irq_id,
			 input logic 			      irq_ack,
			 output logic 			      irq_software,
			 output logic 			      irq_timer,
			 output logic 			      irq_external,
			 output logic [15:0] 		      irq_fast,
			 input logic [31:0] 		      pc_core_id,
			 output logic 			      tests_passed,
			 output logic 			      tests_failed,
			 output logic 			      exit_valid,
			 output logic [31:0] 		      exit_value
			 );


  synth_dp_ram #(
		 .ADDR_WIDTH(RAM_ADDR_WIDTH),
		 .INSTR_RDATA_WIDTH(INSTR_RDATA_WIDTH)
		 ) 
  synth_dp_ram (
		.clk    (clk),
		.en_a   (instr_req),
		.addr_a (instr_addr),
		.wdata_a('0),
		.rdata_a(instr_rdata),
		.we_a   ('0),
		.be_a   (4'b1111),
		.en_b   (data_req),
		.addr_b (data_addr[RAM_ADDR_WIDTH-1:0]),
		.wdata_b(data_wdata[31:0]),
		.rdata_b(data_rdata),
		.we_b   (data_we),
		.be_b   (data_be[3:0])
		);

  assign tests_passed = 1'b0;
  assign tests_failed = 1'b0;
  assign exit_valid   = 1'b0;
  assign exit_value   = {32{1'b0}};
  assign irq_software = 1'b0;
  assign irq_timer    = 1'b0;
  assign irq_external = 1'b0;
  assign irq_fast     = {16{1'b0}};
  assign instr_gnt    = 1'b1;
  assign data_gnt     = 1'b1;

  always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      instr_rvalid <= '0;
      data_rvalid  <= '0;
    end
    else begin       
      instr_rvalid <= instr_req;
      data_rvalid  <= data_req;
    end
  end

endmodule
