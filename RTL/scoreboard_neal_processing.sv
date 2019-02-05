/////////////////////////////////////////////////////////////////////////////	//
//          TIME: 2019-01-22 15:08:30					//
//          FILE: processing_scoreboard.sv						//
//          Engineer: Neal DAHAN					//
//          Compagny: ITC								//
///////////////////////////////////////////////////////////////////////////	//

class scoreboard_processing extends uvm_component;
  `uvm_component_utils( scoreboard_processing )

  uvm_analysis_export  #( transaction_processing ) expected_analysis_export;
  uvm_analysis_export  #( transaction_processing )   actual_analysis_export;
  uvm_tlm_analysis_fifo#( transaction_processing ) expected_fifo_processing;
  uvm_tlm_analysis_fifo#( transaction_processing )   actual_fifo_processing;
  transaction_processing expected_transaction_processing;
  transaction_processing   actual_transaction_processing;
  // Function: new
  //-------------------------------------------------------------------------
  function new( string name, uvm_component parent );
    super.new( name, parent );
    actual_transaction_processing    = new("actual_transaction_processing");
    expected_transaction_processing  = new("expected_transaction_processing");
  endfunction: new

  // Function: build_phase
  //-------------------------------------------------------------------------
  function void build_phase( uvm_phase phase );
    super.build_phase( phase );

    expected_analysis_export = new( "expected_analysis_export", this );
    actual_analysis_export = new(   "actual_analysis_export", this );
    expected_fifo_processing = new( "expected_fifo_processing", this );
    actual_fifo_processing = new(   "actual_fifo_processing", this );
  endfunction: build_phase

  // Function: connect_phase
  //-------------------------------------------------------------------------
  function void connect_phase( uvm_phase phase );
    super.connect_phase( phase );

    expected_analysis_export.connect( expected_fifo_processing.analysis_export );
    actual_analysis_export.connect(   actual_fifo_processing.analysis_export );

  endfunction: connect_phase

  // Task: run_phase
  //-------------------------------------------------------------------------
  task run_phase( uvm_phase phase );

    parameter DW = 32;

    logic [DW-1:0] new_data;
    logic [DW-1:0] out_p1,out_p2,out_p3;
    logic [DW-1:0] R1,G1,B1,R2,G2,B2,R3,G3,B3,R4,G4,B4,alpha;
    logic [DW-1:0] my_data [2:0];
    logic [DW-1:0] data_in [14:0];
    logic [DW-1:0] pre_p1;
    logic [DW-1:0] sec_p1;
    integer count_transaction;
    integer pos_out;
    integer error;
    integer k;
    integer i;
    integer j;
    logic [2:0]  start;
    start = 0;
    count_transaction = 0;
    pos_out = 0;
    error = 0;
    i = 0;
    j = 0;
    k = 0;

    //  int az = 0;
    `uvm_info("pass", {"Test: SCRY!"}, UVM_LOW);
    forever begin
      //`uvm_info("pass", {"Test: SCRY!"}, UVM_LOW);
      expected_fifo_processing.get(expected_transaction_processing );
      actual_fifo_processing.get(actual_transaction_processing );
      if(count_transaction != 0) 
        begin
          data_in[i] = actual_transaction_processing.slv_data;
        end
      else begin
        count_transaction = count_transaction  + 1;
      end
            
      //========FIRST CHECK===========/
      if (count_transaction < 4) begin
        if(actual_transaction_processing.data_out != 0) begin
          `uvm_info(" ", $sformatf("ERROR TRANSACTION: DATA=%h count =%d == nb of error=%d",actual_transaction_processing.data_out,count_transaction,error), UVM_LOW);
          error = error + 1;
          end
        else if (actual_transaction_processing.data_out == 0) `uvm_info(" ", $sformatf("FIRST CHECK DATA=%h count =%d == nb of error=%d",actual_transaction_processing.data_out,count_transaction,error), UVM_LOW);
        
        end
      
      //===============================/
      //========HEADER CHECK===========/
      if (count_transaction > 3 && count_transaction < 20) 
      
        begin
          if(actual_transaction_processing.data_out != data_in[i]) begin
            `uvm_info(" ", $sformatf("ERROR TRANSACTION: GET=%h EXCEPT=%h  count =%d == nb of error=%d",actual_transaction_processing.data_out,data_in[j],count_transaction,error), UVM_LOW);
          end
          else if (actual_transaction_processing.data_out == data_in[i]) begin
            `uvm_info(" ", $sformatf("OK: HEADER CHECK GET=%h EXCEPT=%h  count =%d == nb of error=%d",actual_transaction_processing.data_out,data_in[j],count_transaction,error), UVM_LOW);
          end
          j = j + 1;
        end
      i = i + 1;
      //===============================/
      count_transaction = count_transaction  + 1;
      //`uvm_info(" ", $sformatf("MODE =%h ",actual_transaction_processing.slv_mode), UVM_LOW);
      if(count_transaction > 16 ) begin
       // if (count_transaction > 16 && count_transaction < 55) begin
         my_data[k] = actual_transaction_processing.slv_data  ;
        //if (k==0) `uvm_info(" ", $sformatf("my_data[k]=%h , slv_data =%h , k=%d",my_data[0],actual_transaction_processing.slv_data ,k), UVM_LOW);
          k = k + 1;
          if (k == 3) begin
            //=====First PIXEL
            R1 = my_data[0] & 32'hFF000000;
            G1 = my_data[0] & 32'h00FF0000;
            B1 = my_data[0] & 32'h0000FF00;
            //=====SECONDE PIXEL
            R2 = my_data[0] & 32'h000000FF;
            G2 = my_data[1] & 32'hFF000000;
            B2 = my_data[1] & 32'h00FF0000;
            //=====THIRD PIXEL
            R3 = my_data[1] & 32'h0000FF00;
            G3 = my_data[1] & 32'h000000FF;
            B3 = my_data[2] & 32'hFF000000;
            //==+==== FOURTH PIXEL
            R4 = my_data[2] & 32'h00FF0000;
            G4 = my_data[2] & 32'h0000FF00;
            B4 = my_data[2] & 32'h000000FF;
            k = 0;
            pos_out = 0;
            pos_out = pos_out + 1;
          end
       
    
          // DATAOUT = 1
          if (pos_out == 1) begin
          alpha = ((R1+G1+B1)/3);
            if (((R1+G1+B1)/3) > actual_transaction_processing.slv_proc_val) begin
            pre_p1 = 24'hFFFFFF;
            
            end
            else  pre_p1 = 24'h000000 ; 
            if (((R2+G2+B2)/3) > actual_transaction_processing.slv_proc_val) sec_p1 = 8'hFF; 
            else  sec_p1 =  8'h00;
            out_p1 = sec_p1 >> pre_p1;      
           end
           end
          //========DATA Check===========/
    if (count_transaction > 19) begin
        if(actual_transaction_processing.data_out > actual_transaction_processing.slv_proc_val) begin
            if(actual_transaction_processing.data_out != 32'hFFFFFFFF) begin
            `uvm_info(" ", $sformatf("19: GET=%h EXCEPTED=FFFFFFFF  count =%d == nb of error=%d",actual_transaction_processing.data_out,count_transaction,error), UVM_LOW);
            `uvm_info(" ", $sformatf("R1 = %h,G1 = %h, B1 = %h, alpha = %h ",R1,G1,B1,alpha), UVM_LOW);
            `uvm_info(" ", $sformatf("out_p1 = %h,sec_p1 = %h, pre_p1 = %h,",out_p1,sec_p1,pre_p1), UVM_LOW);
            `uvm_info(" ", $sformatf("mydata[0] = %h,mydata[1] = %h, mydata[2]= %h,mydata[3]= %h",my_data[0],my_data[1] ,my_data[2],my_data[3]), UVM_LOW);
            end
    end
    else if(actual_transaction_processing.data_out < actual_transaction_processing.slv_proc_val) begin
            if(actual_transaction_processing.data_out != 0) begin
            `uvm_info(" ", $sformatf("19: GET=%h EXCEPTED=00000000  count =%d == nb of error=%d",actual_transaction_processing.data_out,count_transaction,error), UVM_LOW);
            `uvm_info(" ", $sformatf("R1 = %h,G1 = %h, B1 = %h, alpha = %h ",R1,G1,B1,alpha), UVM_LOW);
            `uvm_info(" ", $sformatf("out_p1 = %h,sec_p1 = %h, pre_p1 = %h,",out_p1,sec_p1,pre_p1), UVM_LOW);
            end
    end
    //count_transaction = count_transaction  + 1;
    end
    //===============================/


          if (count_transaction == 19) 
            begin
            `uvm_info(" ", $sformatf("k = %d ",k), UVM_LOW);
              `uvm_info(" ", $sformatf("19: GET=%h  count =%d == nb of error=%d",actual_transaction_processing.data_out,count_transaction,error), UVM_LOW);
            end
         
end
        endtask
        virtual function void compare();


        endfunction




        endclass