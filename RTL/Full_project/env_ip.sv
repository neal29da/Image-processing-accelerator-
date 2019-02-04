class env_ip extends uvm_env;
    `uvm_component_utils(env_ip)
    
    agnt_ip_exp my_agnt_ip_exp;
   agnt_ip_act my_agnt_ip_act;
    scrbrd_ip my_scrbrd_ip;
    sbscr_ip my_sbscr_ip;
    scrbrd_arbiter my_scrbrd_arbiter;
    scrbrd_fifo my_scrbrd_fifo;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
     my_agnt_ip_exp = agnt_ip_exp::type_id::create("my_agnt_ip_exp", this);
     my_agnt_ip_act = agnt_ip_act::type_id::create("my_agnt_ip_act", this);
     my_scrbrd_ip = scrbrd_ip::type_id::create("my_scrbrd_ip", this);
    my_scrbrd_arbiter = scrbrd_arbiter::type_id::create("my_scrbrd_arbiter", this);
     my_scrbrd_fifo = scrbrd_fifo::type_id::create("my_scrbrd_fifo", this);

     my_sbscr_ip = sbscr_ip::type_id::create("my_sbscr_ip", this);
     set_config_int("my_agnt_ip_act", "is_active", UVM_PASSIVE);
    endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      my_agnt_ip_exp.my_a_port.connect(my_sbscr_ip.analysis_export);
      my_agnt_ip_exp.my_a_port.connect(my_scrbrd_ip.expected_analysis_export);
      my_agnt_ip_act.my_a_port.connect(my_scrbrd_ip.actual_analysis_export);
      my_agnt_ip_exp.my_a_port.connect(my_scrbrd_arbiter.expected_analysis_export);
      my_agnt_ip_act.my_a_port.connect(my_scrbrd_arbiter.actual_analysis_export);
      my_agnt_ip_exp.my_a_port.connect(my_scrbrd_fifo.expected_analysis_export);
      my_agnt_ip_act.my_a_port.connect(my_scrbrd_fifo.actual_analysis_export);

   endfunction

endclass
