module arbiter_tb(arbiter_if.TB arb_if);


reg[7:0] dut_error_num;


  event wr_done;
  event single_wr;
  event rst_done;
  event terminate_sim;

  /*INItial values*/
initial begin
  $display("###############");

  arb_if.fifo_full=0;
  arb_if.mstr0_cmplt = 0;
  dut_error_num=0;
end
  initial begin
    $dumpfile("arbiter.vcd");
    $dumpvars;
  end
initial
@(terminate_sim) begin
    $display("Terminating simulation");
if(dut_error_num == 0) begin
    $display("Simulation Result:PASSED");
end
else begin
    $display("Simulation Result:FAILED");
end
$display("###############");
#1 $finish;
end

initial begin
 

#5;
    arb_if.slv0_mode = 2'b10;
    arb_if.slv0_data_valid = 1;
    arb_if.slv1_data_valid = 0;
    arb_if.slv0_proc_valid = 8'hFF;
    arb_if.slv0_data = 32'b00101101101010101101100000111101;
#10;
    arb_if.slv0_mode = 2'b10;
    arb_if.slv0_data_valid = 1;
    arb_if.slv1_data_valid = 0;
    arb_if.slv0_proc_valid = 8'hFF;
   arb_if.slv0_data = 32'b11111001101101010101000011100001;
#5;
    arb_if.slv0_mode = 2'b10;
    arb_if.slv0_data_valid = 1;
    arb_if.slv1_data_valid = 0;
    arb_if.slv0_proc_valid = 8'hFF;
    arb_if.slv0_data = 32'b10101000011111101010111100110000;
#5;
    arb_if.slv0_mode = 2'b10;
    arb_if.slv0_data_valid = 1;
    arb_if.slv1_data_valid = 0;
    arb_if.slv0_proc_valid = 8'hFF;
    arb_if.slv0_data = 32'b10001111010101111100011110001000;

 #50;
  -> single_wr;
  
  -> terminate_sim;

end

endmodule
