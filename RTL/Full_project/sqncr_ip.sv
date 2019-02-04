class sqncr_ip extends uvm_sequencer #(trns_ip);
    `uvm_component_utils(sqncr_ip)
        
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
