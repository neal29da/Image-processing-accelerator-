class scrbrd_arbiter extends uvm_component;
   `uvm_component_utils( scrbrd_arbiter )
 
   uvm_analysis_export  #( trns_ip ) expected_analysis_export;
   uvm_analysis_export  #( trns_ip )   actual_analysis_export;
   uvm_tlm_analysis_fifo#( trns_ip ) expected_fifo_arbiter;
   uvm_tlm_analysis_fifo#( trns_ip )   actual_fifo_arbiter;
 
   // Function: new
   //-------------------------------------------------------------------------
   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new
 
   // Function: build_phase
   //-------------------------------------------------------------------------
   virtual function void build_phase( uvm_phase phase );
      super.build_phase( phase );
 
      expected_analysis_export = new( "expected_analysis_export", this );
        actual_analysis_export = new(   "actual_analysis_export", this );
      expected_fifo_arbiter = new( "expected_fifo_arbiter", this );
        actual_fifo_arbiter = new(   "actual_fifo_arbiter", this );
   endfunction: build_phase
 
   // Function: connect_phase
   //-------------------------------------------------------------------------
   virtual function void connect_phase( uvm_phase phase );
      super.connect_phase( phase );
 
      expected_analysis_export.connect( expected_fifo_arbiter.analysis_export );
        actual_analysis_export.connect(   actual_fifo_arbiter.analysis_export );
   endfunction: connect_phase
 
   // Task: run_phase
   //-------------------------------------------------------------------------
   virtual task run_phase( uvm_phase phase );
      trns_ip exp_trns;
      trns_ip   act_trns;
      trns_ip my_trns;
      int count;
      
      logic [DW-1:0] my_data;
      bit proc_busy;
      bit prev_ready0;
      bit prev_ready1;
      bit wait_fifo;
      forever begin
/*
	  if (count == 0)  begin
	    actual_fifo_arbiter.get_peek_export.get(   act_trns );
	    //act_trns.print();

	  end
*/
         expected_fifo_arbiter.get_peek_export.get( exp_trns );
         actual_fifo_arbiter.get_peek_export.get(   act_trns );
        count = 1;
     //   $display("time: %t", $time); 
        
    //    exp_trns.print();
     //   act_trns.print();
        
        assert (!(act_trns.slv0_ready && act_trns.slv1_ready && exp_trns.rst_n)) else `uvm_error("SCB","assert ready0 & ready1");
        

       if (!exp_trns.rst_n) begin
            if (act_trns.slvx_data_valid != 0) `uvm_error("SCB","wrong reset value");
            if (act_trns.slv0_ready != 0) `uvm_error("SCB","wrong reset value");
            if (act_trns.slv1_ready != 0) `uvm_error("SCB","wrong reset value");
            if (act_trns.slv0_mode != 0) `uvm_error("SCB","wrong reset value");
            if (act_trns.slv1_mode != 0) `uvm_error("SCB","wrong reset value");
            if (act_trns.mstr0_cmplt != 0) `uvm_error("SCB","wrong reset value");

        end else begin 
	     if ((act_trns.slv0_ready || act_trns.slv1_ready) && act_trns.fifo_full) `uvm_error("SCB","assert ready and fifo_full");
	 if (act_trns.mstr0_cmplt) wait_fifo = 0;
	  
     if (wait_fifo & !exp_trns.fifo_empty & act_trns.mstr0_cmplt) begin `uvm_error("SCB","wrong mstr0_cmplt"); 
     end else if (wait_fifo & exp_trns.fifo_empty & !act_trns.mstr0_cmplt) begin `uvm_error("SCB","wrong mstr0_cmplt"); 
        wait_fifo = 0;
     end 
    if (exp_trns.proc_cmplt) begin 
        wait_fifo = 1;
     end   

            if ( wait_fifo || act_trns.mstr0_cmplt) begin	    
                if (act_trns.slv0_ready || act_trns.slv1_ready) `uvm_error("SCB","wrong ready and proc_cmplt");
                if (act_trns.slvx_data_valid || act_trns.slvx_mode) `uvm_error("SCB","wrong valid or mode and proc_cmplt");
            end else if (!exp_trns.fifo_full) begin
	     if ((exp_trns.slv0_mode == 0) && (exp_trns.slv1_mode == 0)) begin
                if (act_trns.slv0_ready || act_trns.slv1_ready) `uvm_error("SCB","wrong ready and mode == 0");
            end else if (exp_trns.slv0_mode != 0 && exp_trns.slv1_mode == 0) begin
                if(!act_trns.slv0_ready) `uvm_error("SCB","wrong ready0");
            end else if ((exp_trns.slv0_mode == 0) && (exp_trns.slv1_mode != 0)) begin
                if(!act_trns.slv1_ready) `uvm_error("SCB","wrong ready1");
            end else if (exp_trns.slv0_mode != 0 && exp_trns.slv1_mode != 0) begin
                if (!prev_ready0 && !prev_ready1) begin
                    if(!act_trns.slv0_ready) `uvm_error("SCB","wrong ready0");
                    if(act_trns.slv1_ready) `uvm_error("SCB","wrong ready1");
                end else if (prev_ready0 && !prev_ready1) begin
                    if(!act_trns.slv0_ready) `uvm_error("SCB","wrong ready0");
                    if(act_trns.slv1_ready) `uvm_error("SCB","wrong ready1");
                end else if (!prev_ready0 && prev_ready1) begin
                    if(act_trns.slv0_ready) `uvm_error("SCB","wrong ready0");
                    if(!act_trns.slv1_ready) `uvm_error("SCB","wrong ready1");
                end 
            end 
	  end else 
	      if (act_trns.slvx_data_valid) `uvm_error("SCB","wrongfifo_full valid");
	  
        //end 

        if (act_trns.slv0_ready && exp_trns.slv0_data_valid) begin
            if (act_trns.slv0_data != act_trns.slvx_data) `uvm_error("SCB","wrong data0");
            if (act_trns.slv0_mode != act_trns.slvx_mode) `uvm_error("SCB","wrong mode0");
            if (act_trns.slv0_proc_valid != act_trns.slvx_proc_val) `uvm_error("SCB","wrong slv0_proc_valid");
            if (act_trns.slv0_data_valid != act_trns.slvx_data_valid) `uvm_error("SCB","wrong valid0");
        end
        if (act_trns.slv1_ready && exp_trns.slv1_data_valid) begin
            if (act_trns.slv1_data != act_trns.slvx_data) `uvm_error("SCB","wrong data1");
            if (act_trns.slv1_mode != act_trns.slvx_mode) `uvm_error("SCB","wrong mode1");
            if (act_trns.slv1_proc_valid != act_trns.slvx_proc_val) `uvm_error("SCB","wrong slv1_proc_valid");
            if (act_trns.slv1_data_valid != act_trns.slvx_data_valid) `uvm_error("SCB","wrong valid1");
        end
        
        if (!exp_trns.slv0_data_valid && !exp_trns.slv1_data_valid) begin
            if (act_trns.slvx_data_valid != 0) `uvm_error("SCB","wrong validx");
        end
        
        if (act_trns.slv1_ready && !act_trns.data_source) begin `uvm_error("SCB","wrong data_source");
        end else if (act_trns.slv0_ready && act_trns.data_source) `uvm_error("SCB","wrong data_source");
         

     
  
	if (!act_trns.mstr0_cmplt) begin
        if (!wait_fifo) begin
        if ((act_trns.slv0_mode != 0) && !prev_ready1)  prev_ready0 = 1;
	else if (act_trns.slv1_mode != 0) prev_ready1 = 1;
	 
	if (act_trns.slv0_mode == 0) prev_ready0 = 0;
	if (act_trns.slv1_mode == 0) prev_ready1 = 0;
	end
	end else begin
	    prev_ready0 = 0;
	    prev_ready1 = 0;
	end
	
	if (prev_ready0 & act_trns.data_source) `uvm_error("SCB","wrong data_source");
	if (prev_ready1 & !act_trns.data_source) `uvm_error("SCB","wrong data_source");

    end
	end
   endtask
   
   endclass
