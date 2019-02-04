class scrbrd_fifo extends uvm_component;
   `uvm_component_utils( scrbrd_fifo )
 
   uvm_analysis_export  #( trns_ip ) expected_analysis_export;
   uvm_analysis_export  #( trns_ip )   actual_analysis_export;
   uvm_tlm_analysis_fifo#( trns_ip ) expected_fifo_fifo;
   uvm_tlm_analysis_fifo#( trns_ip )   actual_fifo_fifo;
 
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
      expected_fifo_fifo = new( "expected_fifo_fifo", this );
        actual_fifo_fifo = new(   "actual_fifo_fifo", this );
   endfunction: build_phase
 
   // Function: connect_phase
   //-------------------------------------------------------------------------
   virtual function void connect_phase( uvm_phase phase );
      super.connect_phase( phase );
 
      expected_analysis_export.connect( expected_fifo_fifo.analysis_export );
        actual_analysis_export.connect(   actual_fifo_fifo.analysis_export );
   endfunction: connect_phase
 
   // Task: run_phase
   //-------------------------------------------------------------------------
   virtual task run_phase( uvm_phase phase );
      trns_ip expected_trns_ip;
      trns_ip   actual_trns_ip;
      trns_ip my_trns;
      int count;
     //logic [7:0] fifo_depth = 1<<D_WIDTH;
     logic [DW-1:0] my_queue [$:FD-1];
     logic [DW-1:0] my_data;
     bit fifo_full;
     bit fifo_empty = 1;
      forever begin
/*
	  if (count == 0)  begin
	    actual_fifo_fifo.get_peek_export.get(   actual_trns_ip );
	    //$display("count: %d", count);
	    //actual_trns_ip.print();

	  end
*/
         expected_fifo_fifo.get_peek_export.get( expected_trns_ip );
         actual_fifo_fifo.get_peek_export.get(   actual_trns_ip );
	count = 1;
     //   $display("time: %t", $time);   
     //   expected_trns_ip.print();
     //   actual_trns_ip.print();

	if (expected_trns_ip.rst_n) begin

        if (expected_trns_ip.wr & expected_trns_ip.mstr0_ready) begin
            my_queue.push_back(expected_trns_ip.data_fifo);
            my_data = my_queue.pop_front();
            if (my_data !== actual_trns_ip.mstr0_data) `uvm_error("SCB","wrong mstr0_data")
        end else if (expected_trns_ip.wr & !expected_trns_ip.mstr0_ready) begin
            if (!fifo_full) my_queue.push_back(expected_trns_ip.data_fifo);
        end else if (!expected_trns_ip.wr & expected_trns_ip.mstr0_ready) begin
            if (!fifo_empty) begin my_data = my_queue.pop_front();
                if (my_data !== actual_trns_ip.mstr0_data) `uvm_error("SCB","wrong mstr0_data")
            end
        end
	
   //     $display ("my_queue.size() = %h, fifo_full = %h", my_queue.size(), fifo_full);
        
    
        if (!my_queue.size()) fifo_empty = 1'b1; else fifo_empty = 1'b0;
        if (my_queue.size() < FD) fifo_full = 1'b0; else fifo_full = 1'b1;

         if (fifo_empty != actual_trns_ip.fifo_empty) `uvm_error("SCB","wrong fifo_empty")
         if (actual_trns_ip.data_valid != !fifo_empty) `uvm_error("SCB","error data_valid")
         if (fifo_full != actual_trns_ip.fifo_full) `uvm_error("SCB","wrong fifo_full")
	end else begin
		if (actual_trns_ip.fifo_empty != 1) `uvm_error("SCB","error after reset")
        if (actual_trns_ip.fifo_full != 0) `uvm_error("SCB","error after reset")
        if (actual_trns_ip.data_valid != 0) `uvm_error("SCB","error after reset")
        if (actual_trns_ip.mstr0_data != 0) `uvm_error("SCB","error after reset")
	end
	
	
      end
   endtask
   
   endclass
