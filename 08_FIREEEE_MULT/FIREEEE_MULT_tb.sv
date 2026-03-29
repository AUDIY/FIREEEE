/*----------------------------------------------------------------------------
* FIREEEE_MULT_tb.sv
*
* Testbench for FIREEEE_MULT.v
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/03/29
*
* License under CERN-OHL-P v2
--------------------------------------------------------------------------------
| Copyright AUDIY 2026.                                                        |
|                                                                              |
| This source describes Open Hardware and is licensed under the CERN-OHL-P v2. |
|                                                                              |
| You may redistribute and modify this source and make products using it under |
| the terms of the CERN-OHL-P v2 (https:/cern.ch/cern-ohl).                    |
|                                                                              |
| This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,          |
| INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A         |
| PARTICULAR PURPOSE. Please see the CERN-OHL-P v2 for applicable conditions.  |
--------------------------------------------------------------------------------
*
-----------------------------------------------------------------------------*/
`default_nettype none

module FIREEEE_MULT_tb ();
    
    timeunit 1ns / 1ps;

    localparam RESET_EN       = 1'b1;
    localparam ASYNC_RESET_EN = 1'b1;
    localparam CLKS_WIDTH     = 2;
    localparam DATA_BIT_WIDTH = 4;
    localparam COEF_BIT_WIDTH = 4;
    localparam IN_REG_EN      = 1'b1;
    localparam OUT_REG_EN     = 1'b1;

    localparam CLK_COUNT_WIDTH = 7;
    localparam OUT_BIT_WIDTH   = DATA_BIT_WIDTH + COEF_BIT_WIDTH;

    reg                                    CLK_I   = 1'b0;
    reg  unsigned [(CLKS_WIDTH     - 1):0] CLKS_I  = '0;
    reg  signed   [(DATA_BIT_WIDTH - 1):0] DATA_I  = '0;
    reg  signed   [(COEF_BIT_WIDTH - 1):0] COEF_I  = '0;
    reg                                    RST     = 1'b0;
    wire                                   N_RST_I;

    wire unsigned [(CLKS_WIDTH    - 1):0] CLKS_O;
    wire signed   [(OUT_BIT_WIDTH - 1):0] MULT_O;

    reg [(CLK_COUNT_WIDTH - 1):0] CLK_COUNT = '0;

    reg signed [31:0] data_rand = '0;
    reg signed [31:0] coef_rand = '0;

    integer unsigned urand_rst = '0;

    generate
        if (RESET_EN == 1'b0) begin: dut_noreset
            assign N_RST_I = RST;

            FIREEEE_MULT #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .CLKS_WIDTH    (CLKS_WIDTH    ),
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .COEF_BIT_WIDTH(COEF_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) dut (
                .CLK_I  (CLK_I  ),
                .CLKS_I (CLKS_I ),
                .DATA_I (DATA_I ),
                .COEF_I (COEF_I ),
                .N_RST_I(N_RST_I),
                .CLKS_O (CLKS_O ),
                .MULT_O (MULT_O )
            );
        end else if (ASYNC_RESET_EN == 1'b0) begin: dut_syncreset
             /* w/ Synchronous Reset */
            reg unsigned [1:0] N_RST_SYNC_I = '0;

            always @(posedge CLK_I) begin
                N_RST_SYNC_I <= {N_RST_SYNC_I[0], RST};
            end

            assign N_RST_I = N_RST_SYNC_I[1];

            FIREEEE_MULT #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .CLKS_WIDTH    (CLKS_WIDTH    ),
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .COEF_BIT_WIDTH(COEF_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) dut (
                .CLK_I  (CLK_I  ),
                .CLKS_I (CLKS_I ),
                .DATA_I (DATA_I ),
                .COEF_I (COEF_I ),
                .N_RST_I(N_RST_I),
                .CLKS_O (CLKS_O ),
                .MULT_O (MULT_O )
            );
        end else begin: dut_asyncreset
            /* w/ Asynchronous Reset */

            // Asynchronous Reset Synchronizer.
            // Please Refer https://github.com/AUDIY/AUDIY_Verilog_IP/tree/main/ARESETN_SYNC
            ARESETN_SYNC #(
                .STAGES(2)
            ) rst_sync (
                .CLK_I    (CLK_I  ),
                .ARESETN_I(RST    ),
                .RESETN_O (N_RST_I)
            );

            FIREEEE_MULT #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .CLKS_WIDTH    (CLKS_WIDTH    ),
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .COEF_BIT_WIDTH(COEF_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) dut (
                .CLK_I  (CLK_I  ),
                .CLKS_I (CLKS_I ),
                .DATA_I (DATA_I ),
                .COEF_I (COEF_I ),
                .N_RST_I(N_RST_I),
                .CLKS_O (CLKS_O ),
                .MULT_O (MULT_O )
            );
        end
    endgenerate

    initial begin
        $dumpfile("FIREEEE_MULT.vcd");
        $dumpvars(0, FIREEEE_MULT_tb);

        #5000 $finish();
    end

    initial begin
        forever begin
            #3 CLK_I = ~CLK_I;
        end
    end

     /* Reset Generation */
    initial begin
        #1 RST = 1'b1;

        forever begin
            urand_rst = $urandom_range(2500, 3000);
            #(urand_rst) RST = 1'b0;

            urand_rst = $urandom_range(3, 10);
            #(urand_rst) RST = 1'b1;
        end
    end

    always @(posedge CLK_I) begin
        CLK_COUNT <= CLK_COUNT + 1'b1;
        CLKS_I <= {CLK_COUNT[6], CLK_COUNT[0]};
    end

    always @(posedge CLK_I) begin
        data_rand <= $random();
        coef_rand <= $random();
    end

    always @(posedge CLK_I) begin
        DATA_I <= data_rand[31 -: DATA_BIT_WIDTH];
        COEF_I <= coef_rand[31 -: COEF_BIT_WIDTH];
    end

endmodule

`default_nettype wire
