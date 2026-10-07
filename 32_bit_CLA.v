module CLA(A, B, Cin, S, Cout);
  
  input [31:0] A, B;
  input Cin;
  output [31:0] S;
  output Cout;
  
  wire [7:0] C, RCA_C;
  
  four_bit_RCA_RCS RCA0(A[3:0], B[3:0], Cin, S[3:0], RCA_C[0]);
  four_bit_CLA_carry CLA0(A[3:0], B[3:0], Cin, C[0]);
  
  four_bit_RCA_RCS RCA1(A[7:4], B[7:4], C[0], S[7:4], RCA_C[1]);
  four_bit_CLA_carry CLA1(A[7:4], B[7:4], C[0], C[1]);
  
  four_bit_RCA_RCS RCA2(A[11:8], B[11:8], C[1], S[11:8], RCA_C[2]);
  four_bit_CLA_carry CLA2(A[11:8], B[11:8], C[1], C[2]);
  
  four_bit_RCA_RCS RCA3(A[15:12], B[15:12], C[2], S[15:12], RCA_C[3]);
  four_bit_CLA_carry CLA3(A[15:12], B[15:12], C[2], C[3]);
  
  four_bit_RCA_RCS RCA4(A[19:16], B[19:16], C[3], S[19:16], RCA_C[4]);
  four_bit_CLA_carry CLA4(A[19:16], B[19:16], C[3], C[4]);
  
  four_bit_RCA_RCS RCA5(A[23:20], B[23:20], C[4], S[23:20], RCA_C[5]);
  four_bit_CLA_carry CLA5(A[23:20], B[23:20], C[4], C[5]);
  
  four_bit_RCA_RCS RCA6(A[27:24], B[27:24], C[5], S[27:24], RCA_C[6]);
  four_bit_CLA_carry CLA6(A[27:24], B[27:24], C[5], C[6]);
  
  four_bit_RCA_RCS RCA7(A[31:28], B[31:28], C[6], S[31:28], RCA_C[7]);
  four_bit_CLA_carry CLA7(A[31:28], B[31:28], C[6], Cout);
  
endmodule


module four_bit_CLA_carry(A, B, Cin, Cout);
  
  input [3:0] A, B;
  input Cin;
  output Cout;

  wire [3:0] G, P;
  wire [9:0] temp;
  
  and (G[0], A[0], B[0]);
  and (G[1], A[1], B[1]);
  and (G[2], A[2], B[2]);
  and (G[3], A[3], B[3]);
  
  or (P[0], A[0], B[0]);
  or (P[1], A[1], B[1]);
  or (P[2], A[2], B[2]);
  or (P[3], A[3], B[3]);
  
  // P 3:0
  and (temp[0], P[3], P[2]);
  and (temp[1], temp[0], P[1]);
  and (temp[2], temp[1], P[0]);
  
  // G 3:0
  and (temp[3], P[3], G[2]);
  and (temp[4], temp[0], G[1]);
  and (temp[5], temp[1], G[0]);
  
  or (temp[6], G[3], temp[3]);
  or (temp[7], temp[6], temp[4]);
  or (temp[8], temp[7], temp[5]);
  
  and (temp[9], temp[2], Cin);
  or (Cout, temp[9], temp[8]);
  
endmodule


module four_bit_RCA_RCS(A, B, Cin, S, Cout);

  input [3:0] A, B;
  input Cin;
  output [3:0] S;
  output Cout;
  wire C1, C2, C3;
  
  one_bit_full_adder fa0(A[0], B[0], Cin, S[0], C1);
  one_bit_full_adder fa1(A[1], B[1], C1, S[1], C2);
  one_bit_full_adder fa2(A[2], B[2], C2, S[2], C3);
  one_bit_full_adder fa3(A[3], B[3], C3, S[3], Cout);

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
