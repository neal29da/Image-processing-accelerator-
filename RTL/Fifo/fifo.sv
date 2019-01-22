module fifo_mem(fifo_if.DUT_FIFO fi_if);  
  wire[4:0] wptr,rptr;  
  wire fifo_we,fifo_rd;   
  write_pointer top1(fifo_if.DUT_WR_POI fi_if1,wptr,fifo_we);  
  read_pointer top2(fifo_if.DUT_READ_POI fi_if2,rptr,fifo_rd);  
  memory_array top3(fifo_if.DUT_MEM_ARR fi_if3,fifo_we, wptr,rptr);  
  status_signal top4(fifo_if.DUT_STATUS fi_if4, fifo_we, fifo_rd, wptr,rptr);  
 endmodule  
 module memory_array(fifo_if.DUT_MEM_ARR fi_if3,fifo_we, wptr,rptr);  

  input fifo_we;  
  input[4:0] wptr,rptr;   
  reg[7:0] data_out2[15:0];  
  //wire[7:0] data_out;  
  always @(posedge fi_if3.clk)  
  begin  
   if(fifo_we)   
      data_out2[wptr[3:0]] <=fi_if3.data_in ;  
  end  
  assign fi_if3.data_out = data_out2[rptr[3:0]];  
 endmodule  

 module read_pointer(fifo_if.DUT_READ_POI fi_if2,rptr,fifo_rd);  
 
  output[4:0] rptr;  
  output fifo_rd;  
  reg[4:0] rptr;  
  assign fifo_rd = (~fi_if2.fifo_empty)& fi_if2.rd;  
  always @(posedge fi_if2.clk or negedge fi_if2.rst_n)  
  begin  
   if(~fi_if2.rst_n) rptr <= 5'b000000;  
   else if(fifo_rd)  
    rptr <= rptr + 5'b000001;  
   else  
    rptr <= rptr;  
  end  
 endmodule  

 module status_signal(fifo_if.DUT_STATUS fi_if4,fifo_we, fifo_rd, wptr,rptr);  
  input fifo_we, fifo_rd;  
  input[4:0] wptr, rptr;  

  wire fbit_comp, overflow_set, underflow_set;  
  wire pointer_equal;  
  wire[4:0] pointer_result;  
  //reg fifo_full, fifo_empty;  
  assign fbit_comp = wptr[4] ^ rptr[4];  
  assign pointer_equal = (wptr[3:0] - rptr[3:0]) ? 0:1;  
  assign pointer_result = wptr[4:0] - rptr[4:0];  
  assign overflow_set = fi_if4.fifo_full & fi_if4.wr;  
  assign underflow_set = fi_if4.fifo_empty&fi_if4.rd;  
  always @(*)  
  begin  
   fi_if4.fifo_full =fbit_comp & pointer_equal;  
   fi_if4.fifo_empty = (~fbit_comp) & pointer_equal;  
  end  
 
 
 endmodule  

 module write_pointer(fifo_if.DUT_WR_POI fi_if1,wptr,fifo_we);  

  output[4:0] wptr;  
  output fifo_we;  
  reg[4:0] wptr;  
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