class agnt_ip_act extends uvm_agent;
  `uvm_component_utils(agnt_ip_act)
    
    uvm_analysis_port#( trns_ip ) my_a_port;
    
    drvr_ip my_drvr_ip;
    sqncr_ip my_sqncr_ip;
    mntr_ip_act my_mntr_ip;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
     if (get_is_active()) begin
        my_drvr_ip = drvr_ip::type_id::create("my_drvr_ip", this);
        my_sqncr_ip = sqncr_ip::type_id::create("my_sqncr_ip", this);
    end
         my_mntr_ip = mntr_ip_act::type_id::create ("my_mntr_ip", this);
            my_a_port = new("my_a_port", this);

    endfunction
    function void connect_phase(uvm_phase phase);
    if (get_is_active()) begin
        my_drvr_ip.seq_item_port.connect(my_sqncr_ip.seq_item_export);
    end
    my_mntr_ip.my_a_port.connect(my_a_port);
    endfunction
    
endclass
