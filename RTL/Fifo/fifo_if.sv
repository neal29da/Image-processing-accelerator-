interface fifo_if(input bit clk,rst_n);
    logic               wr;
    logic               rd;
    logic               fifo_full;
    logic               fifo_empty;
    logic       [7:0]   data_in;
    logic       [7:0]   data_out;



modport DUT_FIFO (  input       wr,
                    input       rd,
                    input    	rst_n,
                    input       clk,
                    input       data_in,
                    output      fifo_full,
                    output      fifo_empty,
                    output      data_out

                );

modport DUT_MEM_ARR (
                    input       clk,
                    input       data_in,
                    output      data_out
);

modport DUT_READ_POI (
                    input       clk,
                    input       rst_n,
                    input       rd,
                    input       fifo_full
);

modport DUT_STATUS  (
                    input       clk,
                    input       rst_n,
                    input       rd,
                    input       wr,
                    output      fifo_full,
                    output      fifo_empty
);
modport DUT_WR_POI (
                    input       clk,
                    input       wr,
                    input       rst_n,
                    input       fifo_full

);
endinterface