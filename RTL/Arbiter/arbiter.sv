module arbiter(IP_interface.DUT_ARBITER arb_if);
  parameter DW = 32;
  bit waitend;
  logic [1:0] end_count;  
   always @ (posedge arb_if.clk ) begin
      if(arb_if.proc_cmplt == 1'b1) begin
         waitend = 1;
         end_count = 2'b10;
end
    end
  always @ (posedge arb_if.clk ) begin
      if(end_count > 0)
         end_count = end_count - 2'b01;
    end
    
   always @ (posedge arb_if.clk ) begin
      if(waitend && arb_if.fifo_empty && !end_count) begin
         arb_if.mstr0_cmplt = 1;
	 arb_if.data_source = 0; 
         waitend = 0;
      end else arb_if.mstr0_cmplt = 0;
    end
  
  
  always @ (posedge arb_if.clk or negedge arb_if.rst_n)
    if(! arb_if.rst_n) begin
	end_count = 0;
       arb_if.slvx_mode=0;
       arb_if.slvx_data_valid = 0;
       arb_if.slv0_ready = 0;
       arb_if.slv1_ready = 0;
       arb_if.slvx_proc_val = 0;
       arb_if.data_source = 0;
       arb_if.mstr0_cmplt = 0;
       waitend = 0;
      end
    else if ((~arb_if.data_source || (arb_if.slv1_mode == 0)) && arb_if.slv0_mode && ~ arb_if.fifo_full && ~waitend && ~arb_if.proc_cmplt) begin
        arb_if.slv0_ready = 1;
        arb_if.slv1_ready = 0;
        arb_if.data_source = 0;

            if(arb_if.slv0_data_valid) begin
              arb_if.slvx_mode = arb_if.slv0_mode;
              arb_if.slvx_data_valid = arb_if.slv0_data_valid;
              arb_if.slvx_proc_val = arb_if.slv0_proc_valid;
              arb_if.slvx_data = arb_if.slv0_data;
        end
        else begin
        arb_if.slvx_data <= 0;
        arb_if.slvx_data_valid = arb_if.slv0_data_valid;
        end
    end
    else if (arb_if.slv1_mode && ~ arb_if.fifo_full && ~waitend && ~arb_if.proc_cmplt) begin
    arb_if.slv0_ready = 0;
    arb_if.slv1_ready = 1;
    arb_if.data_source = 1;

      if(arb_if.slv1_data_valid) begin
          arb_if.slvx_mode = arb_if.slv1_mode;
          arb_if.slvx_data_valid = arb_if.slv1_data_valid;
          arb_if.slvx_proc_val = arb_if.slv1_proc_valid;
          arb_if.slvx_data = arb_if.slv1_data;
          end
      else begin
       arb_if.slvx_data <= 0;
       arb_if.slvx_data_valid = arb_if.slv1_data_valid;
       end    
    end else begin
       arb_if.slvx_data_valid = 0;
    end
  always @ (posedge arb_if.clk ) begin
    if(arb_if.fifo_full) begin
      arb_if.slv0_ready = 0;
      arb_if.slv1_ready = 0;
     // arb_if.slvx_mode = 0;
      arb_if.slvx_data_valid = 0;
      end
      // ready_fifo is 0, so ready signal before fifo_full is slv1_ready =1 and vice verca
  end

  always @ (posedge arb_if.clk ) begin
    if (!waitend && !arb_if.proc_cmplt) begin
    if (arb_if.slv0_mode == 2'b00)  begin
      arb_if.slv0_ready = 0;
      if (arb_if.slv1_mode != 2'b00) begin
	arb_if.data_source = 1;

      end
      end
    if (arb_if.slv1_mode == 2'b00) begin
      arb_if.slv1_ready = 0;
      arb_if.data_source = 0;

    end
    end
    end
  always @ (posedge arb_if.clk ) begin
      if (waitend || arb_if.proc_cmplt) begin
      arb_if.slvx_mode=0;
      arb_if.slvx_data_valid = 0;
      arb_if.slv0_ready = 0;
      arb_if.slv1_ready = 0;
      arb_if.slvx_proc_val = 0;
      end
      end
endmodule

