\m5_TLV_version 1d: tl-x.org
\m5

   // *******************************************
   // * For ChipCraft Course                    *
   // * Replace this file with your own design. *
   // *******************************************

   use(m5-1.0)
\SV
/*
 * Copyright (c) 2023 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_nishit0072e_decoder (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);
wire reset = ! rst_n;
   

  logic [3:0] bcd;
    logic       l_t;
    logic       bi;
    logic [6:0] seg;

    // 2. Connect module inputs (switches) to the decoder signals
    // BCD input from switches 0-3
    assign bcd = ui_in[3:0];
    // Lamp Test input from switch 4
    assign l_t = ui_in[4];
    // Blanking Input from switch 5
    assign bi  = ui_in[5];

    // The decoder logic implementation
    always_comb begin
        // Lamp Test has the highest priority
        if (!l_t) begin
            seg = 7'b000_0000;
        // Blanking Input is next
        end else if (!bi) begin
            seg = 7'b111_1111;
        // BCD decoding is last
        end else begin
            case (bcd)
                //      gfedcba
                4'h0: seg = 7'b100_0000; // 0
                4'h1: seg = 7'b111_1001; // 1
                4'h2: seg = 7'b010_0100; // 2
                4'h3: seg = 7'b011_0000; // 3
                4'h4: seg = 7'b001_1001; // 4
                4'h5: seg = 7'b001_0010; // 5
                4'h6: seg = 7'b000_0010; // 6
                4'h7: seg = 7'b111_1000; // 7
                4'h8: seg = 7'b000_0000; // 8
                4'h9: seg = 7'b001_1000; // 9 (Corrected)
                default: seg = 7'b111_1111;
            endcase
        end
    end
    
    // 3. Connect the decoder's result 'seg' to the module outputs (LEDs)
    // Result 'seg' drives LEDs 0-6. LED 7 is off.
    assign uo_out = {1'b0, seg};
 
   
   // List all unused inputs to prevent warnings
   wire _unused = &{ena, clk, rst_n, 1'b0};
  // All output pins must be assigned. If not used, assign to 0.
 // assign uo_out  = ui_in;  // Example: ou_out is ui_in
 // assign uio_out = 0;
  //assign uio_oe  = 0;


endmodule
