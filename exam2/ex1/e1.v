//=================================================================================
// 設計対象回路（CUT：Circuit Under Test）

module OR2 (SW0,SW1,L);		// モジュール名と入力・出力ポート名を記述
  input SW0, SW1;
  output L;
  assign L = SW0|SW1;
endmodule

//=================================================================================
// テストベンチ：CUT にテストパターンを与え，シミュレーション結果を表示させる

`timescale 1 ns / 1 ns		// 時間刻みの設定：最小 1 ns 単位

module OR2_TEST;
  reg SW0,SW1;
  wire L;

  OR2 A(SW0,SW1,L);
  initial begin
    $dumpfile("OR2_TEST.vcd");
    $dumpvars(0);
    $monitor("%4t SW0:%b SW1:%b L:%b",$time, SW0,SW1,L);

    SW0=0;
    SW1=0;

    #10 SW0 = 1;
    #10 SW1 = 1;
    #10 SW0 = 0;
    #10 $finish;
  end
endmodule