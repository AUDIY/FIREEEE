/*-----------------------------------------------------------------------------
* fireeee_mult_no_reset.v
*
* Multiplier instance (w/o Reset)
*
* Version: 0.03
* Author : AUDIY
* Date   : 2026/04/13
*
* Port
*   Input
*       CLK_I : Clock
*       CLKS_I: Data & Other Clocks
*       DATA_I: Data from RAM
*       COEF_I: Filter Coefficient from ROM
*
*   Output
*       CLKS_O: Data & Other Clocks
*       MULT_O: Multiplied Data
*
* Parameter
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

module fireeee_mult_no_reset #(
    parameter CLKS_WIDTH     = 2,
    parameter DATA_BIT_WIDTH = 32,
    parameter COEF_BIT_WIDTH = 32,
    parameter IN_REG_EN      = 1'b1,
    parameter OUT_REG_EN     = 1'b1
) (
    input  wire                                                  CLK_I,
    input  wire        [(CLKS_WIDTH                      - 1):0] CLKS_I,
    input  wire signed [(DATA_BIT_WIDTH                  - 1):0] DATA_I,
    input  wire signed [(COEF_BIT_WIDTH                  - 1):0] COEF_I,
    output wire        [(CLKS_WIDTH                      - 1):0] CLKS_O,
    output wire signed [(DATA_BIT_WIDTH + COEF_BIT_WIDTH - 1):0] MULT_O
);

    localparam mult_bit_width = DATA_BIT_WIDTH + COEF_BIT_WIDTH;

    wire        [(CLKS_WIDTH     - 1):0] CLKS_I_wire;
    wire signed [(DATA_BIT_WIDTH - 1):0] DATA_I_wire;
    wire signed [(COEF_BIT_WIDTH - 1):0] COEF_I_wire;

    wire signed [(mult_bit_width - 1):0] MULT_wire;

    wire        [(CLKS_WIDTH     - 1):0] CLKS_O_wire;
    wire signed [(mult_bit_width - 1):0] MULT_O_wire;

    generate
        if (IN_REG_EN == 1'b1) begin: genblk_ireg1
            /* Input Register */
            reg        [(CLKS_WIDTH     - 1):0] CLKS_I_reg = {(CLKS_WIDTH    ){1'b0}};
            reg signed [(DATA_BIT_WIDTH - 1):0] DATA_I_reg = {(DATA_BIT_WIDTH){1'b0}};
            reg signed [(COEF_BIT_WIDTH - 1):0] COEF_I_reg = {(COEF_BIT_WIDTH){1'b0}};

            always @(posedge CLK_I) begin
                CLKS_I_reg <= CLKS_I;
                DATA_I_reg <= DATA_I;
                COEF_I_reg <= COEF_I;
            end

            assign CLKS_I_wire = CLKS_I_reg;
            assign DATA_I_wire = DATA_I_reg;
            assign COEF_I_wire = COEF_I_reg;
        end else begin: genblk_ireg0
            assign CLKS_I_wire = CLKS_I;
            assign DATA_I_wire = DATA_I;
            assign COEF_I_wire = COEF_I;
        end
    endgenerate

    /* Multiply */
    assign MULT_wire = DATA_I_wire * COEF_I_wire;

    generate
        if (OUT_REG_EN == 1'b1) begin: genblk_oreg1
            /* Output Register */
            reg        [(CLKS_WIDTH     - 1):0] CLKS_O_reg = {(CLKS_WIDTH    ){1'b0}};
            reg signed [(mult_bit_width - 1):0] MULT_O_reg = {(mult_bit_width){1'b0}};

            always @(posedge CLK_I) begin
                CLKS_O_reg <= CLKS_I_wire;
                MULT_O_reg <= MULT_wire;
            end

            assign CLKS_O_wire = CLKS_O_reg;
            assign MULT_O_wire = MULT_O_reg;
        end else begin: genblk_oreg0
            assign CLKS_O_wire = CLKS_I_wire;
            assign MULT_O_wire = MULT_wire;
        end
    endgenerate

    assign CLKS_O = CLKS_O_wire;
    assign MULT_O = MULT_O_wire;
    
endmodule

`default_nettype wire
