`timescale 1ns / 1ps

module adctest_tb;
  reg reset; //reset
  reg i_clk; //i_clk
reg [7:0] ja; //ja
wire [3:0] notled; //led 
reg [15:0] dout; //output voltage
reg [15:0] i = 0; //iterator
xadc_test uut( //initializes xadc program
.reset(reset), //reset set to reset
.i_clk(i_clk), //i_clk set to clk
.dout(dout), //dout set to dout
.ja(ja), //ja set to ja 
.led(notled) //led set to notled
);
initial begin
reset = 0; //initialize reset =0
i_clk= 0;  //initialize clk to 0
repeat (65536) begin // repeats an arbitrary number of times
 dout <= i; // dout is set to i
 $display("dout is %h\n", dout); //displays value
 #5 i_clk = 0; //clk ticks
 #5 i_clk = 1;
 i = i + 1; //i iterates
 end
 end
endmodule
