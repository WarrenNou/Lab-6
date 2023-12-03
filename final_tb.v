`timescale 1ns / 1ps

module final_tb;

    reg clk;
    reg en;
    reg Cin;
    reg [3:0] A;
    reg [3:0] B;
    wire [15:0] bcd_d_out;
    wire rdy;

 // Instantiate the module to be tested
    final UUT(
        .clk(clk),
        .en(en),
        .Cin(Cin),
        .A(A),
        .B(B),
        .bcd_d_out(bcd_d_out),
        .rdy(rdy)
    );
    
    
    initial begin
        // Initialize inputs
        clk = 0;
        en = 0;
        Cin = 0;
        A = 0;
        B = 0;

        // Toggle clock
        forever begin
            #10 clk = ~clk;
        end
    end

    initial
    begin
    forever
    begin
        A = 4'd0;
        B =4'd5;
    en = 1;
    #20 //en must catch rising edge of clk
    en = 0;
    #620; 
    
    A = 4'd0;
        B =4'd5;
    en = 1;
    #20
    en = 0;
    #620; 
    
     A = 4'd8;
        B =4'd5;
    en = 1;
    #20
    en = 0;
    #620; 
    
   A = 4'd7;
        B =4'd5;
    en = 1;
    #20
    en = 0;
    #620; 
    
    A = 4'd0;
        B =4'd5;
    en = 1;
    #20
    en = 0;
    #620; 
    
    A = 4'd9;
        B =4'd5;
    en = 1;
    #20
    en = 0;
    #620; 
    
     A = 4'd0;
        B =4'd6;
    en = 1;
    
    #20
    en = 0;
    #1340; 
    
     A = 4'd6;
        B =4'd5;
    en = 1;
    #20
    en = 0;
    #1340; 
    
     A = 4'd2;
        B =4'd5;
    en = 1;
    #20
    en = 0;
    #1340; 
    
     A = 4'd0;
        B =4'd8;
    en = 1;
    #20
    en = 0;
    #1340; 
    
     A = 4'd7;
        B =4'd5;
    en = 1;
    #20
    en = 0;
    
    #1340; 
    
    A = 4'd15;
        B =4'd5;
    en = 1;
    #20
    en = 0;
    #1340; 
    
    A = 4'd10;
        B =4'd5;
    en = 1;
    #20
    en = 0;
    #1340; 
    end
    end


endmodule

