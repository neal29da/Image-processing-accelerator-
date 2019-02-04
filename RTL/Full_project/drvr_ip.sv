class drvr_ip extends uvm_driver #(trns_ip);
`uvm_component_utils(drvr_ip)

virtual IP_interface my_vif_ip;

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction
    
function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual IP_interface)::get(this, "", "vif_ip", my_vif_ip))
        `uvm_error("","uvm_config_db::get failed")
endfunction

task run_phase(uvm_phase phase);
          trns_ip my_trns;
    forever begin
        seq_item_port.get_next_item(my_trns);
      @(posedge my_vif_ip.clk);
      
        my_vif_ip.slv0_mode = my_trns.slv0_mode;
        my_vif_ip.slv1_mode = my_trns.slv1_mode;
        my_vif_ip.slv0_data_valid = my_trns.slv0_data_valid;
        my_vif_ip.slv1_data_valid = my_trns.slv1_data_valid;
        my_vif_ip.slv0_proc_valid = my_trns.slv0_proc_valid;
        my_vif_ip.slv1_proc_valid = my_trns.slv1_proc_valid;
        my_vif_ip.slv0_data = my_trns.slv0_data;
        my_vif_ip.slv1_data = my_trns.slv1_data;
        my_vif_ip.mstr0_ready = my_trns.mstr0_ready;
	
	#0  my_trns.slv0_ready = my_vif_ip.slv0_ready;
	#0  my_trns.slv1_ready = my_vif_ip.slv1_ready;
        #0  my_trns.mstr0_cmplt = my_vif_ip.mstr0_cmplt;
        #0  my_trns.mstr0_data_valid = my_vif_ip.mstr0_data_valid;


	seq_item_port.item_done(my_trns);
    end
endtask

endclass
