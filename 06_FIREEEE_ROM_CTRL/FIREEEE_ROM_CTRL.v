/*-----------------------------------------------------------------------------
* FIREEEE_ROM_CTRL.v
*
* Single Port ROM Controller for FIREEEE
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/02/17
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
| the terms of the CERN-OHL-P v2 (https:/cern.ch/cern-ohl).                    |
|                                                                              |
| This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,          |
| INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A         |
| PARTICULAR PURPOSE. Please see the CERN-OHL-P v2 for applicable conditions.  |
--------------------------------------------------------------------------------
*
-----------------------------------------------------------------------------*/
`default_nettype none

module FIREEEE_ROM_CTRL #(
    parameter ROM_ADDR_WIDTH = 8
) (
    input  wire                          CLK_I         ,
    input  wire                          DCLK_POS_DET_I,
    input  wire                          N_RST_I       ,
    output wire [(ROM_ADDR_WIDTH - 1):0] RADDR_O
);

    reg [(ROM_ADDR_WIDTH - 1):0] RADDR_R = {(ROM_ADDR_WIDTH){1'b0}};

    always @(posedge CLK_I) begin
        if (N_RST_I == 1'b0) begin
            RADDR_R <= {(ROM_ADDR_WIDTH){1'b0}};
        end else begin
            if (DCLK_POS_DET_I == 1'b1) begin
                RADDR_R <= {(ROM_ADDR_WIDTH){1'b0}};
            end else begin
                RADDR_R <= RADDR_R + 1'b1;
            end
        end
    end

    assign RADDR_O = RADDR_R;
    
endmodule

`default_nettype wire
