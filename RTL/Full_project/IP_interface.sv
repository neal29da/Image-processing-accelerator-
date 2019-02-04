interface IP_interface(input bit clk, rst_n);
  //  parameter DW = 32;


    logic     [1:0]  	slv0_mode;
    logic     [1:0]  	slv1_mode;
    logic        		slv0_data_valid;
    logic       		slv1_data_valid;
    logic     [7:0]   	slv0_proc_valid;
    logic     [7:0]   	slv1_proc_valid;
    logic     [DW-1:0]  slv0_data;
    logic     [DW-1:0]  slv1_data;
    logic      		    slv0_ready;
    logic      		    slv1_ready;
    logic     [DW-1:0]  mstr0_data;
    logic               mstr0_ready;
    logic     [1:0]	    mstr0_data_valid;

 //internal signals   
    
    logic     [1:0]  	slvx_mode;
    logic      		    slvx_data_valid;
    logic     [7:0]   	slvx_proc_val;
    logic     [DW-1:0]  slvx_data;
    logic               wr;
    logic               fifo_full;
    logic               fifo_empty;
    logic               fifo_threshold;
    logic     [DW-1:0]  data_fifo;
    logic           	data_valid;
    logic           	data_source;
    logic       		mstr0_cmplt;
    logic       		proc_cmplt;


    //****************IP MODULE
    modport DUT_IP(		        input       rst_n,
                                input       clk,
                                input       slv0_mode,
                                input       slv1_mode,
                                input       slv0_data_valid,
                                input       slv1_data_valid,
                                input       slv0_proc_valid,
                                input       slv1_proc_valid,
                                input       slv0_data,
                                input       slv1_data,
                                output      slv0_ready,
                                output	    slv1_ready,
                                output      mstr0_data,
                                output	    mstr0_data_valid,
                                output      mstr0_ready

    
    );
    
    //****************Processing MODULE 

    modport DUT_PROCESSING( input    rst_n,
                            input        clk,
                            input        slvx_data_valid,
                            input        fifo_empty,
                            input        slvx_mode,
                            input        slvx_proc_val,
                            input        slvx_data,
                            output  wr,
                            output       proc_cmplt,
                            output       data_fifo
  
                                );


    //****************Arbiter MODULE
    

    modport DUT_ARBITER (       input       proc_cmplt,
                                input       fifo_full,
                                input       fifo_threshold,
                                input       fifo_empty,
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
                                output      slv1_ready,
                                output      data_source,
                                output      mstr0_cmplt
			      
            );

   
    //****************FIFO MODULE

modport DUT_FIFO (  input       wr,
                    input       mstr0_ready,
                    input    	rst_n,
                    input       clk,
                    input       data_fifo,
                    output      fifo_full,
                    output      fifo_empty,
                    output      mstr0_data,
                    output	data_valid

                );

                
modport DUT_MEM_ARR (
                    input       clk,
                    input       data_fifo,
                    output      mstr0_data
);

modport DUT_READ_POI (
                    input       clk,
                    input       rst_n,
                    input       mstr0_ready,
                    input       fifo_empty
);

modport DUT_STATUS  (
                    input       clk,
                    input       rst_n,
                    input       mstr0_ready,
                    input       wr,
                    output      fifo_full,
                    output      fifo_empty,
                    output	    data_valid,
                    output      fifo_threshold
);
modport DUT_WR_POI (
                    input       clk,
                    input       wr,
                    input       rst_n,
                    input       fifo_full

);
                
endinterface
