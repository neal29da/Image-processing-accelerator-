interface fifo_if(input bit clk,rst_n);
    logic               wr;
    logic               mstr0_ready;
    logic               fifo_full;
    logic               fifo_empty;
    logic       [D_WIDTH-1:0]   data_fifo;
    logic       [D_WIDTH-1:0]   mstr0_data;
    logic           	data_valid;




modport DUT_FIFO (  input       wr,
                    input       mstr0_ready,
                    input    	rst_n,
                    input       clk,
                    input       data_fifo,
                    output      fifo_full,
                    output      fifo_empty,
                    output      mstr0_data,
                    output      data_valid

                );

endinterface
