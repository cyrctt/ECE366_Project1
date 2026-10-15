module one_bit_full_adder (A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;

    wire temp1, temp2, temp3;

    xor x1(temp1, A, B);
    xor x2(S, temp1, Cin);

    and a1(temp2, temp1, Cin);
    and a2(temp3, A, B);

    or o1(Cout, temp2, temp3);
endmodule
