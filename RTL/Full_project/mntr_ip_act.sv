class mntr_ip_act extends uvm_monitor;
   `uvm_component_utils(mntr_ip_act)
 
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
         integer file_handle;
         string output_file;
         integer file_num;
         logic my_cmplt;

      file_num = 0;
      forever begin
        if (!file_num)begin
            $sformat(output_file, "output_%0d.txt", file_num);
            file_handle = $fopen(output_file,"w");
            file_num = file_num + 1;
        end
        
        if (my_cmplt) begin
            $fclose(file_handle);
            $sformat(output_file, "outdata/output_%0d.txt", file_num);
            file_handle = $fopen(output_file,"w");
            file_num = file_num + 1;
        end
         @(negedge my_vif_ip.clk);
        my_trns = trns_ip::type_id::create("my_trns");
         my_trns.mstr0_cmplt = my_vif_ip.mstr0_cmplt;
         my_trns.slv0_ready = my_vif_ip.slv0_ready;
         my_trns.slv1_ready = my_vif_ip.slv1_ready;
         my_trns.mstr0_data = my_vif_ip.mstr0_data;
         my_trns.mstr0_data_valid = my_vif_ip.mstr0_data_valid;
	 my_trns.mstr0_ready = my_vif_ip.mstr0_ready;
        if (my_trns.mstr0_data_valid[0] && my_trns.mstr0_ready) 
        $fdisplay(file_handle, "%h", my_trns.mstr0_data);
        
        my_cmplt = my_trns.mstr0_cmplt;
         
        

	my_a_port.write(my_trns);
      end

   endtask: run_phase
endclass
