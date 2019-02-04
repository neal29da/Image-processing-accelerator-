`include "arbiter.sv"
`include "processing.sv"
`include "fifo.sv"


module IP (IP_interface ip_if);
parameter DW = 32;


  processing #(DW)my_processing (ip_if.DUT_PROCESSING);
  fifo_mem #(DW)my_fifo(ip_if.DUT_FIFO, ip_if.DUT_WR_POI, ip_if.DUT_STATUS, ip_if.DUT_MEM_ARR, ip_if.DUT_READ_POI);
  arbiter #(DW)my_arbiter (ip_if.DUT_ARBITER);
  
assign ip_if.mstr0_data_valid = {ip_if.data_source, ip_if.data_valid};


endmodule
