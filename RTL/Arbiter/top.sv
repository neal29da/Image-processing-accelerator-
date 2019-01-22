module top;
    bit clk;
    bit rst_n;
    always #3 clk = !clk;
    initial begin
            rst_n = 0;
        #5  rst_n = 1;
    end
    arb_if arbiterif(clk);
    arbiter a1 (arbiterif);
    arbiter_tb t1 (arbiterif);
    
endmodule
