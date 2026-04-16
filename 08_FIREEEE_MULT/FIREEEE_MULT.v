/*-----------------------------------------------------------------------------
* FIREEEE_MULT.v
*
* Multiplier for FIREEEE
*
* Version: 0.03
* Author : AUDIY
* Date   : 2026/04/13
*
* Port
*   Input
*       CLK_I  : Clock
*       CLKS_I : Data & Other Clocks
*       DATA_I : Data from RAM
*       COEF_I : Filter Coefficient from ROM
*       N_RST_I: Synchronous Reset (Active LOW)
*
*   Output
*       CLKS_O: Data & Other Clocks
*       MULT_O: Multiplied Data
*
* Parameter
*       RESET_EN      : Reset Enable (Default: 1'b1 = Enable)
*       ASYNC_RESET_EN: Asynchronous Reset Enable (Default: 1'b1 = Enable)
*       CLKS_WIDTH    : The number of Clocks (Default: 2)
*       DATA_BIT_WIDTH: Data bit width (Default: 32)
*       COEF_BIT_WIDTH: Filter coefficient bit width (Default: 32)
*       IN_REG_EN     : Input register enable (Default: 1'b1 = Enable)
*       OUT_REG_EN    : Output register enable (Default: 1'b1 = Enable)
*
* License
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

module FIREEEE_MULT #(
    parameter RESET_EN       = 1'b1,
    parameter ASYNC_RESET_EN = 1'b1,
    parameter CLKS_WIDTH     = 2,
    parameter DATA_BIT_WIDTH = 32,
    parameter COEF_BIT_WIDTH = 32,
    parameter IN_REG_EN      = 1'b1,
    parameter OUT_REG_EN     = 1'b1
) (
    input  wire                                 CLK_I,
    input  wire        [(CLKS_WIDTH     - 1):0] CLKS_I,
    input  wire signed [(DATA_BIT_WIDTH - 1):0] DATA_I,
    input  wire signed [(COEF_BIT_WIDTH - 1):0] COEF_I,
    input  wire                                 N_RST_I,
    output wire        [(CLKS_WIDTH     - 1):0] CLKS_O,
    output wire signed [(DATA_BIT_WIDTH + COEF_BIT_WIDTH  - 1):0] MULT_O
);

    generate
        if (RESET_EN== 1'b0) begin: mult_noreset
            /* w/o Reset */
            fireeee_mult_no_reset #(
                .CLKS_WIDTH    (CLKS_WIDTH    ),
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .COEF_BIT_WIDTH(COEF_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) u_mult_no_reset (
                .CLK_I (CLK_I ),
                .CLKS_I(CLKS_I),
                .DATA_I(DATA_I),
                .COEF_I(COEF_I),
                .CLKS_O(CLKS_O),
                .MULT_O(MULT_O)
            );
        end else if (ASYNC_RESET_EN == 1'b0) begin: mult_syncreset
            /* w/ Synchronous Reset */
            fireeee_mult_sync_reset #(
                .CLKS_WIDTH    (CLKS_WIDTH    ),
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .COEF_BIT_WIDTH(COEF_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) u_mult_sync_reset (
                .CLK_I  (CLK_I  ),
                .CLKS_I (CLKS_I ),
                .DATA_I (DATA_I ),
                .COEF_I (COEF_I ),
                .N_RST_I(N_RST_I),
                .CLKS_O (CLKS_O ),
                .MULT_O (MULT_O )
            );
        end else begin: mult_asyncreset
            /* w/ Asynchronous Reset */
            fireeee_mult_async_reset #(
                .CLKS_WIDTH    (CLKS_WIDTH    ),
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .COEF_BIT_WIDTH(COEF_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) u_mult_async_reset (
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
    
endmodule

`default_nettype wire
