interface if_processing(input bit clk);

    bit rst_n;
    
    logic [1:0] slv_mode;
    bit slv_data_valid, fifo_empty, wr, mstr_data_cmplt;
    logic [7:0] slv_proc_val;
    logic [DATA_WIDTH - 1 : 0] slv_data, data_out;
        
    modport DUT (input bit rst_n, clk, slv_data_valid, fifo_empty, input logic [1:0] slv_mode, input logic [7:0] slv_proc_val, input logic [DATA_WIDTH - 1 : 0] slv_data, output bit wr, mstr_data_cmplt, output logic [DATA_WIDTH - 1 : 0] data_out );

endinterface
