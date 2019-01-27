module fifo_mem(fifo_if.DUT_FIFO fi_if);  
parameter DW = 32;
    wire[4:0] wptr,rptr;  
  wire fifo_we,fifo_rd;   

  write_pointer top1(wptr,fifo_we, fi_if.wr, fi_if.fifo_full, fi_if.clk, fi_if.rst_n);  
  read_pointer top2(rptr,fifo_rd, fi_if.mstr0_ready, fi_if.fifo_empty, fi_if.clk, fi_if.rst_n);  
  memory_array top3(fi_if.data_out, fi_if.data_in, fi_if.clk, fifo_we, wptr,rptr);  
  status_signal top4(fi_if.fifo_full, fi_if.fifo_empty,fi_if.mstr0_ready, fi_if.wr, fifo_we, fifo_rd, wptr,rptr, fi_if.clk, fi_if.rst_n);  
 endmodule  
 module memory_array(fi_if.data_out, fi_if.data_in, fi_if.clk, fifo_we, wptr,rptr);  

  input fifo_we;  
  input[4:0] wptr,rptr;   
  reg[DW-1:0] data_out2[15:0];  
  //wire[7:0] data_out;  
  always @(posedge fi_if.clk)  
  begin  
   if(fifo_we)   
      data_out2[wptr[3:0]] <=fi_if.data_in ;  
  end  
  assign fi_if.data_out = data_out2[rptr[3:0]];  
 endmodule  

 module read_pointer(rptr,fifo_rd, fi_if.mstr0_ready, fi_if.fifo_empty, fi_if.clk, fi_if.rst_n);  
 
  output[4:0] rptr;  
  output fifo_rd;  
  reg[4:0] rptr;  
  assign fifo_rd = (~fi_if.fifo_empty)& fi_if.mstr0_ready;  
  always @(posedge fi_if.clk or negedge fi_if.rst_n)  
  begin  
   if(~fi_if.rst_n) rptr <= 5'b000000;  
   else if(fifo_rd)  
    rptr <= rptr + 5'b000001;  
   else  
    rptr <= rptr;  
  end  
 endmodule  

 module status_signal(fi_if.fifo_full, fi_if.fifo_empty,fi_if.mstr0_ready, fi_if.wr, fifo_we, fifo_rd, wptr,rptr, fi_if.clk, fi_if.rst_n);  
  input fifo_we, fifo_rd;  
  input[4:0] wptr, rptr;  

  wire fbit_comp, overflow_set, underflow_set;  
  wire pointer_equal;  
  wire[4:0] pointer_result;  
  //reg fifo_full, fifo_empty;  
  assign fbit_comp = wptr[4] ^ rptr[4];  
  assign pointer_equal = (wptr[3:0] - rptr[3:0]) ? 0:1;  
  assign pointer_result = wptr[4:0] - rptr[4:0];  
  assign overflow_set = fi_if.fifo_full & fi_if.wr;  
  assign underflow_set = fi_if.fifo_empty&fi_if.mstr0_ready;  
  always @(*)  
  begin  
   fi_if.fifo_full =fbit_comp & pointer_equal;  
   fi_if.fifo_empty = (~fbit_comp) & pointer_equal;  
  end  
  assign fi_if.data_valid = ~fi_if.fifo_empty;
 
 endmodule  

 module write_pointer(wptr,fifo_we, fi_if.wr, fi_if.fifo_full, fi_if.clk, fi_if.rst_n);  

  output[4:0] wptr;  
  output fifo_we;  
  reg[4:0] wptr;  
  assign fifo_we = (~fi_if.fifo_full)&fi_if.wr;  
  always @(posedge fi_if.clk or negedge fi_if.rst_n)  
  begin  
   if(~fi_if.rst_n) wptr <= 5'b000000;  
   else if(fifo_we)  
    wptr <= wptr + 5'b000001;  
   else  
    wptr <= wptr;  
  end  
 endmodule 
