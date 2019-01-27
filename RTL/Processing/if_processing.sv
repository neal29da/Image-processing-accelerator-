interface if_processing(input bit clk);

    bit rst_n;
    
  logic [1:0] slvx_mode;
    bit slvx_data_valid, fifo_empty, wr, mstr0_cmplt;
  logic [7:0] slvx_proc_val;
  logic [DW - 1 : 0] slvx_data, data_fifo;
        
  modport DUT_PROCESSING(input rst_n, clk, slvx_data_valid, fifo_empty, slvx_mode, slvx_proc_val,slvx_data, output wr, mstr0_cmplt, data_fifo );

endinterface
