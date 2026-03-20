/*-----------------------------------------------------------------------------
* fireeee_rom_ctrl_sync_reset.v
*
* Single Port ROM Controller instance (w/ Synchronous Reset)
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/03/19
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

module fireeee_rom_ctrl_sync_reset #(
    parameter ROM_ADDR_WIDTH = 8
) (
    input  wire                          CLK_I          ,
    input  wire                          DCLK_EDGE_DET_I,
    input  wire                          N_RST_I        ,
    output wire [(ROM_ADDR_WIDTH - 1):0] RADDR_O
);

    reg [(ROM_ADDR_WIDTH - 1):0] RADDR_R = {(ROM_ADDR_WIDTH){1'b0}};

    always @(posedge CLK_I) begin
        if (N_RST_I == 1'b0) begin
            RADDR_R <= {(ROM_ADDR_WIDTH){1'b0}};
        end else begin
            if (DCLK_EDGE_DET_I == 1'b1) begin
                RADDR_R <= {(ROM_ADDR_WIDTH){1'b0}};
            end else begin
                RADDR_R <= RADDR_R + 1'b1;
            end
        end
    end

    assign RADDR_O = RADDR_R;

    `ifdef FORMAL
        reg [(ROM_ADDR_WIDTH - 1):0] CLK_COUNT = {(ROM_ADDR_WIDTH){1'b0}};
        reg                          FORMAL_EN = 1'b0;

        always @(posedge CLK_I) begin
            if (N_RST_I == 1'b0) begin
                CLK_COUNT <= {(ROM_ADDR_WIDTH){1'b0}};
                FORMAL_EN <= 1'b0;
            end else begin
                CLK_COUNT <= CLK_COUNT + 1'b1;
                FORMAL_EN <= 1'b1;

                assume (DCLK_EDGE_DET_I == &CLK_COUNT);

                if (FORMAL_EN) begin
                    if ($fell(DCLK_EDGE_DET_I)) begin
                        // (1). When DCLK_EDGE_DET_I falls, the value of RADDR_O must be set to 0.
                        formal_raddr_start: assert (
                            RADDR_O == {(ROM_ADDR_WIDTH){1'b0}}
                        );
                    end else begin
                        // (2). Otherwise, RADDR_O must increment by 1 from its value in the previous cycle.
                        formal_raddr_incr: assert (
                            RADDR_O == $past(RADDR_O, 1) + 1'b1
                        );
                    end
                end
            end
        end
    `endif // FORMAL
    
endmodule

`default_nettype wire
