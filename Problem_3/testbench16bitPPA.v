`timescale 1ns/1ps

module tb_PPA;

  reg [15:0] A, B;
  reg Cin;
  wire [15:0] S;
  wire Cout;

  integer errors = 0;

  PPA dut (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

  // sub = 1 performs subtraction using a + ~b + 1
  task run_test;
    input [15:0] a;
    input [15:0] b;
    input sub;
    input [15:0] exp_s;
    input exp_cout;
    input [8*48:1] name;
    begin
      A = a;
      B = sub ? ~b : b;
      Cin = sub;
      #10;

      $display("%-48s | A=%h B=%h Cin=%b | S=%h Cout=%b",
               name, A, B, Cin, S, Cout);

      if (S !== exp_s || Cout !== exp_cout) begin
        $display("  FAIL: expected S=%h Cout=%b", exp_s, exp_cout);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    $dumpfile("ppa.vcd");
    $dumpvars(0, tb_PPA);

    // Unsigned addition: 1234 + 4321 = 5555
    run_test(16'd1234, 16'd4321, 0, 16'd5555, 0,
             "Unsigned add");

    // Unsigned subtraction: 1000 - 250 = 750
    run_test(16'd1000, 16'd250, 1, 16'd750, 1,
             "Unsigned sub");

    // Signed addition: -75 + 20 = -55
    run_test(-16'sd75, 16'sd20, 0, -16'sd55, 0,
             "Signed add (negative operand)");

    // Signed subtraction: -20 - (-50) = 30
    run_test(-16'sd20, -16'sd50, 1, 16'd30, 1,
             "Signed sub (negative operands)");

    // Carry-out: 65535 + 1 = 65536
    run_test(16'hFFFF, 16'h0001, 0, 16'h0000, 1,
             "Carry-out (all 16 bits)");

    // Carry crosses multiple 4-bit boundaries
    run_test(16'h0FFF, 16'h0001, 0, 16'h1000, 0,
             "Multi-block carry propagation");

    // Carry propagation starting from Cin
    A = 16'h0FFF;
    B = 16'h0000;
    Cin = 1;
    #10;

    $display("Carry propagation from Cin | A=%h B=%h Cin=%b | S=%h Cout=%b",
             A, B, Cin, S, Cout);

    if (S !== 16'h1000 || Cout !== 1'b0) begin
      $display("  FAIL: expected S=1000 Cout=0");
      errors = errors + 1;
    end

    // Extra: signed overflow without unsigned carry-out
    run_test(16'h7FFF, 16'h0001, 0, 16'h8000, 0,
             "Signed overflow");

    if (errors == 0)
      $display("ALL TESTS PASSED");
    else
      $display("%0d TEST(S) FAILED", errors);

    $finish;
  end

endmodule
