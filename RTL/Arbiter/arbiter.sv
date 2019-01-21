// Code your design here
module arbiter(
    mstr0_cmplt,
    fifo_full,
    rst_n,
    clk,
    slv0_mode,
    slv1_mode,
    slv0_data_valid,
    slv1_data_valid,
    slv0_proc_valid,
    slv1_proc_valid,
    slv0_data,
    slv1_data,
    slvx_mode,
    slvx_data_valid,
    slvx_proc_val,
    slvx_data,
    slv0_ready,
    slv1_ready);

    parameter DW = 32;
  
    input       		mstr0_cmplt;
    input       		fifo_full;
    input       		rst_n;
    input       		clk;
    input     [1:0]  	slv0_mode;
    input     [1:0]  	slv1_mode;
    input        		slv0_data_valid;
    input       		slv1_data_valid;
    input     [7:0]   	slv0_proc_valid;
    input     [7:0]   	slv1_proc_valid;
    input     [DW-1:0]  slv0_data;
    input     [DW-1:0]  slv1_data;
    output    [1:0]  	slvx_mode;
    output      		slvx_data_valid;
    output    [7:0]   	slvx_proc_val;
    output    [DW-1:0]  slvx_data;
    output      		slv0_ready;
    output      		slv1_ready;
  
  logic [1:0] slvx_mode;
  logic [DW-1:0]  slvx_data;
  logic [7:0]   	slvx_proc_val;
  logic slvx_data_valid;
  logic slv0_ready;
  logic slv1_ready;
  
  
  always @ (posedge clk or negedge rst_n)
    if(! rst_n) begin
       slvx_mode=0;
       slv0_ready = 1;
       slv1_ready = 0;
      end
    else if ( slv0_data_valid && ~ fifo_full && ~ mstr0_cmplt) begin
      slvx_mode = slv0_mode;
      slvx_data_valid = slv0_data_valid;
      slvx_proc_val = slv0_proc_valid;
      slvx_data = slv0_data;
    end
    else if ( slv1_data_valid && ~ fifo_full && ~ mstr0_cmplt) begin
      slvx_mode = slv1_mode;
      slvx_data_valid = slv1_data_valid;
      slvx_proc_val = slv1_proc_valid;
      slvx_data = slv1_data;
    end
endmodule