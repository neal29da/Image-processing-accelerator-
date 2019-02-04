class mntr_ip_exp extends uvm_monitor;
   `uvm_component_utils(mntr_ip_exp)
 
   uvm_analysis_port#(trns_ip) my_a_port;
 
   virtual IP_interface my_vif_ip;
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     if(!uvm_config_db #(virtual IP_interface)::get(this, "", "vif_ip", my_vif_ip))
        `uvm_error("","uvm_config_db::get failed")
      my_a_port = new("my_a_port", this);
   endfunction: build_phase
 
   task run_phase(uvm_phase phase);
              trns_ip my_trns;

      forever begin
 
        @(negedge my_vif_ip.clk);

      //  $display("mon exp time: %t", $time);   
        my_trns = trns_ip::type_id::create("my_trns");
        my_trns.rst_n = my_vif_ip.rst_n;
        
      
       
         my_trns.mstr0_cmplt = my_vif_ip.mstr0_cmplt;
         my_trns.slv0_mode = my_vif_ip.slv0_mode;
         my_trns.slv1_mode = my_vif_ip.slv1_mode;
         my_trns.slv0_data_valid = my_vif_ip.slv0_data_valid;
         my_trns.slv1_data_valid = my_vif_ip.slv1_data_valid;
         my_trns.slv0_proc_valid = my_vif_ip.slv0_proc_valid;
         my_trns.slv1_proc_valid = my_vif_ip.slv1_proc_valid;
         my_trns.slv0_data = my_vif_ip.slv0_data;
         my_trns.slv1_data = my_vif_ip.slv1_data;
         my_trns.mstr0_ready = my_vif_ip.mstr0_ready;
         my_trns.slv0_ready = my_vif_ip.slv0_ready;
         my_trns.slv1_ready = my_vif_ip.slv1_ready;
         my_trns.mstr0_data = my_vif_ip.mstr0_data;
         my_trns.mstr0_data_valid = my_vif_ip.mstr0_data_valid;
          my_a_port.write(my_trns);

      end
   endtask: run_phase
endclass
