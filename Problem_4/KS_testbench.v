`timescale 1ns/1ps

module KS_tb;

  reg  [15:0] A, B;
  reg         Cin;
  wire [15:0] S;
  wire        Cout;

  KS dut (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

  reg  [16:0] expected;
  integer     errors = 0;
  integer     i;

  // Apply one vector, wait, and compare {Cout,S} against A + B + Cin.
  // Subtraction X - Y is done as X + ~Y + 1 (pass B = ~Y, Cin = 1).
  task run;
    input [15:0]    a, b;
    input           c;
    input [8*40:1]  label;
    begin
      A = a; B = b; Cin = c;
      #10;
      expected = a + b + c;
      if ({Cout, S} === expected)
        $display("PASS  %-40s A=%h B=%h Cin=%b | S=%h (%0d signed) Cout=%b",
                 label, A, B, Cin, S, $signed(S), Cout);
      else begin
        $display("FAIL  %-40s A=%h B=%h Cin=%b | S=%h Cout=%b  expected S=%h Cout=%b",
                 label, A, B, Cin, S, Cout, expected[15:0], expected[16]);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, KS_tb);

    // ---- Required cases ----
    run(16'd1000,  16'd2345,  1'b0, "Unsigned add: 1000 + 2345 = 3345");
    run(16'd5000, ~16'd1234,  1'b1, "Unsigned sub: 5000 - 1234 = 3766");
    run(16'd100,   -16'sd250, 1'b0, "Signed add: 100 + (-250) = -150");
    run(-16'sd300, ~(-16'sd125), 1'b1, "Signed sub: -300 - (-125) = -175");
    run(16'hFFFF,  16'h0001,  1'b0, "Carry out: FFFF + 0001");

    // ---- Carry propagation across multiple 4-bit blocks ----
    run(16'h0FFF,  16'h0001,  1'b0, "Propagate 3 blocks: 0FFF + 0001");
    run(16'hFFFF,  16'h0000,  1'b1, "Cin ripples all 16 bits: FFFF+0+1");
    run(16'h00FF,  16'h0F01,  1'b0, "Propagate: 00FF + 0F01");

    // ---- Extra edge cases ----
    run(16'h7FFF,  16'h0001,  1'b0, "Signed overflow: 7FFF + 1");
    run(16'h8000,  16'h8000,  1'b0, "Neg overflow + carry: 8000 + 8000");
    run(16'hFFFF,  16'hFFFF,  1'b1, "Max: FFFF + FFFF + 1");
    run(16'h0000,  16'h0000,  1'b0, "Zero: 0 + 0");
    run(16'hAAAA,  16'h5555,  1'b0, "Alternating: AAAA + 5555");
    run(16'hAAAA,  16'h5555,  1'b1, "Alternating + Cin: AAAA + 5555 + 1");

    // ---- Random self-check ----
    for (i = 0; i < 1000; i = i + 1) begin
      A = $random; B = $random; Cin = $random;
      #10;
      expected = A + B + Cin;
      if ({Cout, S} !== expected) begin
        $display("FAIL  random A=%h B=%h Cin=%b | S=%h Cout=%b expected %h_%b",
                 A, B, Cin, S, Cout, expected[15:0], expected[16]);
        errors = errors + 1;
      end
    end

    $display("----------------------------------------------");
    if (errors == 0) $display("ALL TESTS PASSED (14 directed + 1000 random)");
    else             $display("%0d TEST(S) FAILED", errors);
    $finish;
  end

endmodule
