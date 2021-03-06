`timescale 1 ns / 1 ns

module BCD_COUNT(CK, CE, AR, CO, Q); // CE = 1 で CK = 0 から CK = 1 に立ち上がるとカウントアップ
    input CK, CE, AR;
    output CO;
    reg CO;
    output [3:0] Q;
    reg [3:0] Q;

    always @ (posedge CK or negedge AR)
    begin
        if(~AR | Q[3]&Q[0]&CE)
            Q = 0;
        else if(CE)
            Q = Q+1;

        CO = Q[3]&Q[0]&CE;
    end
endmodule

module BCD2_COUNT(CK, CE, AR, CO, Q); // Q：8 bit（BCD 4 bit x 2 桁分），他は 3c) と同様
    input CK, CE, AR;
    output CO;
    output [7:0] Q;

    wire [3:0] upper, lower;
    wire co1, co2;

    BCD_COUNT BC1(CK, CE, AR, co1, lower);
    BCD_COUNT BC2(~co1, CE, AR, co2, upper);

    assign Q[7:4] = upper;
    assign Q[3:0] = lower;
    assign CO = Q[7]&Q[4]&Q[3]&Q[0];
endmodule

module bcd2_test;
    reg CK ,CE, AR;
    wire CO;
    wire [7:0] Q;

    BCD2_COUNT bc2 (CK, CE, AR, CO, Q);

    initial begin;
        $dumpfile("test.vcd");
        $dumpvars(0);
        $monitor("%4t CK:%b CE:%b AR:%b CO:%b Q:%b",$time, CK, CE, AR, CO, Q);

        CK = 0;
        CE = 0;
        AR = 1;
        #1 AR = 0;
        #1 AR = 1;
        CE = 1;
        #8 AR = 0;
        #1 AR = 1;
        //#1 AR = 0;
        /*
        #4 AR = 1;
           CE = 1;
        #20 CE = 0;
        #20 CE = 1;
        #155 CE = 0;
        #20 CE = 1;
        #39 AR = 0;
        #1 AR = 1;
        #20 $finish;
        */
        #500 $finish;
    end

    always #2
        CK <= ~CK;
endmodule