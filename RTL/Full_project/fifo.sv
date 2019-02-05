module fifo_mem(IP_interface.DUT_FIFO fi_if, IP_interface.DUT_WR_POI fi_if1, IP_interface.DUT_STATUS fi_if4, IP_interface.DUT_MEM_ARR fi_if3, IP_interface.DUT_READ_POI fi_if2);  
parameter DW = 32;
  logic[4:0] wptr;
  logic [4:0] rptr;  
  logic fifo_we,fifo_rd;   

  write_pointer top1(.fi_if1(fi_if1),.wptr(wptr),.fifo_we(fifo_we));  
  read_pointer top2(.fi_if2(fi_if2) ,.rptr(rptr),.fifo_rd(fifo_rd));  
  memory_array top3(.fi_if3(fi_if3) ,.fifo_we(fifo_we), .wptr(wptr),.rptr(rptr));  
  status_signal top4(.fi_if4(fi_if4) , .fifo_we(fifo_we), .fifo_rd(fifo_rd), .wptr(wptr),.rptr(rptr));  
 endmodule  

 module memory_array(IP_interface.DUT_MEM_ARR fi_if3,input logic fifo_we, input logic [4:0] wptr,input logic [4:0] rptr);  

  //input fifo_we;  
  //input[4:0] wptr,rptr;   
  logic[DW-1:0] data_out2[15:0];  
  //logic[7:0] mstr0_data;  
  always @(posedge fi_if.clk)  
  begin  
   if(fifo_we)   
      data_out2[wptr[3:0]] <=fi_if3.data_fifo ;  
  end  
  assign fi_if3.mstr0_data = data_out2[rptr[3:0]];  
 endmodule  

 module read_pointer(IP_interface.DUT_READ_POI fi_if2, output logic [4:0] rptr, output logic fifo_rd);  
 
 // output[4:0] rptr;  
 // output fifo_rd;  
  //logic[4:0] rptr;  
  assign fifo_rd = (~fi_if2.fifo_empty)& fi_if2.mstr0_ready;  
  always @(posedge fi_if2.clk or negedge fi_if2.rst_n)  
  begin  
   if(~fi_if2.rst_n) rptr <= 5'b000000;  
   else if(fifo_rd)  
    rptr <= rptr + 5'b000001;  
   else  
    rptr <= rptr;  
  end  
 endmodule  

 module status_signal(IP_interface.DUT_STATUS fi_if4, input logic fifo_we, fifo_rd, input logic[4:0] wptr,rptr);  
 // input fifo_we, fifo_rd;  
  //input[4:0] wptr, rptr;  

  logic fbit_comp, overflow_set, underflow_set;  
  logic pointer_equal;  
  logic[4:0] pointer_result;  
  //logic fifo_full, fifo_empty;  
  assign fbit_comp = wptr[4] ^ rptr[4];  
  assign pointer_equal = (wptr[3:0] - rptr[3:0]) ? 0:1;  
  assign pointer_result = wptr[4:0] - rptr[4:0];  
  assign overflow_set = fi_if4.fifo_full & fi_if4.wr;  
  assign underflow_set = fi_if4.fifo_empty&fi_if4.mstr0_ready;  
  always @(*)  
  begin  
   fi_if4.fifo_full =fbit_comp & pointer_equal;  
   fi_if4.fifo_empty = (~fbit_comp) & pointer_equal;
   fi_if4.fifo_threshold = (pointer_result[4] || pointer_result[3]) ? 1:0;  
  end  
  assign fi_if4.data_valid = ~fi_if4.fifo_empty;
 
 endmodule  

 module write_pointer(IP_interface.DUT_WR_POI fi_if1,output logic [4:0] wptr, output logic fifo_we);  

 // output[4:0] wptr;  
 // output fifo_we;  
  //logic[4:0] wptr;  
  assign fifo_we = (~fi_if1.fifo_full)&fi_if1.wr;  
  always @(posedge fi_if1.clk or negedge fi_if1.rst_n)  
  begin  
   if(~fi_if1.rst_n) wptr <= 5'b000000;  
   else if(fifo_we)  
    wptr <= wptr + 5'b000001;  
   else  
    wptr <= wptr;  
  end  
 endmodule 
