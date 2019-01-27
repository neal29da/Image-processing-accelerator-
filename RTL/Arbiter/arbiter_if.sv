interface arb_if(input bit clk,rst_n);

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
    logic               data_source;
    
    //clocking cb @(posedge clk);
    //endclocking

    modport TB (    
                    input       slvx_mode,
                    input       slvx_data_valid,
                    input       slvx_proc_val,
                    input       slvx_data,
                    input       slv0_ready,
                    input       slv1_ready,
                    input       rst_n,
                    input       clk,
                    output      mstr0_cmplt,
                    output      fifo_full,
                    output      slv0_mode,
                    output      slv1_mode,
                    output      slv0_data_valid,
                    output      slv1_data_valid,
                    output      slv0_proc_valid,
                    output      slv1_proc_valid,
                    output      slv0_data,
                    output      slv1_data

                    );   


    modport DUT (   input       mstr0_cmplt,
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

endinterface: arb_if
