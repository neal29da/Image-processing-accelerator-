class test_ip extends uvm_test;
    `uvm_component_utils(test_ip)
    
    env_ip my_env_ip;
    int repeat_count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        my_env_ip = env_ip::type_id::create("my_env_ip", this);
    endfunction
    
    task run_phase(uvm_phase phase);
      	sqnc_ip my_sqnc;

        phase.raise_objection(this);
        my_sqnc = sqnc_ip::type_id::create("my_sqnc");
        if (!my_sqnc.randomize()) `uvm_error("", "my_sqnc randomize failed");
        my_sqnc.repeat_count = 100;
        my_sqnc.start(my_env_ip.my_agnt_ip_exp.my_sqncr_ip);
        phase.drop_objection(this);


    endtask
    
endclass
