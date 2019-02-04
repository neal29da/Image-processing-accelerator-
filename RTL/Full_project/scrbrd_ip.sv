class scrbrd_ip extends uvm_component;
   `uvm_component_utils( scrbrd_ip )
 
   uvm_analysis_export  #( trns_ip ) expected_analysis_export;
   uvm_analysis_export  #( trns_ip )   actual_analysis_export;
   uvm_tlm_analysis_fifo#( trns_ip ) expected_fifo_ip;
   uvm_tlm_analysis_fifo#( trns_ip )   actual_fifo_ip;
 
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
      expected_fifo_ip = new( "expected_fifo_ip", this );
        actual_fifo_ip = new(   "actual_fifo_ip", this );
   endfunction: build_phase
 
   // Function: connect_phase
   //-------------------------------------------------------------------------
   virtual function void connect_phase( uvm_phase phase );
      super.connect_phase( phase );
 
      expected_analysis_export.connect( expected_fifo_ip.analysis_export );
        actual_analysis_export.connect(   actual_fifo_ip.analysis_export );
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

      forever begin

	  if (count == 0)  begin
	    actual_fifo_ip.get_peek_export.get(   act_trns );
	    //act_trns.print();

	  end

         expected_fifo_ip.get_peek_export.get( exp_trns );
         actual_fifo_ip.get_peek_export.get(   act_trns );
        count = 1;
       // $display("time: %t", $time); 
        
       // exp_trns.print();
        ///////act_trns.print();
        
        

	end
   endtask
   
   endclass
