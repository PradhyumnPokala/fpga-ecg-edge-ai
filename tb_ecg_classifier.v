`timescale 1ns/1ps
module tb_ecg_classifier;

    reg [7:0] feature_0, feature_1, feature_2, feature_3, feature_4;
    reg [7:0] feature_9, feature_12, feature_18, feature_22, feature_26;
    reg [7:0] feature_27, feature_35, feature_36, feature_43, feature_56;
    reg [7:0] feature_64, feature_68, feature_77, feature_87, feature_101;
    reg [7:0] feature_134;
    wire [2:0] class_out;
    integer pass_count, fail_count;

    ecg_classifier uut (
        .feature_0(feature_0), .feature_1(feature_1), .feature_2(feature_2),
        .feature_3(feature_3), .feature_4(feature_4), .feature_9(feature_9),
        .feature_12(feature_12), .feature_18(feature_18), .feature_22(feature_22),
        .feature_26(feature_26), .feature_27(feature_27), .feature_35(feature_35),
        .feature_36(feature_36), .feature_43(feature_43), .feature_56(feature_56),
        .feature_64(feature_64), .feature_68(feature_68), .feature_77(feature_77),
        .feature_87(feature_87), .feature_101(feature_101), .feature_134(feature_134),
        .class_out(class_out)
    );

    task apply_test;
        input [7:0] f0,f1,f2,f3,f4,f9,f12,f18,f22,f26,f27,f35,f36,f43,f56,f64,f68,f77,f87,f101,f134;
        input [2:0] expected;
        input [8*20:1] label;
        begin
            {feature_0,feature_1,feature_2,feature_3,feature_4,feature_9,feature_12,
             feature_18,feature_22,feature_26,feature_27,feature_35,feature_36,feature_43,
             feature_56,feature_64,feature_68,feature_77,feature_87,feature_101,feature_134}
            = {f0,f1,f2,f3,f4,f9,f12,f18,f22,f26,f27,f35,f36,f43,f56,f64,f68,f77,f87,f101,f134};
            #10;
            if (class_out === expected) begin
                $display("PASS | %s | got=%0d", label, class_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %s | got=%0d expected=%0d", label, class_out, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        pass_count=0; fail_count=0;
        $display("=== ECG Classifier Testbench: All 31 Leaf Paths ===");

        // f0  f1  f2  f3  f4  f9  f12 f18 f22 f26 f27 f35 f36 f43 f56 f64 f68 f77 f87 f101 f134  exp  label
        apply_test(128,100,128,128,128, 20,128,128,128,128,128,128,128,128, 10,128,128,  5,  0,128,128, 3'd1, "P01_Supraventricular");
        apply_test(128,100,128,128,128, 20,128,128,128,128,128,128,128,128, 10,128,128, 20,  0,128,128, 3'd0, "P02_Normal          ");
        apply_test(128,220,128,128,128, 20,128,  5,128,128,128,128,128,128, 10,128,128,128,  0,128,128, 3'd3, "P03_Fusion          ");
        apply_test(128,220,128,128,128, 20,128, 20,128,128,128,128,128,128, 10,128,128,128,  0,128,128, 3'd0, "P04_Normal          ");
        apply_test(128,128,128, 20,128, 20, 10,128,128,128,128,128,128,128, 50,128,128,128,  0,128,128, 3'd3, "P05_Fusion          ");
        apply_test(128,128,128, 20,128, 20, 30,128,128,128,128,128,128,128, 50,128,128,128,  0,128,128, 3'd0, "P06_Normal          ");
        apply_test(128,128,128, 50,128, 20,128,128,128,128,128,128,128, 50, 50,128,128,128,  0,128,128, 3'd3, "P07_Fusion          ");
        apply_test(128,128,128, 50,128, 20,128,128,128,128,128,128,128,100, 50,128,128,128,  0,128,128, 3'd2, "P08_Ventricular     ");
        apply_test(128,128,128, 10,128, 60,128,128,100,128,128,128,128,128,128,128, 10,128,  0,128,128, 3'd1, "P09_Supraventricular");
        apply_test(128,128,128, 10,128, 60,128,128,100,128,128,128,128,128,128,128, 50,128,  0,128,128, 3'd0, "P10_Normal          ");
        apply_test(128, 50,128, 10,128, 60,128,128,150,128,128,128,128,128,128,128,128,128,  0,128,128, 3'd2, "P11_Ventricular     ");
        apply_test(128,100,128, 10,128, 60,128,128,150,128,128,128,128,128,128,128,128,128,  0,128,128, 3'd0, "P12_Normal          ");
        apply_test(200,128,128, 50,128,100,128,128,128,128,128,128,128,128,128,128,128,128,  0,128,128, 3'd2, "P13_Ventricular     ");
        apply_test(255,128,128, 50,128,100,128,128,128,128,128,128,128,128,128,128,128,128,  0,128,128, 3'd0, "P14_Normal          ");
        apply_test(128,128,128, 50,100,200,128,128,128,128,128,128,128,128,128,128,128,128,  0,128,128, 3'd1, "P15_Supraventricular");
        apply_test(128,128,128, 50,200,200,128,128,128,128,128,128,128,128,128,128,128,128,  0,128,128, 3'd3, "P16_Fusion          ");
        apply_test(100,128,128, 50,128,128,128,128,128,128,128, 50,128,128,128,128,128,128, 10,128,128, 3'd1, "P17_Supraventricular");
        apply_test(100,128,100, 50,128,128,128,128,128,128,128,100,128,128,128,128,128,128, 10,128,128, 3'd2, "P18_Ventricular     ");
        apply_test(100,128,200, 50,128,128,128,128,128,128,128,100,128,128,128,128,128,128, 10,128,128, 3'd0, "P19_Normal          ");
        apply_test(210,128,128, 50,128,128,128,128,128,128,  5,128,100,128,128,128,128,128, 10,128,128, 3'd1, "P20_Supraventricular");
        apply_test(210,128,128, 50,128,128,128,128,128,128, 50,128,100,128,128,128,128,128, 10,128,128, 3'd0, "P21_Normal          ");
        apply_test(210,128, 80, 50,128,128,128,128,128,128,128,128,150,128,128,128,128,128, 10,128,128, 3'd1, "P22_Supraventricular");
        apply_test(210,128,150, 50,128,128,128,128,128,128,128,128,150,128,128,128,128,128, 10,128,128, 3'd2, "P23_Ventricular     ");
        apply_test(128,100,100,100,128,128,128,128,128,128,128,128,128,128,128,128,128,128, 10, 50,128, 3'd4, "P24_Pacemaker       ");
        apply_test(128,200,100,100,128,128,128,128,128,128,128,128,128,128,128,128,128,128, 10, 50,128, 3'd0, "P25_Normal          ");
        apply_test(128,128,200,100,128,128,128,128,128,128, 20,128,128,128,128,128,128,128, 10, 50,128, 3'd2, "P26_Ventricular     ");
        apply_test(128,128,200,100,128,128,128,128,128,128,100,128,128,128,128,128,128,128, 10, 50,128, 3'd0, "P27_Normal          ");
        apply_test(128,128,128,100,128,128,128,128,128,  5,128,128,128,128,128,128,128,128, 10,100,  1, 3'd2, "P28_Ventricular     ");
        apply_test(128,128,128,100,128,128,128,128,128, 50,128,128,128,128,128,128,128,128, 10,100,  1, 3'd4, "P29_Pacemaker       ");
        apply_test(128,128,128,100,128, 20,128,128,128,128,128,128,128,128,128,128,128,128, 10,100, 10, 3'd2, "P30_Ventricular     ");
        apply_test(128,128,128,100,128,100,128,128,128,128,128,128,128,128,128,128,128,128, 10,100, 10, 3'd0, "P31_Normal          ");

        $display("=========================================");
        $display("TOTAL: %0d PASS, %0d FAIL / 31 tests", pass_count, fail_count);
        if (fail_count == 0) $display("ALL TESTS PASSED");
        $finish;
    end
endmodule
