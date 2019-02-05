class trns_ip extends uvm_sequence_item;
   
    bit rst_n;
    logic                       mstr0_cmplt;
    rand logic     [1:0]        slv0_mode;
    rand logic     [1:0]  	    slv1_mode;
    rand logic        		    slv0_data_valid;
    rand logic       		    slv1_data_valid;
    rand logic     [7:0]        slv0_proc_valid;
    rand logic     [7:0]   	    slv1_proc_valid;
    rand logic          [DW-1:0]     slv0_data;
    rand logic          [DW-1:0]     slv1_data;
    logic      		            slv0_ready;
    logic      		            slv1_ready;
    logic          [DW-1:0]     mstr0_data;
    rand logic                  mstr0_ready;
    logic          [1:0]        mstr0_data_valid;
    rand int                    slv0_image;
    rand int                    slv1_image;
    
        
    logic     [1:0]  	slvx_mode;
    logic      		    slvx_data_valid;
    logic     [7:0]   	slvx_proc_val;
    logic     [DW-1:0]  slvx_data;
    logic               wr;
    logic               fifo_full;
    logic               fifo_empty;
    logic     [DW-1:0]  data_fifo;
    logic           	data_valid;
    logic           	data_source;
    logic       		proc_cmplt;
    
    
    constraint trans_mode_basic {
      slv0_mode inside {2'b00, 2'b01, 2'b10};
      slv1_mode inside {2'b00, 2'b01, 2'b10};
      slv0_mode dist {2'b00 := 5, 2'b01 := 5, 2'b10 := 5};
      slv1_mode dist {2'b00 := 1, 2'b10 := 5, 2'b01 := 5};
      slv0_data_valid dist {1'b0 := 1, 1'b1 := 10};
      slv1_data_valid dist {1'b0 := 1, 1'b1 := 10};
      slv0_proc_valid dist {8'h00 := 1, [8'h01 : 8'hfe] := 10, 8'hff := 1};
      slv1_proc_valid dist {8'h00 := 1, [8'h01 : 8'hfe] := 10, 8'hff := 1};
      mstr0_ready  dist {1'b0 := 1, 1'b1 := 5};

    }
	

    constraint images_count {
       slv0_image inside {1, 50};
       slv1_image inside {51, 100};
    }

  
  
  
    
    function new(string name = "");
        super.new(name);
    endfunction
  

  
  `uvm_object_utils_begin(trns_ip)
  `uvm_field_int(rst_n, UVM_ALL_ON)
  `uvm_field_int(mstr0_cmplt, UVM_ALL_ON)
  `uvm_field_int(slv0_mode, UVM_ALL_ON)
  `uvm_field_int(slv0_data_valid, UVM_ALL_ON)
  `uvm_field_int(slv0_data, UVM_ALL_ON)
  `uvm_field_int(slv0_proc_valid, UVM_ALL_ON)
  `uvm_field_int(slv1_mode, UVM_ALL_ON)
  `uvm_field_int(slv1_data, UVM_ALL_ON)
  `uvm_field_int(slv1_data_valid, UVM_ALL_ON)
  `uvm_field_int(slv1_proc_valid, UVM_ALL_ON)
  `uvm_field_int(mstr0_ready, UVM_ALL_ON)
  `uvm_field_int(mstr0_data, UVM_ALL_ON)
  `uvm_field_int(mstr0_data_valid, UVM_ALL_ON)
  `uvm_field_int(slv0_ready, UVM_ALL_ON)
  `uvm_field_int(slv1_ready, UVM_ALL_ON)

  `uvm_object_utils_end
    
endclass
