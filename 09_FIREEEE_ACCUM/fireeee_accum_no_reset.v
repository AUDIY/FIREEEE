/*-----------------------------------------------------------------------------
* fireeee_accum_no_reset.v
*
* Accumulator instance (w/o Reset)
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
*
*   Output
*       CLKS_O : Data & Other Clocks
*       ACCUM_O: Accumulated Data
*
* Parameter
*       CLKS_WIDTH  : The number of Clocks (Default: 2)
*       MULT_WIDTH  : Multiplied data bit width (Default: 32)
*       MARGIN_WIDTH: Margin bit width for accumulation (Default: 8)
*       IN_REG_EN   : Input register enable (Default: 1'b1 = Enable)
*       OUT_REG_EN  : Output register enable (Default: 1'b1 = Enable)
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

module fireeee_accum_no_reset #(
    parameter CLKS_WIDTH   = 2 ,
    parameter MULT_WIDTH   = 32,
    parameter MARGIN_WIDTH = 8,
    parameter IN_REG_EN    = 1'b1,
    parameter OUT_REG_EN   = 1'b1
) (
    input  wire                             CLK_I,
    input  wire                             DCLK_EDGE_DET_I,
    input  wire        [(CLKS_WIDTH - 1):0] CLKS_I,
    input  wire signed [(MULT_WIDTH - 1):0] MULT_I,
    output wire        [(CLKS_WIDTH - 1):0] CLKS_O,
    output wire signed [(MULT_WIDTH - 1):0] ACCUM_O
);

    localparam add_width = MULT_WIDTH + MARGIN_WIDTH;

    wire signed [(MULT_WIDTH - 1):0] mult_iwire;
    wire        [(CLKS_WIDTH - 1):0] clks_iwire;
    wire                             edge_iwire;

    reg signed [(add_width  - 1):0] add_reg   = {(add_width){1'b0}};
    reg signed [(MULT_WIDTH - 1):0] accum_reg = {(MULT_WIDTH){1'b0}};
    reg signed [(CLKS_WIDTH - 1):0] clks_reg1 = {(CLKS_WIDTH){1'b0}};
    reg signed [(CLKS_WIDTH - 1):0] clks_reg2 = {(CLKS_WIDTH){1'b0}};

    wire signed [(MULT_WIDTH - 1):0] accum_owire;
    wire        [(CLKS_WIDTH - 1):0] clks_owire;

    generate
        if (IN_REG_EN == 1'b1) begin: genblk_ireg1
            /* Input register */
            reg signed [(MULT_WIDTH - 1):0] mult_ireg = {(MULT_WIDTH){1'b0}};
            reg        [(CLKS_WIDTH - 1):0] clks_ireg = {(CLKS_WIDTH){1'b0}};
            reg                             edge_ireg = 1'b0;
            
            always @(posedge CLK_I) begin
                mult_ireg <= MULT_I;
                clks_ireg <= CLKS_I;
                edge_ireg <= DCLK_EDGE_DET_I;
            end

            assign mult_iwire = mult_ireg;
            assign clks_iwire = clks_ireg;
            assign edge_iwire = edge_ireg;
        end else begin: genblk_ireg0
            /* Through */
            assign mult_iwire = MULT_I;
            assign clks_iwire = CLKS_I;
            assign edge_iwire = DCLK_EDGE_DET_I;
        end
    endgenerate

    always @(posedge CLK_I) begin
        clks_reg1 <= clks_iwire;
        clks_reg2 <= clks_reg1;
    end

    always @(posedge CLK_I) begin
        if (edge_iwire == 1'b1) begin
            add_reg <= {{(MARGIN_WIDTH){mult_iwire[(MULT_WIDTH - 1)]}}, mult_iwire};
        end else begin
            add_reg <= add_reg + {{(MARGIN_WIDTH){mult_iwire[(MULT_WIDTH - 1)]}}, mult_iwire};
        end
    end

    always @(posedge CLK_I) begin
        if (edge_iwire == 1'b1) begin
            case (add_reg[(MULT_WIDTH - 1):(MULT_WIDTH - 2)])
                2'b00  : accum_reg <= add_reg[(MULT_WIDTH - 1):0];
                2'b01  : accum_reg <= {2'b00, {(MULT_WIDTH - 2){1'b1}}}; // Saturate to max value
                2'b10  : accum_reg <= {2'b11, {(MULT_WIDTH - 2){1'b0}}}; // Saturate to min value
                2'b11  : accum_reg <= add_reg[(MULT_WIDTH - 1):0];
                default: accum_reg <= add_reg[(MULT_WIDTH - 1):0];
            endcase
        end else begin
            accum_reg <= accum_reg;
        end
    end
    
    generate
        if (OUT_REG_EN == 1'b1) begin: genblk_oreg1
            /* Output register */
            reg signed [(MULT_WIDTH - 1):0] accum_oreg = {(MULT_WIDTH){1'b0}};
            reg        [(CLKS_WIDTH - 1):0] clks_oreg  = {(CLKS_WIDTH){1'b0}};
            
            always @(posedge CLK_I) begin
                accum_oreg <= accum_reg;
                clks_oreg  <= clks_reg2;
            end

            assign accum_owire = accum_oreg;
            assign clks_owire  = clks_oreg;
        end else begin: genblk_oreg0
            /* Through */
            assign accum_owire = accum_reg;
            assign clks_owire  = clks_reg2;
        end
    endgenerate

    assign CLKS_O  = clks_owire;
    assign ACCUM_O = accum_owire;

endmodule

`default_nettype wire
