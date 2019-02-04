class sqnc_ip extends uvm_sequence #(trns_ip);
    `uvm_object_utils(sqnc_ip)
    
    string test_type;
    int repeat_count;
    function new(string name = "");
        super.new(name);
    endfunction


    task body;
    

        trns_ip my_trns;
        logic [DW-1:0] my_slv0_data;
        logic [DW-1:0] my_slv1_data;
        integer slv0_input, slv1_input;
        string slv0_file, slv1_file;
        logic [7:0] my_slv0_p_val, my_slv1_p_val;
        logic [1:0] my_slv0_mode, my_slv1_mode;
        integer count, slv0_ind, slv1_ind, my_slv0_image, my_slv1_image;
        logic [1:0] file_end, new_file, close;
        bit my_slv0_ready, my_slv1_ready, my_source, change_mode,my_slv0_old_valid,my_slv1_old_valid;
        integer cur_index, cur_slv, my_mstr0_cmplt, cmplt_count;



        file_end = 2'b00;
        count = 0;
        my_slv0_ready = 1;
        my_slv1_ready = 1;
        slv0_ind = 0;
        slv1_ind = 0;
        cur_slv = 0;
        cur_index = 0;
        my_mstr0_cmplt = 0;
        my_source = 0;
        cmplt_count = 0;
        new_file = 2'b11;
        close = 2'b00;
        while (cmplt_count <= repeat_count) begin
            my_trns = trns_ip::type_id::create("my_trns");
            start_item(my_trns);

        if (!my_trns.randomize()) `uvm_error("", "my_trns randomize failed")
        
        if (!count) begin
                my_trns.slv0_data_valid = 1'b0;
                my_trns.slv1_data_valid = 1'b0;
                my_slv0_p_val = my_trns.slv0_proc_valid;
                my_slv1_p_val = my_trns.slv1_proc_valid;
                my_slv0_mode = my_trns.slv0_mode;
                my_slv1_mode = my_trns.slv1_mode;
                my_slv0_image = my_trns.slv0_image;
                my_slv1_image = my_trns.slv1_image;
          
        end 

	if (my_mstr0_cmplt) begin
		$fclose(slv0_input);
            	file_end[0] = 0;
		$fclose(slv1_input);
                file_end[1] = 0;
                my_slv0_p_val = my_trns.slv0_proc_valid;
                my_slv0_mode = my_trns.slv0_mode;
                my_slv0_image = my_trns.slv0_image;
		my_slv1_p_val = my_trns.slv1_proc_valid;
                my_slv1_mode = my_trns.slv1_mode;
                my_slv1_image = my_trns.slv1_image;
	end
      
          // if both modes are zeroes
          if (change_mode) begin
            my_slv0_mode = my_trns.slv0_mode;
            my_slv1_mode = my_trns.slv1_mode;
          end
          
        if ((my_slv0_mode == 0) & (my_slv1_mode == 0)) change_mode = 1;
            else change_mode = 0;
            
            
           if (!file_end[0]) begin
                $sformat(slv0_file, "input_DUT_img_%0d/im_%0d.txt", DW, my_slv0_image );
                slv0_input=$fopen(slv0_file,"r");
                file_end[0] = 1;
                $fscanf(slv0_input,"%h\n", my_slv0_data);
           end
           
           if (!file_end[1]) begin
                $sformat(slv1_file, "input_DUT_img_%0d/im_%0d.txt",DW, my_slv1_image );
                slv1_input=$fopen(slv1_file,"r");
                file_end[1] = 1;
                $fscanf(slv1_input,"%h\n", my_slv1_data);
           end
    
    
        if (my_slv0_ready & my_slv0_old_valid) begin
            if (!$feof(slv0_input)) $fscanf(slv0_input,"%h\n", my_slv0_data);
        end
        
        if (my_slv1_ready & my_slv1_old_valid) begin
                if (!$feof(slv1_input)) $fscanf(slv1_input,"%h\n", my_slv1_data);
        end
        
      
        
        
           
            my_trns.slv0_data = my_slv0_data;
            my_trns.slv1_data = my_slv1_data;
            my_trns.slv0_proc_valid = my_slv0_p_val;
            my_trns.slv1_proc_valid = my_slv1_p_val;
            my_trns.slv0_mode = my_slv0_mode;
            my_trns.slv1_mode = my_slv1_mode;
          
      count = count + 1;

            finish_item(my_trns);
	    get_response(my_trns);
            my_slv0_ready = my_trns.slv0_ready;
            my_slv1_ready = my_trns.slv1_ready;
            my_slv0_old_valid = my_trns.slv0_data_valid;
            my_slv1_old_valid = my_trns.slv1_data_valid;
            
            my_mstr0_cmplt = my_trns.mstr0_cmplt;
            my_source = my_trns.mstr0_data_valid[1];
//	$display("sqnc time: %t!!!my_slv0_ready: %h, my_slv1_ready: %h ",$time,  my_slv0_ready,my_slv1_ready);
//	$display("sqnc my_mstr0_cmplt: %h ",my_mstr0_cmplt);
/*
	$display("sqnc cmplt_count: %h ",cmplt_count);
	$display("files : %h ",file_end);
      $display("sqnc my_slv0_data: %h ",my_slv0_data);
      $display("sqnc my_slv1_data: %h ",my_slv1_data);
*/
            if (my_mstr0_cmplt) cmplt_count = cmplt_count + 1;
        end 

      
    endtask
endclass
