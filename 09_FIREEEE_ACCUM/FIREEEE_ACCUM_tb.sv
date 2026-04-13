/*----------------------------------------------------------------------------
* FIREEEE_ACCUM_tb.sv
*
* Testbench for FIREEEE_ACCUM.v
*
* Version: 0.03
* Author : AUDIY
* Date   : 2026/04/13
*
* License under CERN-OHL-P v2
--------------------------------------------------------------------------------
| Copyright AUDIY 2026.                                                        |
|                                                                              |
| This source describes Open Hardware and is licensed under the CERN-OHL-P v2. |
|                                                                              |
| You may redistribute and modify this source and make products using it under |
| the terms of the CERN-OHL-P v2 (https://cern.ch/cern-ohl).                   |
|                                                                              |
| This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,          |
| INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A         |
| PARTICULAR PURPOSE. Please see the CERN-OHL-P v2 for applicable conditions.  |
--------------------------------------------------------------------------------
*
-----------------------------------------------------------------------------*/
`default_nettype none

module FIREEEE_ACCUM_tb ();

    timeunit 1ns / 1ps;

    localparam RESET_EN       = 1'b1;
    localparam ASYNC_RESET_EN = 1'b1;
    localparam CLKS_WIDTH     = 2;
    localparam MULT_WIDTH     = 8;
    localparam MARGIN_WIDTH   = 2;
    localparam IN_REG_EN      = 1'b1;
    localparam OUT_REG_EN     = 1'b1;

    reg                                CLK_I           = 1'b0;
    reg                                DCLK_EDGE_DET_I = 1'b0;
    reg  unsigned [(CLKS_WIDTH - 1):0] CLKS_I          = {(CLKS_WIDTH){1'b0}};
    reg  signed   [(MULT_WIDTH - 1):0] MULT_I          = {(MULT_WIDTH){1'b0}};
    wire                               N_RST_I;
    wire unsigned [(CLKS_WIDTH - 1):0] CLKS_O;
    wire signed   [(MULT_WIDTH - 1):0] ACCUM_O;

    reg RST = 1'b0;

    integer unsigned urand_rst = '0;
    integer signed rand_mult = '0;
    reg unsigned [(CLKS_WIDTH - 1):0] CLK_COUNT = '0;

    generate
        if (RESET_EN == 1'b0) begin: dut_noreset
            assign N_RST_I = RST;

            FIREEEE_ACCUM #(
                .RESET_EN        (RESET_EN        ),
                .ASYNC_RESET_EN  (ASYNC_RESET_EN  ),
                .CLKS_WIDTH      (CLKS_WIDTH      ),
                .MULT_WIDTH      (MULT_WIDTH      ),
                .MARGIN_WIDTH    (MARGIN_WIDTH    ),
                .IN_REG_EN       (IN_REG_EN       ),
                .OUT_REG_EN      (OUT_REG_EN      )
            ) dut (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .CLKS_I         (CLKS_I         ),
                .MULT_I         (MULT_I         ),
                .N_RST_I        (N_RST_I        ),
                .CLKS_O         (CLKS_O         ),
                .ACCUM_O        (ACCUM_O        )
            ); 
        end else if (ASYNC_RESET_EN == 1'b0) begin: dut_syncreset
            /* w/ Synchronous Reset */
            reg unsigned [1:0] N_RST_SYNC_I = '0;

            always @(posedge CLK_I) begin
                N_RST_SYNC_I <= {N_RST_SYNC_I[0], RST};
            end

            assign N_RST_I = N_RST_SYNC_I[1];

            FIREEEE_ACCUM #(
                .RESET_EN        (RESET_EN        ),
                .ASYNC_RESET_EN  (ASYNC_RESET_EN  ),
                .CLKS_WIDTH      (CLKS_WIDTH      ),
                .MULT_WIDTH      (MULT_WIDTH      ),
                .MARGIN_WIDTH    (MARGIN_WIDTH    ),
                .IN_REG_EN       (IN_REG_EN       ),
                .OUT_REG_EN      (OUT_REG_EN      )
            ) dut (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .CLKS_I         (CLKS_I         ),
                .MULT_I         (MULT_I         ),
                .N_RST_I        (N_RST_I        ),
                .CLKS_O         (CLKS_O         ),
                .ACCUM_O        (ACCUM_O        )
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

            FIREEEE_ACCUM #(
                .RESET_EN        (RESET_EN        ),
                .ASYNC_RESET_EN  (ASYNC_RESET_EN  ),
                .CLKS_WIDTH      (CLKS_WIDTH      ),
                .MULT_WIDTH      (MULT_WIDTH      ),
                .MARGIN_WIDTH    (MARGIN_WIDTH    ),
                .IN_REG_EN       (IN_REG_EN       ),
                .OUT_REG_EN      (OUT_REG_EN      )
            ) dut (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .CLKS_I         (CLKS_I         ),
                .MULT_I         (MULT_I         ),
                .N_RST_I        (N_RST_I        ),
                .CLKS_O         (CLKS_O         ),
                .ACCUM_O        (ACCUM_O        )
            );
        end
    endgenerate

    initial begin
        $dumpfile("FIREEEE_ACCUM.vcd");
        $dumpvars(0, FIREEEE_ACCUM_tb);

        #10000 $finish;
    end

    initial begin
        #1 RST = 1'b1;

        urand_rst = $urandom_range(5000, 5500);
        #(urand_rst) RST = 1'b0;

        urand_rst = $urandom_range(6, 11);
        #(urand_rst) RST = 1'b1;
    end

    initial begin
        forever begin
            #3 CLK_I = ~CLK_I;
        end
    end

    always @(posedge CLK_I) begin
        CLK_COUNT <= CLK_COUNT + 1'b1;
    end

    always @(posedge CLK_I) begin
        DCLK_EDGE_DET_I <= &CLK_COUNT;
    end

    always @(posedge CLK_I) begin
        CLKS_I <= CLK_COUNT;

        rand_mult <= $random();
        MULT_I <= rand_mult[31:(32 - MULT_WIDTH)];
    end
    
endmodule

`default_nettype wire
