module arbiter_tb;
    parameter DW = 32;
// parameter ADDR = 3;
// parameter WIDTH = 8;

// reg clk,rst_n,enable,rd_wr;
// reg [WIDTH-1:0]wr_data;
// reg [ADDR-1:0]addr;
// wire[WIDTH-1:0]rd_data;

reg[7:0] dut_error_num;
logic clk,rst_n,fifo_full,mstr0_cmplt;
 //logic slv1_mode,slv1_mode;
  logic    [1:0]  	slvx_mode,slv0_mode,slv1_mode;
  logic      		slvx_data_valid;
  logic    [7:0]   	slvx_proc_val,slv1_proc_valid,slv0_proc_valid;
  logic    [DW-1:0]  slvx_data,slv0_data, slv1_data ;
  logic      		slv0_ready;
  logic      		slv1_ready;
  logic slv0_data_valid;
  logic slv1_data_valid;
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
  /*INItial values*/

initial begin
  $display("###############");
  clk=0;
  rst_n=0;
  fifo_full=0;
  mstr0_cmplt = 0;
  //slvx_mode=0;
  //slv0_ready =1;
  //slv1_ready = 0;
  dut_error_num=0;
end
always #5 clk = !clk;
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
initial begin
 

#5;
    slv0_mode = 2'b10;
    slv0_data_valid = 1;
    slv1_data_valid = 0;
    slv0_proc_valid = 8'hFF;
    slv0_data = 32'b00101101101010101101100000111101;
#10;
    slv0_mode = 2'b10;
    slv0_data_valid = 1;
    slv1_data_valid = 0;
    slv0_proc_valid = 8'hFF;
    slv0_data = 32'b11111001101101010101000011100001;
#5;
    slv0_mode = 2'b10;
    slv0_data_valid = 1;
    slv1_data_valid = 0;
    slv0_proc_valid = 8'hFF;
    slv0_data = 32'b10101000011111101010111100110000;
#5;
    slv0_mode = 2'b10;
    slv0_data_valid = 1;
    slv1_data_valid = 0;
    slv0_proc_valid = 8'hFF;
    slv0_data = 32'b10001111010101111100011110001000;

 #50;
  -> single_wr;
  
  -> terminate_sim;

end

endmodule
