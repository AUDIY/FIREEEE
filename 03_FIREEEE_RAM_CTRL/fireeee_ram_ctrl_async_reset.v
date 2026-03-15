/*-----------------------------------------------------------------------------
* fireeee_ram_ctrl_async_reset.v
*
* RAM Controller Instance (Asyncronous Reset Version)
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/03/13
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

module fireeee_ram_ctrl_async_reset #(
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
    reg [(ADDR_WIDTH - 1):0] WADDR_R   = {(ADDR_WIDTH){1'b0}};
    reg [(ADDR_WIDTH - 1):0] RADDR_R   = {(ADDR_WIDTH){1'b0}};
    reg [(ADDR_WIDTH - 1):0] WADDR_PTR = {(ADDR_WIDTH){1'b0}};

    always @(posedge CLK_I or negedge N_RST_I) begin
        if (N_RST_I == 1'b0) begin
            /* Reset */
            WADDR_PTR <= {(ADDR_WIDTH){1'b0}};
            WADDR_R   <= {(ADDR_WIDTH){1'b0}};
            RADDR_R   <= {(ADDR_WIDTH){1'b0}};
        end else begin
            if (WEN_I == 1'b1) begin
                /* Write State */
                WADDR_PTR <= WADDR_PTR + 1'b1;
                WADDR_R   <= WADDR_PTR;
                RADDR_R   <= WADDR_PTR;
            end else begin
                /* Read State */
                RADDR_R <= RADDR_R + 1'b1;
            end
        end
    end

    /* Output assign */
    assign WADDR_O = WADDR_R;
    assign REN_O   = ~((WEN_I == 1'b1) && (WADDR_R == RADDR_O));
    assign RADDR_O = RADDR_R;

    `ifdef FORMAL
        reg [(ADDR_WIDTH - 1):0] CLK_COUNT = {(ADDR_WIDTH){1'b0}};

        always @(posedge CLK_I) begin
            CLK_COUNT <= CLK_COUNT + 1'b1;

            assume (WEN_I == &CLK_COUNT);

            if (N_RST_I) begin
                // (1). WEN_I must have 1 cycle
                formal_wen_1cycle: assert (!(WEN_I && $past(WEN_I)));

                // (2). If Write Enable and Read Enable is enable, 
                // Write addr and Read addr must not same value.
                if (WEN_I && REN_O) begin
                    formal_addr_neq: assert (
                        (WADDR_O != RADDR_O)
                    );
                end

                // (3). If Write Enable is enabled and Addresses have same value,
                // Read Enable must be disabled.
                if (WEN_I && (WADDR_O == RADDR_O)) begin
                    formal_ren_disable: assert (!REN_O);
                end

                // (4). RADDR_O must have same value as WADDR_O after WEN_I is asseted.
                if ($fell(WEN_I)) begin
                    formal_addr_eq_start: assert (RADDR_O == WADDR_O);
                end
            end
        end
    `endif // FORMAL
    
endmodule

`default_nettype wire
