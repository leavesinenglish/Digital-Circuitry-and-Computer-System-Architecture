`timescale 1ns / 1ps

module tb_BTBCD();
    
logic clock, reset, start;

logic [15:0] bin = 16'b0000101101001011; //example of binary to convert
       
logic [15:0] bcdout = 16'b0;


    Binary_To_BCD dut(.Clock(clock), .Reset(reset), .Start(start), .Binary(bin), .Out(bcdout));
always begin
      clock = 1'b0;#5;
      clock = 1'b1;#5;
  end
  
    initial begin
        reset = 1'b1; #10;
        start = 1'b1; #20;
        reset = 1'b0; #500;
        start = 1'b0;
    $finish;
    end;

endmodule
