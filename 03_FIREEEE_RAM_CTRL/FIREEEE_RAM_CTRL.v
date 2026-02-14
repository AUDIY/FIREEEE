/*-----------------------------------------------------------------------------
* FIREEEE_RAM_CTRL.v
*
* RAM Controller for FIREEEE
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/02/14
*
* Port
*   Input
*       CLK_I  : Clock
*       WEN_I  : Write Enable
*       N_RST_I: Synchronous Reset (Active LOW)
*
*   Output
*       WADDR_O: Write Address
*       REN_O  : Read Enable
*       RADDR_O: Read Address
*
* Parameter
*       ADDR_WIDTH: Input/Output Address width
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
    parameter ADDR_WIDTH = 8
) (
    input  wire                      CLK_I  ,
    input  wire                      WEN_I  ,
    input  wire                      N_RST_I,
    output wire [(ADDR_WIDTH - 1):0] WADDR_O,
    output wire                      REN_O  ,
    output wire [(ADDR_WIDTH - 1):0] RADDR_O
);

    /* Internal wire/reg */
    reg                      REN_R     = 1'b0;
    reg [(ADDR_WIDTH - 1):0] WADDR_R   = {(ADDR_WIDTH){1'b0}};
    reg [(ADDR_WIDTH - 1):0] RADDR_R   = {(ADDR_WIDTH){1'b0}};
    reg [(ADDR_WIDTH - 1):0] WADDR_PTR = {(ADDR_WIDTH){1'b0}};

    always @(posedge CLK_I) begin
        if (N_RST_I == 1'b0) begin
            /* Reset */
            WADDR_PTR <= {(ADDR_WIDTH){1'b0}};
            WADDR_R   <= {(ADDR_WIDTH){1'b0}};
            REN_R     <=               1'b0;
            RADDR_R   <= {(ADDR_WIDTH){1'b0}};
        end else begin
            if (WEN_I == 1'b1) begin
                /* Write State */
                WADDR_PTR <= WADDR_PTR + 1'b1;
                WADDR_R   <= WADDR_PTR;
                RADDR_R   <= WADDR_PTR + 1'b1;
                REN_R     <= 1'b1;
            end else begin
                /* Read State */
                RADDR_R <=  RADDR_R + 1'b1;
                REN_R   <= 1'b1;
            end
        end
    end

    /* Output assign */
    assign WADDR_O = WADDR_R;
    assign REN_O   = REN_R  ;
    assign RADDR_O = RADDR_R;
    
endmodule

`default_nettype wire
