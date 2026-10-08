module PPA(A, B, Cin, S, Cout);
  
  input [15:0] A, B;
  input Cin;
  output [15:0] S;
  output Cout;
  
  wire [15:0] p_bit = A ^ B;
  wire [15:0] g_bit = A & B;

  wire [15:0] p_layer1;
  wire [15:0] g_layer1;
  
  assign g_layer1[1] = g_bit[1] | (p_bit[1] & g_bit[0]);
  assign p_layer1[1] = p_bit[1] & p_bit[0];
  
  assign g_layer1[3] = g_bit[3] | (p_bit[3] & g_bit[2]);
  assign p_layer1[3] = p_bit[3] & p_bit[2];
  
  assign g_layer1[5] = g_bit[5] | (p_bit[5] & g_bit[4]);
  assign p_layer1[5] = p_bit[5] & p_bit[4];

  assign g_layer1[7] = g_bit[7] | (p_bit[7] & g_bit[6]);
  assign p_layer1[7] = p_bit[7] & p_bit[6];

  assign g_layer1[9] = g_bit[9] | (p_bit[9] & g_bit[8]);
  assign p_layer1[9] = p_bit[9] & p_bit[8];

  assign g_layer1[11] = g_bit[11] | (p_bit[11] & g_bit[10]);
  assign p_layer1[11] = p_bit[11] & p_bit[10];

  assign g_layer1[13] = g_bit[13] | (p_bit[13] & g_bit[12]);
  assign p_layer1[13] = p_bit[13] & p_bit[12];

  assign g_layer1[15] = g_bit[15] | (p_bit[15] & g_bit[14]);
  assign p_layer1[15] = p_bit[15] & p_bit[14];
  
  wire [15:0] g_layer2;
  wire [15:0] p_layer2;
  
  assign g_layer2[3] = g_layer1[3] | (p_layer1[3] & g_layer1[1]);
  assign p_layer2[3] = p_layer1[3] & p_layer1[1];
  
  assign g_layer2[7] = g_layer1[7] | (p_layer1[7] & g_layer1[5]);
  assign p_layer2[7] = p_layer1[7] & p_layer1[5];
  
  assign g_layer2[11] = g_layer1[11] | (p_layer1[11] & g_layer1[9]);
  assign p_layer2[11] = p_layer1[11] & p_layer1[9];
  
  assign g_layer2[15] = g_layer1[15] | (p_layer1[15] & g_layer1[13]);
  assign p_layer2[15] = p_layer1[15] & p_layer1[13];
  
  wire [15:0] g_layer3;
  wire [15:0] p_layer3;
  
  assign g_layer3[7] = g_layer2[7] | (p_layer2[7] & g_layer2[3]);
  assign p_layer3[7] = p_layer2[7] & p_layer2[3];
  
  assign g_layer3[15] = g_layer2[15] | (p_layer2[15] & g_layer2[11]);
  assign p_layer3[15] = p_layer2[15] & p_layer2[11];
  
  wire [15:0] g_layer4;
  wire [15:0] p_layer4;
  
  assign g_layer4[15] = g_layer3[15] | (p_layer3[15] & g_layer3[7]);
  assign p_layer4[15] = p_layer3[15] & p_layer3[7];
  
  wire [16:0] C;
  assign C[0] = Cin;
  
  assign C[1]  = g_bit[0] | (p_bit[0] & C[0]);
  assign C[2]  = g_layer1[1] | (p_layer1[1] & C[0]);
  assign C[3]  = g_bit[2] | (p_bit[2] & C[2]);
  assign C[4]  = g_layer2[3] | (p_layer2[3] & C[0]);
  assign C[5]  = g_bit[4] | (p_bit[4] & C[4]);
  assign C[6]  = g_layer1[5] | (p_layer1[5] & C[4]);
  assign C[7]  = g_bit[6] | (p_bit[6] & C[6]);
  assign C[8]  = g_layer3[7] | (p_layer3[7] & C[0]);
  assign C[9]  = g_bit[8] | (p_bit[8] & C[8]);
  assign C[10] = g_layer1[9] | (p_layer1[9] & C[8]);
  assign C[11] = g_bit[10] | (p_bit[10] & C[10]);
  assign C[12] = g_layer2[11] | (p_layer2[11] & C[8]);
  assign C[13] = g_bit[12] | (p_bit[12] & C[12]);
  assign C[14] = g_layer1[13] | (p_layer1[13] & C[12]);
  assign C[15] = g_bit[14] | (p_bit[14] & C[14]);
  assign C[16] = g_layer4[15] | (p_layer4[15] & C[0]);


  assign S = p_bit ^ C[15:0];
  
  assign Cout = C[16];
  
endmodule