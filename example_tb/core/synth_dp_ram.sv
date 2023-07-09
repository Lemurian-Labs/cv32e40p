module synth_dp_ram #(
		      parameter ADDR_WIDTH = 8,
		      parameter INSTR_RDATA_WIDTH = 128
		      ) (
			 input logic 			      clk,
			 input logic 			      en_a,
			 input logic [ADDR_WIDTH-1:0] 	      addr_a,
			 input logic [31:0] 		      wdata_a,
			 output logic [INSTR_RDATA_WIDTH-1:0] rdata_a,
			 input logic 			      we_a,
			 input logic [3:0] 		      be_a,
			 input logic 			      en_b,
			 input logic [ADDR_WIDTH-1:0] 	      addr_b,
			 input logic [31:0] 		      wdata_b,
			 output logic [31:0] 		      rdata_b,
			 input logic 			      we_b,
			 input logic [3:0] 		      be_b
			 );

  // akaul
  //localparam bytes = 2 ** ADDR_WIDTH;
  localparam bytes = 2 ** 8;

  logic [           7:0] mem [bytes];
  logic [ADDR_WIDTH-1:0] addr_a_int;
  logic [ADDR_WIDTH-1:0] addr_b_int;

  always_comb
    addr_a_int = {addr_a[ADDR_WIDTH-1:2], 2'b0};
  
  always_comb
    addr_b_int = {addr_b[ADDR_WIDTH-1:2], 2'b0};

  always @(posedge clk) begin
    for (int i = 0; i < INSTR_RDATA_WIDTH / 8; i++) begin
      rdata_a[(i*8)+:8] <= mem[addr_a_int+i];
    end

    /* addr_b_i is the actual memory address referenced */
    if (en_b) begin
      /* handle writes */
      if (we_b) begin
        if (be_b[0]) mem[addr_b_int]   <= wdata_b[0+:8];
        if (be_b[1]) mem[addr_b_int+1] <= wdata_b[8+:8];
        if (be_b[2]) mem[addr_b_int+2] <= wdata_b[16+:8];
        if (be_b[3]) mem[addr_b_int+3] <= wdata_b[24+:8];
      end
      /* handle reads */
      else
      begin
        rdata_b[7:0]   <= mem[addr_b_int];
        rdata_b[15:8]  <= mem[addr_b_int+1];
        rdata_b[23:16] <= mem[addr_b_int+2];
        rdata_b[31:24] <= mem[addr_b_int+3];
      end
    end
  end

endmodule
