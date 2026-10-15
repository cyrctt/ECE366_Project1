// Testbench for 32-bit CLA (Problem 2b)

module tb_CLA;

  reg  [31:0] A, B;
  reg         Cin;
  wire [31:0] S;
  wire        Cout;

  integer errors = 0;

  CLA dut (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

  //If sub = 1, compute a - b as a + ~b + 1.
  task run_test;
    input [31:0]    a;
    input [31:0]    b;
    input           sub;
    input [31:0]    exp_s;
    input           exp_cout;
    input [8*48:1]  name;
    begin
      A   = a;
      B   = sub ? ~b : b;
      Cin = sub;
      #10;
      $display("%-44s | A=%h B=%h Cin=%b | S=%h Cout=%b | signed: %0d %s %0d = %0d",
               name, A, B, Cin, S, Cout,
               $signed(a), (sub ? "-" : "+"), $signed(b), $signed(S));
      if (S !== exp_s || Cout !== exp_cout) begin
        $display("   ** FAIL: expected S=%h Cout=%b", exp_s, exp_cout);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_CLA);

    run_test(32'd123456, 32'd654321, 0, 32'd777777, 0, "Unsigned add");

    run_test(32'd1000, 32'd250, 1, 32'd750, 1, "Unsigned sub");

    run_test(-32'sd75, 32'sd20, 0, -32'sd55, 0, "Signed add (neg operand)");

    run_test(-32'sd20, -32'sd50, 1, 32'sd30, 1, "Signed sub (neg operands)");

    run_test(32'hFFFFFFFF, 32'h00000001, 0, 32'h00000000, 1, "Carry-out (all 8 blocks)");

    run_test(32'h0000FFFF, 32'h00000001, 0, 32'h00010000, 0, "Multi-block propagate (G in blk 0)");

    A = 32'h00FFFFFF; B = 32'h00000000; Cin = 1; #10;
    $display("%-44s | A=%h B=%h Cin=%b | S=%h Cout=%b",
             "Multi-block propagate (from Cin)", A, B, Cin, S, Cout);
    if (S !== 32'h01000000 || Cout !== 1'b0) begin
      $display("   ** FAIL: expected S=01000000 Cout=0"); errors = errors + 1;
    end

    run_test(32'h7FFFFFFF, 32'h00000001, 0, 32'h80000000, 0, "Signed overflow (extra)");



    if (errors == 0) $display("ALL TESTS PASSED");
    else             $display("%0d TEST(S) FAILED", errors);
    $finish;
  end

endmodule
