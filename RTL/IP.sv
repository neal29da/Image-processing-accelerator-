module IP (IP_interface ip_if)
parameter DW = 32;


  processing #(DW)my_processing (ip_if.DUT_PROCESSING);
  fifo_mem #(DW)my_fifo(ip_if.DUT_FIFO);
  arbiter my_arbiter (ip_if.DUT_ARBITER);
  
assign ip_if.mstr0_data_valid = {ip_if.DUT_ARBITER.data_source, ip_if.DUT_FIFO.data_valid};


endmodule
