module one_bit_full_adder (a, b, cin, s, cout);

    input a, b, cin;
    output reg s, cout;
    reg temp1, temp2, temp3;

    always @(*) begin
        temp1 = a^b;
        s = temp1 ^ cin;
        temp2 = temp1 & cin;
        temp3 = a & b;
        cout  = temp2 | temp3;
    end
    
endmodule