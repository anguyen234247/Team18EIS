`timescale 1ns / 1ps
`default_nettype none
module xadc_test(reset, i_clk, ja, led,dout); 
    input wire reset; //reset for eventual total reset protocol when full system integration is complete
    input wire i_clk; //clock
    input [7:0] ja; //input for JA pmod
    output [3:0] led; //LED display outputs
    reg [6:0] daddr = 7'h1E; // address of channel to be read
    
    wire eoc; // xadc end of conversion flag
  input  wire [15:0] dout; // xadc data out bus
    wire drdy; //internal ready signal
    
    reg [1:0] _drdy = 0; // delayed data ready signal for edge detection
    reg [7:0] voltage = 0;   // stored XADC data, only the uppermost byte
              
xadc_wiz_0 myxadc (         //XADC wizard initialization
        .dclk_in        (i_clk), //clock input for XADC wizard
        .den_in         (eoc), // drp enable, start a new conversion whenever the last one has ended
        .dwe_in         (0),   //required XADC input, set to zero 
        .daddr_in       (daddr), // channel address
        .di_in          (0),  //required XADC input, set to zero 
        .do_out         (dout), // data out
        .drdy_out       (drdy), // data ready
        .eoc_out        (eoc), // end of conversion
        
        .vauxn6         (ja[7]),  //negative auxilliary pin #6
        .vauxp6         (ja[3]),  //positive auxialiarry pin #6
        
        .vauxn7         (ja[5]), //negative auxilliary pin #7
        .vauxp7         (ja[1]), //positive auxialiarry pin #7
        
        .vauxn14        (ja[4]), //negative auxilliary pin #14
        .vauxp14        (ja[0]), //positive auxialiarry pin #14
        
        .vauxn15        (ja[6]), //negative auxilliary pin #15
        .vauxp15        (ja[2]) //positive auxialiarry pin #15
    );
    
    
    //initial begin  
    //    f = $fopen("C:/Users/Andrew Nguyen/XADC/output.txt", "w"); //opening the output file    
    //end
    
   always@(posedge i_clk)
        _drdy <= {_drdy[0], drdy}; //delayed data ready shifted left, including previous drdy signal now on right
       

    always@(posedge i_clk) begin
        if ((_drdy == 2'b10)) //on negative edge of drdy signal (cannot use negedge for XADC outputs)
        begin
            voltage <= dout[15:8]; //voltage is set to top 8 bits of XADC data output 
        end
    end 
    
    
    
    //assign led[0] = (voltage >= 8'b00110011) ? 1 : 0; //Original LED implementation, if voltage > 51/256 this turns on
    //assign led[1] = (voltage >= 8'b01100110) ? 1 : 0; //Original LED implementation, if voltage > 102/256 this turns on    
    //assign led[2] = (voltage >= 8'b10011001) ? 1 : 0; //Original LED implementation, if voltage > 153/256 this turns on
    //assign led[3] = (voltage >= 8'b11001100) ? 1 : 0; //Original LED implementation, if voltage > 204/256 this turns on
    
    assign led = voltage[7:4]; //counts up in binary on LEDs to demonstrate voltage values, with top four bits only
endmodule
