/*-----------------------------------------------------------------------------
* FIREEEE_ROM_CTRL.v
*
* Single Port ROM Controller for FIREEEE
*
* Version: 0.03
* Author : AUDIY
* Date   : 2026/04/13
*
* Port
*   Input
*       CLK_I         : Clock
*       DCLK_POS_DET_I: Data clock positive edge detection
*       N_RST_I       : Synchronous Reset (Active LOW)
*
*   Output
*       RADDR_O: Read address
*
* Parameter
*       ROM_ADDR_WIDTH: ROM Address Width
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

module FIREEEE_ROM_CTRL #(
    parameter RESET_EN       = 1'b1,
    parameter ASYNC_RESET_EN = 1'b1,
    parameter ROM_ADDR_WIDTH = 8
) (
    input  wire                          CLK_I          ,
    input  wire                          DCLK_EDGE_DET_I,
    input  wire                          N_RST_I        ,
    output wire [(ROM_ADDR_WIDTH - 1):0] RADDR_O
);

    generate
        if (RESET_EN == 1'b0) begin: genblk_romctrl_noreset
            /* w/o Reset */
            fireeee_rom_ctrl_no_reset #(
                .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
            ) u_rom_ctrl_no_reset (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .RADDR_O        (RADDR_O        )
            );
        end else if (ASYNC_RESET_EN == 1'b0) begin: genblk_ramctrl_syncreset
            /* w/ Synchronous Reset */
            fireeee_rom_ctrl_sync_reset #(
                .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
            ) u_rom_ctrl_sync_reset (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .N_RST_I        (N_RST_I        ),
                .RADDR_O        (RADDR_O        )
            );
        end else begin: genblk_ramctrl_asyncreset
            /* w/ Asynchronous Reset */
            fireeee_rom_ctrl_async_reset #(
                .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
            ) u_rom_ctrl_async_reset (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .N_RST_I        (N_RST_I        ),
                .RADDR_O        (RADDR_O        )
            );
        end
    endgenerate
    
endmodule

`default_nettype wire
