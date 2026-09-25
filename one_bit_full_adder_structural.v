module one_bit_full_adder (a, b, cin, s, cout)
    input a, b, cin;
    output s, cout;

    wire temp1, temp2, temp3;

    xor x1(temp1, a, b);
    xor x2(s, temp1, cin);

    and a1(temp2, temp1, cin);
    and a2(temp3, a, b);

    or o1(cout, temp2, temp3);
endmodule