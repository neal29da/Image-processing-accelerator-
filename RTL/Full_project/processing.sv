module processing (IP_interface.DUT_PROCESSING dut_if);
parameter DW = 32;
parameter HEADER_SIZE = 15;

logic [DW - 1:0] my_pixels [3];
logic [31:0] count_in, count_out;
logic [31:0] pix_low [3];
logic [31:0] pix_high [3];
logic [31:0] data_size, data_width;
logic [7:0] proc_val, diff_val;
logic [1:0] ind_in, ind_out, pix_count;
logic [1:0] p0, p1, p2;
logic [3:0] valid_counter;
logic [1:0] padding, last_count;
bit   pix_done, reset_ind, reset_mode, proc_done;

//------for eda 
logic [DW - 1:0] pix0, pix1,pix2;
logic [31:0] pix10, pix11, pix12, pix20, pix21, pix22;


  assign pix0 = my_pixels[0];
  assign pix1 = my_pixels[1];
  assign pix2 = my_pixels[2];
  assign pix10 = pix_low[0];
  assign pix11 = pix_low[1];
  assign pix12 = pix_low[2];
  assign pix20 = pix_high[0];
  assign pix21 = pix_high[1];
  assign pix22 = pix_high[2];
//-----

  
assign diff_val = (proc_val[7] ) ?  (~proc_val + 1'b1) : proc_val;

assign padding = data_width[1:0];
assign reset_mode = ((dut_if.slvx_mode == 2'b01) && (padding == 1 || padding == 2)) ? 1'b1 : 1'b0;

//if (DW == 32) begin
  assign  pix_done = ((ind_in == p0) & dut_if.slvx_data_valid  & (pix_count < 2)) | ((count_out >= HEADER_SIZE) & reset_ind);
/*end else begin if (DW == 64)         
  assign  pix_done = ((ind_in == p0) & (count_in >= 8'h12) & (pix_count < 2) )| ((count_out >= HEADER_SIZE) & reset_ind);
end*/

  always @(posedge dut_if.clk) begin
    if (reset_mode) begin
      if (reset_ind && (count_in > 8'h10))begin
              if (DW == 32) begin
              if (padding == 1) begin 
                    p0 <= p1;
                    p1 <= p2;
                    p2 <= p0;
              end else if (padding == 2) begin
                p0 <= p2;
                p1 <= p0;
                p2 <= p1;
              end
        end else if (DW == 64) begin
              
              if (padding == 1) begin 
                    p0 <= p2;
                    p1 <= p0;
                    p2 <= p1;
              end else if (padding == 2) begin
                p0 <= p1;
                p1 <= p2;
                p2 <= p0;
              end
        end
    end      
    end
  end
  
assign reset_ind =  (reset_mode && ((count_in - HEADER_SIZE) % (((data_width * 3) >> 2) + 1) == 0)) ? 1'b1 : 1'b0;
 


always @(posedge dut_if.clk or negedge dut_if.rst_n) begin
        if (!dut_if.rst_n || proc_done || (dut_if.slvx_mode == 2'b00 & (last_count == 0))) begin
            dut_if.data_fifo = 0;
            dut_if.wr = 0;
          //  dut_if.proc_cmplt = 0;
            count_in = 0;
            count_out = 0;
            pix_count = 0;
            data_size = 0;
            ind_in = 0;
            ind_out = 0;
            valid_counter = 0;
            data_width = 0;
	    last_count = 0;
            proc_val = 0;
	    proc_done = 0;
            my_pixels [0] = 0;
            my_pixels [1] = 0;
            my_pixels [2] = 0;
            pix_low [0] = 0;
            pix_low [1] = 0;
            pix_low [2] = 0;
            pix_high [0] = 0;
            pix_high [1] = 0;
            pix_high [2] = 0;

            if (DW == 32) begin
                p0 = 2'b00;
                p1 = 2'b01;
                p2 = 2'b10;
            end else begin
                p0 = 2'b00;
                p1 = 2'b01;
                p2 = 2'b10;
            end
        end else begin
        if ((dut_if.slvx_mode != 0) && dut_if.slvx_data_valid) begin
           
          valid_counter = {valid_counter[2:0], 1'b1};
          count_in <= count_in + (DW >> 5);
          	ind_in <= ind_in + 2'b01;
          if (ind_in == 2'b10) ind_in <= 2'b00;
          
          my_pixels[ind_in] <= dut_if.slvx_data;
        end else
            valid_counter = {valid_counter[2:0], 1'b0};
        end
    end
    
    
always @(posedge dut_if.clk) begin
  if (pix_count > 1) begin
    	proc_val <= dut_if.slvx_proc_val;
        if (DW == 32) begin
          if (count_out == 0) data_size[15:0] = {my_pixels[ind_out][7:0], my_pixels[ind_out][15:8]};
          if (count_out == 1) data_size[31:16] = {my_pixels[ind_out][23:16], my_pixels[ind_out][31:24]};
          if (count_out == 3) data_width[31:16] = {my_pixels[ind_out][23:16], my_pixels[ind_out][31:24]};
          if (count_out == 4) data_width[15:0] = {my_pixels[ind_out][7:0], my_pixels[ind_out][15:8]};
        end else if (DW == 64) begin
	   if (count_out == 2) data_width[31:0] = {my_pixels[ind_out][23:16], my_pixels[ind_out][31:24], my_pixels[ind_out+1][39:32], my_pixels[ind_out+1][47:40]};	
            if (count_out == 0) data_size[31:0] = {my_pixels[ind_out][23:16], my_pixels[ind_out][31:24], my_pixels[ind_out][39:32], my_pixels[ind_out][47:40]};
            
        end
    end
end
 
always @(posedge dut_if.clk) begin
if (pix_done) pix_count <= 2'b11;
 /* if ((count_in == (data_size >> (DW >> 4)) + 2) & (count_in >= HEADER_SIZE)) begin
      dut_if.proc_cmplt <= 1'b1;
      last_count = 2'b11;
    end else dut_if.proc_cmplt <= 1'b0;*/
end

if (DW == 32) begin
assign dut_if.proc_cmplt = ((count_in == (data_size >> (DW >> 4)) + 2) & (count_in >= HEADER_SIZE) & (last_count == 0)) ? 1'b1 : 1'b0;
end else begin
assign dut_if.proc_cmplt = ((count_in >= (data_size >> 2) + 2) & (count_in >= HEADER_SIZE) & (last_count == 0)) ? 1'b1 : 1'b0;
end

always @(posedge dut_if.clk) begin
if (dut_if.proc_cmplt) last_count = 2'b10;
end


always @(posedge dut_if.clk) begin
  if (last_count > 0) begin
      last_count = last_count - 1;
  end
  if (last_count == 1) proc_done <= 1'b1;

end



always @(posedge dut_if.clk) begin
    if (!proc_done) begin
    if ((pix_count > 1 || pix_done) && count_out < HEADER_SIZE) begin     
            pix_count = pix_count - 1'b1;
            ind_out <= ind_out + 2'b01;
            count_out <= count_out + (DW >> 5);
            if (ind_out == 2'b10) ind_out <= 2'b00;

            dut_if.data_fifo = my_pixels[ind_out];   
            dut_if.wr = 1'b1;

    end else if ((count_out >= HEADER_SIZE) && ((pix_count > 1) || (pix_done) || ((valid_counter[0] & valid_counter[1] & valid_counter[2] & valid_counter[3]))) ) begin
            pix_count = pix_count - 1'b1;
            ind_out <= ind_out + 2'b01;
            count_out <= count_out + (DW >> 5);
            if (ind_out == 2'b10) ind_out <= 2'b00;
            if (DW == 32) begin
                dut_if.data_fifo = pix_low[ind_out];
            end else if (DW == 64) begin
                dut_if.data_fifo = {pix_high[ind_out], pix_low[ind_out]};
            end
            dut_if.wr = 1'b1;    
    end else dut_if.wr = 1'b0;
    end else dut_if.wr = 1'b0;
end

if (DW == 32) begin
always @(posedge dut_if.clk) begin
  if (pix_done & (count_in >= 8'h10)) begin
       // pix_count <= 2'b11;

	     if (dut_if.slvx_mode == 2'b01) begin
	
        if(reset_ind & (padding > 0)) begin
          if ((my_pixels[p0][31:24] + my_pixels[p0][23:16] + my_pixels[p0][15:8])/3 > proc_val) begin 
            pix_low[p0][31:8] = 24'hffffff;
          end else  begin
            pix_low[p0][31:8] = 24'h000000;
          end
           if (padding == 2) begin
             if ((my_pixels[p1][31:24] + my_pixels[p1][23:16] + my_pixels[p0][7:0])/3 > proc_val) begin
                pix_low[p0] = {pix_low[p0][31:8], 8'hff};
                pix_low[p1][31:16] = 16'hffff;
            end else begin 
                pix_low[p0] = {pix_low[p0][31:8], 8'h00};
                pix_low[p1][31:16] = 16'h0000;
            end
          end
        
            end else begin
          if ((my_pixels[p0][31:24] + my_pixels[p0][23:16] + my_pixels[p0][15:8])/3 > proc_val) begin 
	      pix_low[p0][31:8] = 24'hffffff;
        end else  begin
          pix_low[p0][31:8] = 24'h000000;
        end
          
	    if ((my_pixels[p1][31:24] + my_pixels[p1][23:16] + my_pixels[p0][7:0])/3 > proc_val) begin
		 pix_low[p0] = {pix_low[p0][31:8], 8'hff};
		 pix_low[p1][31:16] = 16'hffff;
		end else begin 
		 pix_low[p0] = {pix_low[p0][31:8], 8'h00};
		 pix_low[p1][31:16] = 16'h0000;
		end
		
        if ((my_pixels[p2][31:24] + my_pixels[p1][15:8] + my_pixels[p1][7:0])/3 > proc_val) begin
		 pix_low[p1] = {pix_low[p1][31:16], 16'hffff};
		 pix_low[p2][31:24] = 8'hff;
		end else begin 
          pix_low[p1] = {pix_low[p1][31:16], 16'h0000};
		 pix_low[p2][31:24] = 8'h00;
		end
	     
	     if ((my_pixels[p2][23:16] + my_pixels[p2][15:8] + my_pixels[p2][7:0])/3 > proc_val) begin 
	      pix_low[p2] = {pix_low[p2][31:24], 24'hffffff};
          end else  begin
          pix_low[p2] = {pix_low[p2][31:24], 24'h000000};
          end
            end
	      end else if (dut_if.slvx_mode == 2'b10) begin
            if (proc_val[7] == 1'b1) begin
            for (int i=0; i<3; i++) begin
                pix_low[i][31:24] = (my_pixels[i][31:24] < diff_val) ? 8'h00 : (my_pixels[i][31:24] - diff_val);
                pix_low[i][23:16] = (my_pixels[i][23:16] < diff_val) ? 8'h00 : (my_pixels[i][23:16] - diff_val);
                pix_low[i][15:8] = (my_pixels[i][15:8] < diff_val) ? 8'h00 : (my_pixels[i][15:8] - diff_val);
                pix_low[i][7:0] = (my_pixels[i][7:0] < diff_val) ? 8'h00 : (my_pixels[i][7:0] - diff_val);
            end

		end else begin
		 for (int i=0; i<3; i++) begin
                pix_low[i][31:24] = (my_pixels[i][31:24] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][31:24] + diff_val);
                pix_low[i][23:16] = (my_pixels[i][23:16] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][23:16] + diff_val);
                pix_low[i][15:8] = (my_pixels[i][15:8] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][15:8] + diff_val);
                pix_low[i][7:0] = (my_pixels[i][7:0] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][7:0] + diff_val);
            end
		end
	    end				
        
	end
    end
end else if (DW == 64) begin
always @(posedge dut_if.clk) begin
        if (pix_done & (count_in >= 8'h10)) begin
       // pix_count <= 2'b11;
	     if (dut_if.slvx_mode == 2'b01) begin
	     

	     
	      if(reset_ind) begin
             if ((my_pixels[p0][63:56] + my_pixels[p0][55:48] + my_pixels[p0][47:40])/3 > proc_val) begin 
	      pix_high[p0][31:8] = 24'hffffff;
        end else  begin
          pix_high[p0][31:8] = 24'h000000;
        end
        
	    if ((my_pixels[p0][39:32] + my_pixels[p0][31:24] + my_pixels[p0][23:16])/3 > proc_val) begin
		 pix_high[p0] = {pix_high[p0][31:8], 8'hff};
		 pix_low[p0][31:16] = 16'hffff;
		end else begin 
		 pix_high[p0] = {pix_high[p0][31:8], 8'h00};
		 pix_low[p0][31:16] = 16'h0000;
		end
        
            end else begin
	     
        if ((my_pixels[p0][63:56] + my_pixels[p0][55:48] + my_pixels[p0][47:40])/3 > proc_val) begin 
	      pix_high[p0][31:8] = 24'hffffff;
        end else  begin
          pix_high[p0][31:8] = 24'h000000;
        end
        
	    if ((my_pixels[p0][39:32] + my_pixels[p0][31:24] + my_pixels[p0][23:16])/3 > proc_val) begin
		 pix_high[p0] = {pix_high[p0][31:8], 8'hff};
		 pix_low[p0][31:16] = 16'hffff;
		end else begin 
		 pix_high[p0] = {pix_high[p0][31:8], 8'h00};
		 pix_low[p0][31:16] = 16'h0000;
		end

        if ((my_pixels[p1][63:56] + my_pixels[p0][15:8] + my_pixels[p0][7:0])/3 > proc_val) begin
		 pix_low[p0] = {pix_low[p0][31:16], 16'hffff};
		 pix_high[p1][31:24] = 8'hff;
		end else begin 
          pix_low[p0] = {pix_low[p0][31:16], 16'h0000};
		 pix_high[p1][31:24] = 8'h00;
		end
	     
	     if ((my_pixels[p1][55:48] + my_pixels[p1][47:40] + my_pixels[p1][39:32])/3 > proc_val) begin 
	      pix_high[p1] = {pix_high[p1][31:24], 24'hffffff};
          end else  begin
          pix_high[p1] = {pix_high[p1][31:24], 24'h000000};
          end
	          
	    if ((my_pixels[p1][31:24] + my_pixels[p1][23:16] + my_pixels[p1][15:8])/3 > proc_val) begin
		 pix_low[p1][31:8] = 24'hffffff;
		end else begin 
		 pix_low[p1][31:8] = 24'h000000;
		end
		
       if ((my_pixels[p2][63:56] + my_pixels[p2][55:48] + my_pixels[p1][7:0])/3 > proc_val) begin
		 pix_low[p1] = {pix_low[p1][31:8], 8'hff};
		 pix_high[p2][31:16] = 16'hffff;
		end else begin 
          pix_low[p1] = {pix_low[p1][31:8], 8'h00};
		 pix_high[p2][31:16] = 16'h0000;
		end
		
	     if ((my_pixels[p2][47:40] + my_pixels[p2][39:32] + my_pixels[p2][31:24])/3 > proc_val) begin
		 pix_high[p2] = {pix_high[p2][31:16], 16'hffff};
		 pix_low[p2][31:24] = 8'hff;
		end else begin 
          pix_high[p2] = {pix_high[p2][31:16], 16'h0000};
		 pix_low[p2][31:24] = 8'h00;
		end
		
        if ((my_pixels[p2][23:16] + my_pixels[p2][15:8] + my_pixels[p2][7:0])/3 > proc_val) begin 
	      pix_low[p2] = {pix_low[p2][31:24], 24'hffffff};
          end else  begin
          pix_low[p2] = {pix_low[p2][31:24], 24'h000000};
          end
		
    end
	      end else if (dut_if.slvx_mode == 2'b10) begin
            if (proc_val[7] == 1'b1) begin
            for (int i=0; i<3; i++) begin
                pix_low[i][31:24] = (my_pixels[i][31:24] < diff_val) ? 8'h00 : (my_pixels[i][31:24] - diff_val);
                pix_low[i][23:16] = (my_pixels[i][23:16] < diff_val) ? 8'h00 : (my_pixels[i][23:16] - diff_val);
                pix_low[i][15:8] = (my_pixels[i][15:8] < diff_val) ? 8'h00 : (my_pixels[i][15:8] - diff_val);
                pix_low[i][7:0] = (my_pixels[i][7:0] < diff_val) ? 8'h00 : (my_pixels[i][7:0] - diff_val);
                pix_high[i][31:24] = (my_pixels[i][63:56] < diff_val) ? 8'h00 : (my_pixels[i][63:56] - diff_val);
                pix_high[i][23:16] = (my_pixels[i][55:48] < diff_val) ? 8'h00 : (my_pixels[i][55:48] - diff_val);
                pix_high[i][15:8] = (my_pixels[i][47:40] < diff_val) ? 8'h00 : (my_pixels[i][47:40] - diff_val);
                pix_high[i][7:0] = (my_pixels[i][39:32] < diff_val) ? 8'h00 : (my_pixels[i][39:32] - diff_val);
            end
		end else begin
            for (int i=0; i<3; i++) begin
                pix_low[i][31:24] = (my_pixels[i][31:24] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][31:24] + diff_val);
                pix_low[i][23:16] = (my_pixels[i][23:16] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][23:16] + diff_val);
                pix_low[i][15:8] = (my_pixels[i][15:8] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][15:8] + diff_val);
                pix_low[i][7:0] = (my_pixels[i][7:0] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][7:0] + diff_val);
                pix_high[i][31:24] = (my_pixels[i][63:56] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][63:56] + diff_val);
                pix_high[i][23:16] = (my_pixels[i][55:48] > (8'hff - diff_val)) ? 8'hff: (my_pixels[i][55:48] + diff_val);
                pix_high[i][15:8] = (my_pixels[i][47:40] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][47:40] + diff_val);
                pix_high[i][7:0] = (my_pixels[i][39:32] > (8'hff - diff_val)) ? 8'hff : (my_pixels[i][39:32] + diff_val);
            end
		end
	    end				
        
	end
    end
end   

endmodule
