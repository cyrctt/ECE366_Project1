`timescale 1ns/1ps

module testbench;
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] S;
    wire Cout;

    four_bit_RCA_RCS DUT(A, B, Cin, S, Cout);

    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0, testbench);
        $monitor("Time=%0t A=%b B=%b Cin=%b S=%b Cout=%b",
                 $time, A, B, Cin, S, Cout);

        A = 4'b0101; B = 4'b0011; Cin = 0; // Unsigned: 5 + 3 = 8
        #10;

        A = 4'b1101; B = 4'b0101; Cin = 0; // Signed: -3 + 5 = 2
        #10;

        A = 4'b1111; B = 4'b0001; Cin = 0; // Carry-out: 15 + 1 = 16
        #10;

        $finish;
    end
endmodule
