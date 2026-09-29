module four_bit_RCA_RCS(A, B, Cin, S, Cout);

    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;
    wire [3:0] notB;
    wire C1, C2, C3;

    not (notB[0], B[0]);
    not (notB[1], B[1]);
    not (notB[2], B[2]);
    not (notB[3], B[3]);

    one_bit_full_adder fa0(A[0], notB[0], Cin, S[0], C1);
    one_bit_full_adder fa1(A[1], notB[1], C1,  S[1], C2);
    one_bit_full_adder fa2(A[2], notB[2], C2,  S[2], C3);
    one_bit_full_adder fa3(A[3], notB[3], C3,  S[3], Cout);

endmodule

module one_bit_full_adder (A, B, Cin, S, Cout);

    input A, B, Cin;
    output reg S, Cout;
    reg temp1, temp2, temp3;

    always @(*) begin
        temp1 = A ^ B;
        S = temp1 ^ Cin;
        temp2 = temp1 & Cin;
        temp3 = A & B;
        Cout  = temp2 | temp3;
    end
    
endmodule
