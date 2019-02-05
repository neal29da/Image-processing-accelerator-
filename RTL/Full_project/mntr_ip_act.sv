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
         integer file_handle, file_handle_2;
         string output_file, output_file_2;
         integer file_num;
         logic my_cmplt;

      file_num = 0;
      forever begin
        if (!file_num)begin
            $sformat(output_file, "outdata_%0d/output_%0d.txt", DW, file_num);
            file_handle = $fopen(output_file,"w");
        //    $sformat(output_file_2, "outdata_%0d/output_wr_%0d.txt", DW, file_num);
          //  file_handle_2 = $fopen(output_file_2,"w");
            file_num = file_num + 1;
        end
        
        if (my_cmplt) begin
            $fclose(file_handle);
            $sformat(output_file, "outdata_%0d/output_%0d.txt", DW, file_num);
            file_handle = $fopen(output_file,"w");
       //     $fclose(file_handle_2);
         //   $sformat(output_file_2, "outdata_%0d/output_wr_%0d.txt", DW, file_num);
           // file_handle_2 = $fopen(output_file_2,"w");
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
my_trns.data_fifo = my_vif_ip.data_fifo;
my_trns.wr = my_vif_ip.wr;
my_trns.proc_cmplt = my_vif_ip.proc_cmplt;
//$display("my_data: %h", my_trns.mstr0_data);
        if (my_trns.mstr0_data_valid[0] && my_trns.mstr0_ready && !my_trns.mstr0_cmplt) $fdisplay(file_handle, "%h", my_trns.mstr0_data);
      //  if (my_trns.wr && !my_trns.proc_cmplt) $fdisplay(file_handle_2, "%h", my_trns.data_fifo);



        my_cmplt = my_trns.mstr0_cmplt;
         
        

	my_a_port.write(my_trns);
      end

   endtask: run_phase
endclass
