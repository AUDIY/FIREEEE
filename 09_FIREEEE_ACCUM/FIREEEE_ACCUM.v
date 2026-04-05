/*-----------------------------------------------------------------------------
* FIREEEE_ACCUM.v
*
* Adder & Accumulator for FIREEEE
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/04/05
*
* Port
*   Input
*       CLK_I          : Clock
*       DCLK_EDGE_DET_I: Data Clock Edge Detection Signal
*       CLKS_I         : Data & Other Clocks
*       MULT_I         : Multiplied Data from Multiplier
*       N_RST_I        : Active Low Asynchronous Reset
*
*   Output
*       CLKS_O : Data & Other Clocks
*       ACCUM_O: Accumulated Data
*
* Parameter
*       RESET_EN      : Reset Enable (Default: 1'b1 = Enable)
*       ASYNC_RESET_EN: Asynchronous Reset Enable (Default: 1'b1 = Enable)
*       CLKS_WIDTH    : The number of Clocks (Default: 2)
*       MULT_WIDTH    : Multiplied data bit width (Default: 32)
*       MARGIN_WIDTH  : Margin bit width for accumulation (Default: 8)
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
| the terms of the CERN-OHL-P v2 (https:/cern.ch/cern-ohl).                    |
|                                                                              |
| This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,          |
| INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A         |
| PARTICULAR PURPOSE. Please see the CERN-OHL-P v2 for applicable conditions.  |
--------------------------------------------------------------------------------
*
-----------------------------------------------------------------------------*/
`default_nettype none

module FIREEEE_ACCUM #(
    parameter RESET_EN       = 1'b1,
    parameter ASYNC_RESET_EN = 1'b1,
    parameter CLKS_WIDTH     = 2,
    parameter MULT_WIDTH     = 32,
    parameter MARGIN_WIDTH   = 8,
    parameter IN_REG_EN      = 1'b1,
    parameter OUT_REG_EN     = 1'b1
) (
    input  wire                             CLK_I,
    input  wire                             DCLK_EDGE_DET_I,
    input  wire        [(CLKS_WIDTH - 1):0] CLKS_I,
    input  wire signed [(MULT_WIDTH - 1):0] MULT_I,
    input  wire                             N_RST_I,
    output wire        [(CLKS_WIDTH - 1):0] CLKS_O,
    output wire signed [(MULT_WIDTH - 1):0] ACCUM_O
);

    generate
        if (RESET_EN == 1'b0) begin: genblk_noreset
            /* w/o Reset */
            fireeee_accum_no_reset #(
                .CLKS_WIDTH  (CLKS_WIDTH  ),
                .MULT_WIDTH  (MULT_WIDTH  ),
                .MARGIN_WIDTH(MARGIN_WIDTH),
                .IN_REG_EN   (IN_REG_EN   ),
                .OUT_REG_EN  (OUT_REG_EN  )
            ) u_accum_no_reset (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .CLKS_I         (CLKS_I         ),
                .MULT_I         (MULT_I         ),
                .CLKS_O         (CLKS_O         ),
                .ACCUM_O        (ACCUM_O        )
            );
        end else if (ASYNC_RESET_EN == 1'b0) begin: genblk_syncreset
            /* w/ Synchronous Reset */
            fireeee_accum_sync_reset #(
                .CLKS_WIDTH  (CLKS_WIDTH  ),
                .MULT_WIDTH  (MULT_WIDTH  ),
                .MARGIN_WIDTH(MARGIN_WIDTH),
                .IN_REG_EN   (IN_REG_EN   ),
                .OUT_REG_EN  (OUT_REG_EN  )
            ) u_accum_sync_reset (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .CLKS_I         (CLKS_I         ),
                .MULT_I         (MULT_I         ),
                .N_RST_I        (N_RST_I        ),
                .CLKS_O         (CLKS_O         ),
                .ACCUM_O        (ACCUM_O        )
            );
        end else begin: genblk_asyncreset
            /* w/ Asynchronous Reset */
            fireeee_accum_async_reset #(
                .CLKS_WIDTH  (CLKS_WIDTH  ),
                .MULT_WIDTH  (MULT_WIDTH  ),
                .MARGIN_WIDTH(MARGIN_WIDTH),
                .IN_REG_EN   (IN_REG_EN   ),
                .OUT_REG_EN  (OUT_REG_EN  )
            ) u_accum_async_reset (
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
    
endmodule

`default_nettype wire
