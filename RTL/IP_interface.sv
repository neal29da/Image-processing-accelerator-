interface ip_interface(input bit clk, rst_n);

    //****************Processing MODULE 

    logic           [1:0]             slvx_mode;
    bit                               slvx_data_valid;
    logic                             fifo_empty;
    logic                             wr;
    logic                             mstr_data_cmplt;
    logic           [7:0]             slvx_proc_val;
    logic [D_WIDTH - 1 : 0]           slvx_data, data_out;
    

    modport DUT_PROCESSING(input    rst_n,
                                    clk,
                                    slvx_data_valid,
                                    fifo_empty,
                                    slvx_mode,
                                    slvx_proc_val,
                                    slvx_data,
                                    output wr,
                                    mstr_data_cmplt,
                                    data_out 
                                );


    //****************Arbiter MODULE
    parameter DW = 32;
    logic       		mstr0_cmplt;
    logic       		fifo_full;
    logic     [1:0]  	slv0_mode;
    logic     [1:0]  	slv1_mode;
    logic        		slv0_data_valid;
    logic       		slv1_data_valid;
    logic     [7:0]   	slv0_proc_valid;
    logic     [7:0]   	slv1_proc_valid;
    logic     [DW-1:0]  slv0_data;
    logic     [DW-1:0]  slv1_data;
    logic     [1:0]  	slvx_mode;
    logic      		    slvx_data_valid;
    logic     [7:0]   	slvx_proc_val;
    logic     [DW-1:0]  slvx_data;
    logic      		    slv0_ready;
    logic      		    slv1_ready;
    
    //clocking cb @(posedge clk);
    //endclocking

    modport DUT_ARBITER (input              mstr0_cmplt,
                                input       fifo_full,
                                input    	rst_n,
                                input       clk,
                                input       slv0_mode,
                                input       slv1_mode,
                                input       slv0_data_valid,
                                input       slv1_data_valid,
                                input      	slv0_proc_valid,
                                input       slv1_proc_valid,
                                input       slv0_data,
                                input       slv1_data,
                                output      slvx_mode,
                                output      slvx_data_valid,
                                output      slvx_proc_val,
                                output      slvx_data,
                                output      slv0_ready,
                                output      slv1_ready
            );

    // modport TB (    
    //                 input       slvx_mode,
    //                 input       slvx_data_valid,
    //                 input       slvx_proc_val,
    //                 input       slvx_data,
    //                 input       slv0_ready,
    //                 input       slv1_ready,
    //                 input       rst_n,
    //                 input       clk,
    //                 output      mstr0_cmplt,
    //                 output      fifo_full,
    //                 output      slv0_mode,
    //                 output      slv1_mode,
    //                 output      slv0_data_valid,
    //                 output      slv1_data_valid,
    //                 output      slv0_proc_valid,
    //                 output      slv1_proc_valid,
    //                 output      slv0_data,
    //                 output      slv1_data

    //                 );   
    //****************FIFO MODULE

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