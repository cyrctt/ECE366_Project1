module one_bit_full_adder (A, B, Cin, S, Cout);

    input A, B, Cin;
    output reg S, Cout;
    reg temp1, temp2, temp3;

    always @(*) begin
        temp1 = A^B;
        S = temp1 ^ Cin;
        temp2 = temp1 & Cin;
        temp3 = A & B;
        Cout  = temp2 | temp3;
    end
    
endmodule
