module processing (if_processing.DUT dut_if);
parameter D_WIDTH = 32;
parameter HEADER_SIZE = 14;

logic [D_WIDTH - 1:0] my_pixels [3];
logic [31:0] count_in, count_out;
logic [31:0] pix_low [3];
logic [31:0] pix_high [3];
logic [31:0] data_size;
logic [7:0] proc_val, diff_val;
logic [1:0] ind_in, ind_out, pix_count;
logic [1:0] p0, p1, p2;
logic [3:0] valid_counter;
bit   pix_done;

//------for eda 
logic [D_WIDTH - 1:0] pix0, pix1,pix2;
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

if (D_WIDTH == 32) begin
  assign  pix_done = ind_in[1] & !ind_in[0] & (count_in >= 8'h10) & (pix_count < 2);
end else begin if (D_WIDTH == 64)         
  assign  pix_done = !ind_in[1] & ind_in[0] & (count_in >= 8'h12) & (pix_count < 2);
end

always @(posedge dut_if.clk or negedge dut_if.rst_n) begin
        if (!dut_if.rst_n || dut_if.mstr_data_cmplt) begin
            dut_if.data_out = 0;
            dut_if.wr = 0;
            dut_if.mstr_data_cmplt = 0;
            count_in = 0;
            count_out = 0;
            pix_count = 0;
            data_size = 0;
            ind_in = 0;
            ind_out = 0;
            valid_counter = 0;
            if (D_WIDTH == 32) begin
                p0 = 2'b10;
                p1 = 2'b00;
                p2 = 2'b01;
            end else begin
                p0 = 2'b01;
                p1 = 2'b10;
                p2 = 2'b00;
            end
        end else begin
        if ((dut_if.slv_mode != 0) && dut_if.slv_data_valid) begin
          valid_counter = {valid_counter[2:0], 1'b1};
          count_in <= count_in + (D_WIDTH >> 5);
          ind_in <= ind_in + 2'b01;
          if (ind_in == 2'b10) ind_in <= 2'b00;
          my_pixels[ind_in] <= dut_if.slv_data;
        end else
            valid_counter = {valid_counter[2:0], 1'b0};
        end
    end

always @(posedge dut_if.clk) begin
  if (valid_counter[3]) begin
    	proc_val <= dut_if.slv_proc_val;
        if (D_WIDTH == 32) begin
            if (count_out == 0) data_size[31:16] = {my_pixels[ind_out][23:16], my_pixels[ind_out][31:24]};
            if (count_out == 1) data_size[15:0] = {my_pixels[ind_out][7:0], my_pixels[ind_out][15:8]};
        end else if (D_WIDTH == 64) begin
            if (count_out == 0) data_size[31:0] = {my_pixels[ind_out][23:16], my_pixels[ind_out][31:24], my_pixels[ind_out][39:32], my_pixels[ind_out][47:40]};
        end
    end
end

always @(posedge dut_if.clk) begin
    if ((count_out == data_size) && dut_if.fifo_empty) dut_if.mstr_data_cmplt <= 1'b1;
    else dut_if.mstr_data_cmplt <= 1'b0;
end

always @(posedge dut_if.clk) begin
    if (!dut_if.mstr_data_cmplt) begin
    if (valid_counter[3] && count_out < HEADER_SIZE) begin     
            ind_out <= ind_out + 2'b01;
            count_out <= count_out + (D_WIDTH >> 5);
            if (ind_out == 2'b10) ind_out <= 2'b00;
            dut_if.data_out = my_pixels[ind_out];   
            dut_if.wr = 1'b1;

    end else if ((count_out >= HEADER_SIZE) && (pix_count != 0) || (valid_counter[0] & valid_counter[1] & valid_counter[2] & valid_counter[3]) ) begin
            pix_count = pix_count - 1'b1;
            ind_out <= ind_out + 2'b01;
            count_out <= count_out + (D_WIDTH >> 5);
            if (ind_out == 2'b10) ind_out <= 2'b00;
            if (D_WIDTH == 32) begin
                dut_if.data_out = pix_low[ind_out];
            end else if (D_WIDTH == 64) begin
                dut_if.data_out = {pix_high[ind_out], pix_low[ind_out]};
            end
            dut_if.wr = 1'b1;    
    end else dut_if.wr = 1'b0;
    end
end

if (D_WIDTH == 32) begin
always @(posedge dut_if.clk) begin
        if (pix_done) begin
        pix_count <= 2'b11;
	     if (dut_if.slv_mode == 2'b01) begin
	      if ((my_pixels[p0][23:16] + my_pixels[p0][15:8] + my_pixels[p0][7:0])/3 > proc_val) begin
	      pix_low[p0][23:0] = 24'hffffff;
        end else pix_low[p0][23:0] = 24'h000000;
        
	      if ((my_pixels[p0][31:24] + my_pixels[p1][15:8] + my_pixels[p1][7:0])/3 > proc_val) begin
		 pix_low[p0] = {8'hff, pix_low[p0][23:0]};
		 pix_low[p1][15:0] = 24'hffffff;
		end else begin 
		 pix_low[p0] = {8'h00, pix_low[p0][23:0]};
		 pix_low[p1][15:0] = 24'h000000;
		end
		
		if ((my_pixels[p1][31:24] + my_pixels[p1][23:16] + my_pixels[p2][7:0])/3 > proc_val) begin
		 pix_low[p2][7:0] = 8'hff;
		 pix_low[p1] = {16'hffffff, pix_low[p1][15:0]};
		end else begin 
		 pix_low[p2][7:0] = 8'h00;
		pix_low[p1] = {16'h000000, pix_low[p1][15:0]};
		end
		
	      if ((my_pixels[p2][31:24] + my_pixels[p2][23:16] + my_pixels[p2][15:8])/3 > proc_val) begin 
	      pix_low[p2] = {24'hffffff, pix_low[p2][7:0]};
          end else  begin
          pix_low[p2] = {24'h000000, pix_low[p2][7:0]};
          end

	      end else if (dut_if.slv_mode == 2'b10) begin
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
end else if (D_WIDTH == 64) begin
always @(posedge dut_if.clk) begin
        if (pix_done) begin
        pix_count <= 2'b11;
	     if (dut_if.slv_mode == 2'b01) begin
	      if ((my_pixels[p0][23:16] + my_pixels[p0][15:8] + my_pixels[p0][7:0])/3 > proc_val) begin
	      pix_low[p0][23:0] = 24'hffffff;
        end else pix_low[p0][23:0] = 24'h000000;
        
          if ((my_pixels[p0][47:40] + my_pixels[p0][39:32] + my_pixels[p0][31:24])/3 > proc_val) begin
          pix_low[p0] = {8'hff, pix_low[p0][23:0]};
	      pix_high[p0][15:0] = 16'hffff;
        end else begin
        pix_low[p0] = {8'h00, pix_low[p0][23:0]};
        pix_high[p0][15:0] = 16'h0000;
        end
        
         if ((my_pixels[p1][7:0] + my_pixels[p0][63:56] + my_pixels[p0][55:48])/3 > proc_val) begin
		 pix_high[p0] = {16'hffff, pix_high[p0][15:0]};
		 pix_low[p1][7:0] = 8'hff;
		end else begin 
		 pix_high[p0] = {16'h0000, pix_high[p0][15:0]};
		 pix_low[p1][7:0] = 8'h00;
		end
        
	      if ((my_pixels[p1][31:24] + my_pixels[p1][23:16] + my_pixels[p1][15:8])/3 > proc_val) begin
		 pix_low[p1] = {24'hffffff, pix_low[p1][7:0]};
		end else begin 
		 pix_low[p1] = {24'h000000, pix_low[p1][7:0]};
		end
		
		if ((my_pixels[p1][55:48] + my_pixels[p1][47:40] + my_pixels[p1][39:32])/3 > proc_val) begin
		 pix_high[p1][23:0] = 24'hffffff;
		end else begin 
		 pix_high[p1][23:0] = 24'h000000;
		end
		
		if ((my_pixels[p2][15:8]  + my_pixels[p2][7:0] + my_pixels[p1][63:56])/3 > proc_val) begin
		 pix_high[p1] = {8'hff, pix_high[p1][23:0]};
		 pix_low[p2][15:0] = 16'hffff;
		end else begin 
		 pix_high[p1] = {8'h00, pix_high[p1][23:0]};
		 pix_low[p2][15:0] = 16'h0000;
		end
		
		if ((my_pixels[p2][39:32] + my_pixels[p2][31:24] + my_pixels[p2][23:16])/3 > proc_val) begin
          pix_low[p2] = {16'hffff, pix_low[p2][15:0]};
	      pix_high[p2][7:0] = 8'hff;
        end else begin
        pix_low[p2] = {16'h0000, pix_low[p2][15:0]};
        pix_high[p2][7:0] = 8'h00;
        end
        
        if ((my_pixels[p2][63:56] + my_pixels[p2][55:48] + my_pixels[p2][47:40])/3 > proc_val) begin
		 pix_high[p2] = {24'hffffff, pix_high[p2][7:0]};
		end else begin 
		 pix_high[p2] = {24'h000000, pix_high[p2][7:0]};
		end
 
	      end else if (dut_if.slv_mode == 2'b10) begin
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
