`timescale 1ns/1ps

module testbench;
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] S;
    wire Cout;

    four_bit_RCA_RCS DUT(A, B, Cin, S, Cout);

    initial begin
        $dumpfile("subtractor.vcd");
        $dumpvars(0, testbench);

        A = 4'b1001;
        B = 4'b0100;
        Cin = 1;
        #10; // Unsigned: 9 - 4 = 5

        A = 4'b1101;
        B = 4'b1110;
        Cin = 1;
        #10; // Signed: -3 - (-2) = -1

        $finish;
    end
endmodule
