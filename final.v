`timescale 1ns / 1ps

module bin2BCD(
    input clk,
    input en,
    input [11:0] bin_d_in,
    output [15:0] bcd_d_out,
    output  rdy
);

    // State variables
    parameter IDLE = 3'b000;
    parameter SETUP = 3'b001;
    parameter ADD = 3'b010;
    parameter SHIFT = 3'b011;
    parameter DONE = 3'b100;

    //reg [11:0] bin_data = 0;
    reg [27:0] bcd_data = 0;
    reg [2:0] state = 0;
    reg busy = 0;
    reg [3:0] sh_counter = 0;
    reg [1:0] add_counter = 0;
    reg result_rdy = 0;
always @(posedge clk)
       begin
       if(en)
        begin
            if(~busy)
                begin
                bcd_data <= {16'b0, bin_d_in};
                state <= SETUP;
            end
        
        end
        
        case(state)
        
        IDLE:
         begin
            result_rdy <= 0;
            busy <= 0;
         end
        
        SETUP:
        begin
        busy <= 1;
        state <= ADD;
        end
        
        ADD:
            begin
        
        case(add_counter)
       0:
        begin
        if(bcd_data[15:12] > 4)
            begin
                bcd_data[27:12] <= bcd_data[27:12] + 3;
            end
            add_counter <= add_counter + 1;
        end
        
       1:
        begin
        if(bcd_data[19:16] > 4)
            begin
                bcd_data[27:16] <= bcd_data[27:16] + 3;
            end
            add_counter <= add_counter + 1;
        end
        
       2:
        begin
        if((add_counter == 2) && (bcd_data[23:20] > 4))
            begin
                bcd_data[27:20] <= bcd_data[27:20] + 3;
        end
        add_counter <= add_counter + 1;
       end
        
       3:
        begin
        if((add_counter == 3) && (bcd_data[27:24] > 4))
            begin
                bcd_data[27:24] <= bcd_data[27:24] + 3;
            end
            add_counter <= 0;
            state <= SHIFT;
        end
       endcase
       end
        
       SHIFT:
        begin
        sh_counter <= sh_counter + 1;
        bcd_data <= bcd_data << 1;
        
       if(sh_counter == 11)
        begin
        sh_counter <= 0;
        state <= DONE;
        end
       else
        begin
        state <= ADD;
        end
        
        end
        
       DONE:
        begin
        result_rdy <= 1;
        state <= IDLE;
        end
       default:
        begin
        state <= IDLE;
        end
        
        endcase

    end
assign bcd_d_out = bcd_data[27:12];
assign rdy = result_rdy;


endmodule
module carry_lookahead_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
    );

    wire [3:0] P, G;
    wire [3:0] C;
    assign P = A ^ B;
    assign G = A & B;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);

    assign S = P ^ C;
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);
    
endmodule
module final(
    input Cin,
    input [3:0] A,
    input [3:0] B,
    input en,
    input clk,
    output  [15:0] bcd_d_out,
    output  rdy
    
);

    wire [3:0] S;
    wire [3:0] Cout;

    
        carry_lookahead_adder uut1(.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));
    wire [11:0] bin_d_in;
    assign bin_d_in ={ 7'b0000000, Cout, S};
        bin2BCD uut2(.clk(clk), .en(en), .bin_d_in(bin_d_in), .bcd_d_out(bcd_d_out), .rdy(rdy));
   
endmodule


