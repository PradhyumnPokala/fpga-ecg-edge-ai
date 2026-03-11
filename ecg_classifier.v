// =============================================================
// ECG Anomaly Detection - Decision Tree Inference Engine
// FPGA Hackathon 2026 | AMD/Xilinx | BITS Pilani
// Author: Pradhyumn Pokala
// Dataset: MIT-BIH Arrhythmia (Kaggle, 188 features, 5 classes)
// Model: DecisionTreeClassifier (max_depth=5), sklearn
// Accuracy: 79.78% (software), 98.90% match after quantization
//
// Classes:
//   0 = Normal Beat (N)
//   1 = Supraventricular Ectopic Beat (S)
//   2 = Ventricular Ectopic Beat (V)
//   3 = Fusion Beat (F)
//   4 = Unknown / Pacemaker Beat (Q)
//
// Design: Combinational inference engine (zero-latency)
// Quantization: Float thresholds scaled to 8-bit (floor * 256)
// Only 21 of 188 features are used by the decision tree
// =============================================================

module ecg_classifier (
    input wire [7:0] feature_0,
    input wire [7:0] feature_1,
    input wire [7:0] feature_2,
    input wire [7:0] feature_3,
    input wire [7:0] feature_4,
    input wire [7:0] feature_9,
    input wire [7:0] feature_12,
    input wire [7:0] feature_18,
    input wire [7:0] feature_22,
    input wire [7:0] feature_26,
    input wire [7:0] feature_27,
    input wire [7:0] feature_35,
    input wire [7:0] feature_36,
    input wire [7:0] feature_43,
    input wire [7:0] feature_56,
    input wire [7:0] feature_64,
    input wire [7:0] feature_68,
    input wire [7:0] feature_77,
    input wire [7:0] feature_87,
    input wire [7:0] feature_101,
    input wire [7:0] feature_134,
    output reg [2:0] class_out
);

    // Threshold constants (floor(float_threshold * 256))
    localparam T_F87_0   = 8'd0;
    localparam T_F9_46   = 8'd46;
    localparam T_F9_179  = 8'd179;
    localparam T_F9_43   = 8'd43;
    localparam T_F56_33  = 8'd33;
    localparam T_F1_215  = 8'd215;
    localparam T_F1_79   = 8'd79;
    localparam T_F1_186  = 8'd186;
    localparam T_F77_7   = 8'd7;
    localparam T_F18_10  = 8'd10;
    localparam T_F3_38   = 8'd38;
    localparam T_F3_25   = 8'd25;
    localparam T_F3_74   = 8'd74;
    localparam T_F12_17  = 8'd17;
    localparam T_F43_71  = 8'd71;
    localparam T_F22_120 = 8'd120;
    localparam T_F68_23  = 8'd23;
    localparam T_F0_250  = 8'd250;
    localparam T_F0_197  = 8'd197;
    localparam T_F4_161  = 8'd161;
    localparam T_F35_87  = 8'd87;
    localparam T_F2_153  = 8'd153;
    localparam T_F2_110  = 8'd110;
    localparam T_F2_184  = 8'd184;
    localparam T_F36_128 = 8'd128;
    localparam T_F27_10  = 8'd10;
    localparam T_F27_43  = 8'd43;
    localparam T_F101_87 = 8'd87;
    localparam T_F134_2  = 8'd2;
    localparam T_F26_12  = 8'd12;

    always @(*) begin
        if (feature_87 <= T_F87_0) begin
            if (feature_9 <= T_F9_46) begin
                if (feature_56 <= T_F56_33) begin
                    if (feature_1 <= T_F1_215) begin
                        if (feature_77 <= T_F77_7)
                            class_out = 3'd1;
                        else
                            class_out = 3'd0;
                    end else begin
                        if (feature_18 <= T_F18_10)
                            class_out = 3'd3;
                        else
                            class_out = 3'd0;
                    end
                end else begin
                    if (feature_3 <= T_F3_38) begin
                        if (feature_12 <= T_F12_17)
                            class_out = 3'd3;
                        else
                            class_out = 3'd0;
                    end else begin
                        if (feature_43 <= T_F43_71)
                            class_out = 3'd3;
                        else
                            class_out = 3'd2;
                    end
                end
            end else begin
                if (feature_3 <= T_F3_25) begin
                    if (feature_22 <= T_F22_120) begin
                        if (feature_68 <= T_F68_23)
                            class_out = 3'd1;
                        else
                            class_out = 3'd0;
                    end else begin
                        if (feature_1 <= T_F1_79)
                            class_out = 3'd2;
                        else
                            class_out = 3'd0;
                    end
                end else begin
                    if (feature_9 <= T_F9_179) begin
                        if (feature_0 <= T_F0_250)
                            class_out = 3'd2;
                        else
                            class_out = 3'd0;
                    end else begin
                        if (feature_4 <= T_F4_161)
                            class_out = 3'd1;
                        else
                            class_out = 3'd3;
                    end
                end
            end
        end else begin
            if (feature_3 <= T_F3_74) begin
                if (feature_0 <= T_F0_197) begin
                    if (feature_35 <= T_F35_87) begin
                        class_out = 3'd1; // Both sub-branches predict class 1
                    end else begin
                        if (feature_2 <= T_F2_153)
                            class_out = 3'd2;
                        else
                            class_out = 3'd0;
                    end
                end else begin
                    if (feature_36 <= T_F36_128) begin
                        if (feature_27 <= T_F27_10)
                            class_out = 3'd1;
                        else
                            class_out = 3'd0;
                    end else begin
                        if (feature_2 <= T_F2_110)
                            class_out = 3'd1;
                        else
                            class_out = 3'd2;
                    end
                end
            end else begin
                if (feature_101 <= T_F101_87) begin
                    if (feature_2 <= T_F2_184) begin
                        if (feature_1 <= T_F1_186)
                            class_out = 3'd4;
                        else
                            class_out = 3'd0;
                    end else begin
                        if (feature_27 <= T_F27_43)
                            class_out = 3'd2;
                        else
                            class_out = 3'd0;
                    end
                end else begin
                    if (feature_134 <= T_F134_2) begin
                        if (feature_26 <= T_F26_12)
                            class_out = 3'd2;
                        else
                            class_out = 3'd4;
                    end else begin
                        if (feature_9 <= T_F9_43)
                            class_out = 3'd2;
                        else
                            class_out = 3'd0;
                    end
                end
            end
        end
    end

endmodule
