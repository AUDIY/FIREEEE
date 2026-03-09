/*-----------------------------------------------------------------------------
* FIREEEE_DCLK_EDGE_DET.v
*
* Data Clock Edge Detector for FIREEEE
*
* Version: 0.02
* Author : AUDIY
* Date   : 2026/03/10
*
* Port
*   Input
*       CLK_I  : Clock
*       DCLK_I : Data Clock
*       DATA_I : Data
*       N_RST_I: Synchronous/Asynchronous Reset (Active LOW)
*
*   Output
*       DCLK_O   : Data Clock
*       DATA_O   : Data
*       POS_DET_O: Positive Edge Flag
*       NEG_DET_O: Negative Edge Flag
*
* Parameters
*   DATA_BIT_WIDTH : Data bit width (Default: 32)
*   RESET_EN       : Reset Enable (Default: 1'b1 = Enable)
*   ASYNC_RESET_EN : Asynchronous Reset Enable (Default: 1'b1 = Asynchronous Reset)
*   IN_REG_EN      : Input register enable (Default: 1'b1 = Enable)
*   OUT_REG_EN     : Output register enable (Default: 1'b1 = Enable)
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

module FIREEEE_DCLK_EDGE_DET #(
    parameter RESET_EN       = 1'b1,
    parameter ASYNC_RESET_EN = 1'b1,
    parameter DATA_BIT_WIDTH = 32  ,
    parameter IN_REG_EN      = 1'b1,
    parameter OUT_REG_EN     = 1'b1
) (
    input  wire                          CLK_I    ,
    input  wire                          DCLK_I   ,
    input  wire [(DATA_BIT_WIDTH - 1):0] DATA_I   ,
    input  wire                          N_RST_I  ,
    output wire                          DCLK_O   ,
    output wire [(DATA_BIT_WIDTH - 1):0] DATA_O   ,
    output wire                          POS_DET_O,
    output wire                          NEG_DET_O
);

    generate
        if (RESET_EN == 1'b0) begin: genblk_edgedet_noreset
            /* w/o Reset */
            fireeee_dclk_edge_det_no_reset #(
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) u_dclk_edge_det_no_reset (
                .CLK_I    (CLK_I    ),
                .DCLK_I   (DCLK_I   ),
                .DATA_I   (DATA_I   ),
                .DCLK_O   (DCLK_O   ),
                .DATA_O   (DATA_O   ),
                .POS_DET_O(POS_DET_O),
                .NEG_DET_O(NEG_DET_O)
            );
        end else if (ASYNC_RESET_EN == 1'b0) begin: genblk_edgedet_syncreset
            /* w/ Synchronous Reset */
            fireeee_dclk_edge_det_sync_reset #(
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) u_dclk_edge_det_no_reset (
                .CLK_I    (CLK_I    ),
                .DCLK_I   (DCLK_I   ),
                .DATA_I   (DATA_I   ),
                .N_RST_I  (N_RST_I  ),
                .DCLK_O   (DCLK_O   ),
                .DATA_O   (DATA_O   ),
                .POS_DET_O(POS_DET_O),
                .NEG_DET_O(NEG_DET_O)
            );
        end else begin: genblk_edgedet_asyncreset
            /* w/ Asynchronous Reset */
            fireeee_dclk_edge_det_async_reset #(
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) u_dclk_edge_det_no_reset (
                .CLK_I    (CLK_I    ),
                .DCLK_I   (DCLK_I   ),
                .DATA_I   (DATA_I   ),
                .N_RST_I  (N_RST_I  ),
                .DCLK_O   (DCLK_O   ),
                .DATA_O   (DATA_O   ),
                .POS_DET_O(POS_DET_O),
                .NEG_DET_O(NEG_DET_O)
            );
        end
    endgenerate
    
endmodule

`default_nettype wire
