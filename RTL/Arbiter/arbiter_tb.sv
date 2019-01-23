module arbiter_tb;
  
    parameter DW = 32;


reg[7:0] dut_error_num;
logic clk,rst_n,fifo_full,mstr0_cmplt;

  logic    [1:0]  	slvx_mode,slv0_mode,slv1_mode;
  logic      		slvx_data_valid;
  logic    [7:0]   	slvx_proc_val,slv1_proc_valid,slv0_proc_valid;
  logic    [DW-1:0]  slvx_data,slv0_data, slv1_data;
  logic      		slv0_ready;
  logic      		slv1_ready;
  logic slv0_data_valid;
  logic slv1_data_valid;
  
  // for store data to slvdata
  logic [DW-1:0] RAM[0:100];
  
/*DUT Installation*/
arbiter U0(
    .mstr0_cmplt(mstr0_cmplt),
    .fifo_full(fifo_full),
    .rst_n(rst_n),
    .clk(clk),
    .slv0_mode(slv0_mode),
    .slv1_mode(slv1_mode),
    .slv0_data_valid(slv0_data_valid),
    .slv1_data_valid(slv1_data_valid),
    .slv0_proc_valid(slv0_proc_valid),
    .slv1_proc_valid(slv1_proc_valid),
    .slv0_data(slv0_data),
    .slv1_data(slv1_data),
    .slvx_mode(slvx_mode),
    .slvx_data_valid(slvx_data_valid),
    .slvx_proc_val(slvx_proc_val),
    .slvx_data(slvx_data),
    .slv0_ready(slv0_ready),
    .slv1_ready(slv1_ready)
);
  

  
  //event rst_en;
  event wr_done;
  event single_wr;
  event rst_done;
  event terminate_sim;


 /*OPEN FILE DATA AND STORE TO A RAM*/ 

  initial
    $readmemh("hexa_output_8B.txt", RAM);integer i;
  /*initial begin 
    for(i=0;i<101;i=i+1)             
      $display ("RAM[%d]=%h",i,RAM[i]); 
  end*/  
 /*BEGIN TESTBENCH*/
  
    /*INItial values*/
initial begin
  $display("###############");
  clk=0;
  rst_n=0;
  fifo_full=0;
  mstr0_cmplt = 0;
  dut_error_num=0;
end
always #2 clk = !clk;
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
initial 
 begin
#5 rst_n=1;
end
integer t;
initial begin
  t = 0;
  repeat (3) begin 
    #10;
    slv0_mode = 0;
    slv0_data_valid = 1;
    slv1_data_valid = 1;
    slv0_proc_valid = 8'hFF;
    slv0_data = RAM[t];
    slv1_mode = 1;
    slv1_proc_valid = 8'hFF;
    t = t +2;
    slv1_data = RAM[t];
    t = t -1;
    $display ("#______________________________#");
    $display ("slv0_data=%h",slv0_data);
    $display ("slv1_data=%h",slv1_data);
     #3 $display ("slvx_data=%h",slvx_data);
    $display ("#______________________________#");
   end 
    
  repeat (3) begin 
    #10;
    slv0_mode = 1;
    slv0_data_valid = 0;
    slv1_data_valid = 0;
    slv0_proc_valid = 8'hFF;
    slv0_data = RAM[t];
    slv1_mode = 0;
    slv1_proc_valid = 8'hFF;
    t = t +2;
    slv1_data = RAM[t];
    t = t -1;
    $display ("#______________________________#");
    $display ("slv0_data=%h",slv0_data);
    $display ("slv1_data=%h",slv1_data);
     #3 $display ("slvx_data=%h",slvx_data);
    $display ("#______________________________#");
   end 
  repeat (3) begin 
    #10;
    slv0_mode = 1;
    slv0_data_valid = 1;
    slv1_data_valid = 1;
    slv0_proc_valid = 8'hFF;
    slv0_data = RAM[t];
    slv1_mode = 1;
    slv1_proc_valid = 8'hFF;
    t = t +2;
    slv1_data = RAM[t];
    t = t -1;
    $display ("#______________________________#");
    $display ("slv0_data=%h",slv0_data);
    $display ("slv1_data=%h",slv1_data);
    #3 $display ("slvx_data=%h",slvx_data);
    $display ("#______________________________#");
   end 
 #100;
  -> single_wr;
  
  -> terminate_sim;

end

endmodule
