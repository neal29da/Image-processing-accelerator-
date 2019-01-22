interface if_processing(input bit clk, rst_n);
    
    logic [1:0] slvx_mode;
    bit slvx_data_valid, fifo_empty, wr, mstr_data_cmplt;
    logic [7:0] slvx_proc_val;
    logic [D_WIDTH - 1 : 0] slvx_data, data_out;
        
  modport DUT(input rst_n, clk, slvx_data_valid, fifo_empty, slvx_mode, slvx_proc_val,slvx_data, output wr, mstr_data_cmplt, data_out );

endinterface
