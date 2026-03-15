/*-----------------------------------------------------------------------------
* FIREEEE_RAM_CTRL.v
*
* RAM Controller for FIREEEE
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/03/14
*
* Port
*   Input
*       CLK_I  : Clock
*       WEN_I  : Write Enable
*       N_RST_I: Synchronous/Asynchronous Reset (Active LOW)
*
*   Output
*       WADDR_O: Write Address
*       REN_O  : Read Enable
*       RADDR_O: Read Address
*
* Parameter
*   RESET_EN       : Reset Enable (Default: 1'b1 = Enable)
*   ASYNC_RESET_EN : Asynchronous Reset Enable (Default: 1'b1 = Asynchronous Reset)
*   ADDR_WIDTH     : Input/Output Address width (Default: 8)
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

module FIREEEE_RAM_CTRL #(
    parameter RESET_EN       = 1'b1,
    parameter ASYNC_RESET_EN = 1'b1,
    parameter ADDR_WIDTH     = 8
) (
    input  wire                      CLK_I  ,
    input  wire                      WEN_I  ,
    input  wire                      N_RST_I,
    output wire [(ADDR_WIDTH - 1):0] WADDR_O,
    output wire                      REN_O  ,
    output wire [(ADDR_WIDTH - 1):0] RADDR_O
);

    generate
        if (RESET_EN == 1'b0) begin: genblk_ramctrl_noreset
            /* w/o Reset */
            fireeee_ram_ctrl_no_reset #(
                .ADDR_WIDTH(ADDR_WIDTH)
            ) u_ram_ctrl_no_reset (
                .CLK_I  (CLK_I  ),
                .WEN_I  (WEN_I  ),
                .WADDR_O(WADDR_O),
                .REN_O  (REN_O  ),
                .RADDR_O(RADDR_O)
            );
        end else if (ASYNC_RESET_EN == 1'b0) begin: genblk_ramctrl_syncreset
            /* w/ Synchronous Reset */
            fireeee_ram_ctrl_sync_reset #(
                .ADDR_WIDTH(ADDR_WIDTH)
            ) u_ram_ctrl_sync_reset (
                .CLK_I  (CLK_I  ),
                .WEN_I  (WEN_I  ),
                .N_RST_I(N_RST_I),
                .WADDR_O(WADDR_O),
                .REN_O  (REN_O  ),
                .RADDR_O(RADDR_O)
            );
        end else begin: genblk_ramctrl_asyncreset
            /* w/ Asynchronous Reset */
            fireeee_ram_ctrl_async_reset #(
                .ADDR_WIDTH(ADDR_WIDTH)
            ) u_ram_ctrl_async_reset (
                .CLK_I  (CLK_I  ),
                .WEN_I  (WEN_I  ),
                .N_RST_I(N_RST_I),
                .WADDR_O(WADDR_O),
                .REN_O  (REN_O  ),
                .RADDR_O(RADDR_O)
            );
        end
    endgenerate
    
endmodule

`default_nettype wire
