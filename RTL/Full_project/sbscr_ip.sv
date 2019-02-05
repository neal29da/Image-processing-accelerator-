class sbscr_ip extends uvm_subscriber#(trns_ip);
   `uvm_component_utils(sbscr_ip)
   

   trns_ip my_trns;
 
 
   covergroup ip_cover;
   
        mstr0_cmplt: coverpoint my_trns.mstr0_cmplt;
        slv0_mode : coverpoint my_trns.slv0_mode{
        ignore_bins bad_mode = {2'b11}; 
        }
        slv1_mode : coverpoint my_trns.slv1_mode{
        ignore_bins bad_mode = {2'b11}; 
        }
        slv0_data_valid : coverpoint my_trns.slv0_data_valid;
        slv1_data_valid : coverpoint my_trns.slv1_data_valid;
        slv0_ready : coverpoint my_trns.slv0_ready;
        slv1_ready : coverpoint my_trns.slv1_ready;
        mstr0_ready : coverpoint my_trns.mstr0_ready;
        mstr0_data_valid : coverpoint my_trns.mstr0_data_valid;
        
          slv0_proc_valid : coverpoint my_trns.slv0_proc_valid{
            bins ZERO = {8'h00};
            bins MID = {[8'h01:8'hfe]};
            bins HIGH = {8'hff};
        }
        slv1_proc_valid : coverpoint my_trns.slv1_proc_valid{
            bins ZERO = {8'h00};
            bins MID = {[8'h01:8'hfe]};
            bins HIGH = {8'hff};
        }
        
        slv0_data : coverpoint my_trns.slv0_data{
            bins ZERO = {0};
            bins MID = default;
           // bins HIGH = {$};
        }
        slv1_data : coverpoint my_trns.slv1_data{
            bins ZERO = {0};
            bins MID = default;
            //bins HIGH = {$};
        }
        mstr0_data : coverpoint my_trns.mstr0_data{
            bins ZERO = {0};
            bins MID = default;
         //   bins HIGH = {$};
        }

        
        
        slv0_cross: cross slv0_mode, slv0_data_valid, slv1_data_valid, mstr0_cmplt;
        slv1_cross: cross slv1_mode, slv0_data_valid, slv1_data_valid, mstr0_cmplt;
        mode_cross: cross slv0_mode, slv1_mode;
                

   endgroup

   function new(string name, uvm_component parent);
      super.new(name, parent);
      ip_cover = new;
   endfunction: new



   function void write(trns_ip t);
      my_trns = t;
      ip_cover.sample();
   endfunction: write
endclass
