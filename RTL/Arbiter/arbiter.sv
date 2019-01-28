module arbiter(arbiter_if.DUT arb_if);
  parameter DW = 32;
  logic [1:0] slvx_mode;
  logic [DW-1:0]  slvx_data;
  logic [7:0]   	slvx_proc_val;
  logic slvx_data_valid;
  logic slv0_ready;
  logic slv1_ready;
  logic ready_fifo;
  logic data_source;
  
  // if data0 = '1' and data
  
  always @ (posedge arb_if.clk or negedge arb_if.rst_n)
    if(! arb_if.rst_n) begin
       arb_if.slvx_mode=0;
       arb_if.slvx_data_valid = 0;
       arb_if.slv0_ready = 0;
       arb_if.slv1_ready = 0;
       arb_if.slvx_proc_val = 0;
       ready_fifo = 0;
      end
    else if (~ ready_fifo && arb_if.slv0_mode && ~ arb_if.fifo_full && ~ arb_if.mstr0_cmplt) begin
        arb_if.slv0_ready = 1;
        arb_if.slv1_ready = 0;
        ready_fifo = 0;
            if(arb_if.slv0_data_valid) begin
              arb_if.slvx_mode = arb_if.slv0_mode;
              arb_if.slvx_data_valid = arb_if.slv0_data_valid;
              arb_if.slvx_proc_val = arb_if.slv0_proc_valid;
              arb_if.slvx_data = arb_if.slv0_data;
              arb_if.data_source = 0;
        end
        else begin
        arb_if.slvx_data <= 0;
        arb_if.slvx_data_valid = arb_if.slv0_data_valid;
        end
    end
    else if (arb_if.slv1_mode && ~ arb_if.fifo_full && ~arb_if.mstr0_cmplt) begin
    arb_if.slv0_ready = 0;
    arb_if.slv1_ready = 1;
    ready_fifo = 1;
      if(arb_if.slv1_data_valid) begin
          arb_if.slvx_mode = arb_if.slv1_mode;
          arb_if.slvx_data_valid = arb_if.slv1_data_valid;
          arb_if.slvx_proc_val = arb_if.slv1_proc_valid;
          arb_if.slvx_data = arb_if.slv1_data;
          arb_if.data_source = 1;
          end
      else begin
       arb_if.slvx_data <= 0;
       arb_if.slvx_data_valid = arb_if.slv1_data_valid;
       end    
    end
  always @ (posedge arb_if.clk ) begin
    if(arb_if.fifo_full) begin
      arb_if.slv0_ready = 0;
      arb_if.slv1_ready = 0;
      arb_if.slvx_mode = 0;
      arb_if.slvx_data_valid = 0;
      end
      // ready_fifo is 0, so ready signal before fifo_full is slv1_ready =1 and vice verca
  end

  always @ (posedge arb_if.mstr0_cmplt ) begin
    if (arb_if.slv0_mode == 2'b00)  begin
      arb_if.slv0_ready = 0;
      end
    if (arb_if.slv1_mode == 2'b00) begin
      arb_if.slv1_ready = 0;
      ready_fifo = 0;
    end
    end
  always @ (posedge arb_if.clk ) begin
    arb_if.slvx_mode=0;
      arb_if.slvx_data_valid = 0;
      arb_if.slv0_ready = 0;
      arb_if.slv1_ready = 0;
      arb_if.slvx_proc_val = 0;
      ready_fifo = 0;
      end
endmodule