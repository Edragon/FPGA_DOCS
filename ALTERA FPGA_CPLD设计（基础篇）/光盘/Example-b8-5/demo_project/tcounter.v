module test_counter;

reg clk, rst;
wire [7:0] count;

counter #(5,10) dut (count,clk,rst);

initial // Clock generator
  begin
    clk = 0;
    #10 forever #10 clk = !clk;
  end
  
initial	// Test stimulus
  begin
    rst = 0;
    #5 rst = 1;
    #4 rst = 0;
    #50000 $stop;
  end
  
initial
    $monitor($stime,, rst,, clk,,, count); 
    
endmodule    
