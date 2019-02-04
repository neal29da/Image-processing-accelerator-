// Code your testbench here
// or browse Examples
parameter DW = 64;

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "trns_ip.sv"
`include "sqnc_ip.sv"
`include "sqncr_ip.sv"
`include "drvr_ip.sv"

`include "mntr_ip_exp.sv"

`include "mntr_ip_act.sv"
`include "agnt_ip_act.sv"
`include "agnt_ip_exp.sv"
`include "scrbrd_ip.sv"
`include "sbscr_ip.sv"
`include "env_ip.sv"
`include "test_ip.sv"
`include "IP_interface.sv"

`include "IP.sv"

module top;

bit clk, rst_n;
 
 
 IP_interface my_ip_if(clk, rst_n); 
 IP my_ip (my_ip_if);
     
	
	
        initial begin
            clk = 0;
            rst_n = 1;
            #5
            rst_n = 0;
            #15
            rst_n = 1;
            forever #5 clk = ~clk;

        end
        initial begin
            uvm_config_db #(virtual IP_interface)::set(null, "*", "vif_ip", my_ip_if);

            run_test("test_ip");
        end
endmodule
