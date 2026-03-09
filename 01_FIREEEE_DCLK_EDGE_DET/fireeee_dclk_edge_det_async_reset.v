/*-----------------------------------------------------------------------------
* fireeee_dclk_edge_det_async_reset.v
*
* Data Clock Edge Detector Instance (Asynchronous Reset Version.)
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
*       N_RST_I: Asynchronous Reset (Active LOW)
*
*   Output
*       DCLK_O   : Data Clock
*       DATA_O   : Data
*       POS_DET_O: Positive Edge Flag
*       NEG_DET_O: Negative Edge Flag
*
* Parameters
*   DATA_BIT_WIDTH : Data bit width (Default: 32)
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

module fireeee_dclk_edge_det_async_reset #(
    parameter DATA_BIT_WIDTH = 32,
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

    /* Internal wire/reg */
    wire                          DCLKI_W;
    wire [(DATA_BIT_WIDTH - 1):0] DATAI_W;

    reg                          DCLK_R = 1'b0;
    reg [(DATA_BIT_WIDTH - 1):0] DATA_R = {(DATA_BIT_WIDTH){1'b0}};

    reg POS_DET_R = 1'b0;
    reg NEG_DET_R = 1'b0;

    wire POS_DET_W;
    wire NEG_DET_W;

    wire                          DCLKO_W;
    wire [(DATA_BIT_WIDTH - 1):0] DATAO_W;
    wire                          POS_DET_O_W;
    wire                          NEG_DET_O_W;

    generate
        if (IN_REG_EN == 1'b1) begin: genblk_inreg1_asyncreset
            /* w/ Input Register */
            reg                          DCLKI_R = 1'b0;
            reg [(DATA_BIT_WIDTH - 1):0] DATAI_R = {(DATA_BIT_WIDTH){1'b0}};

            always @(posedge CLK_I or negedge N_RST_I) begin
                if (N_RST_I == 1'b0) begin
                    DCLKI_R <= 1'b0;
                    DATAI_R <= {(DATA_BIT_WIDTH){1'b0}};
                end else begin
                    DCLKI_R <= DCLK_I;
                    DATAI_R <= DATA_I;
                end
            end

            assign DCLKI_W = DCLKI_R;
            assign DATAI_W = DATAI_R;
        end else begin: genblk_inreg0_asyncreset
            /* w/o Input Register */
            assign DCLKI_W = DCLK_I;
            assign DATAI_W = DATA_I;
        end
    endgenerate

    always @(posedge CLK_I or negedge N_RST_I) begin
        if (N_RST_I == 1'b0) begin
            DCLK_R <= 1'b0;
            DATA_R <= {(DATA_BIT_WIDTH){1'b0}};
        end else begin
            DCLK_R <= DCLKI_W;
            DATA_R <= DATAI_W;
        end
    end

    /* Edge detection */
    assign POS_DET_W =   DCLKI_W  & (~DCLK_R); // Positive Edge
    assign NEG_DET_W = (~DCLKI_W) &   DCLK_R;  // Negative Edge

    always @(posedge CLK_I or negedge N_RST_I) begin
        if (N_RST_I == 1'b0) begin
            POS_DET_R <= 1'b0;
            NEG_DET_R <= 1'b0;
        end else begin
            POS_DET_R <= POS_DET_W;
            NEG_DET_R <= NEG_DET_W;
        end
    end

    generate
        if (OUT_REG_EN == 1'b1) begin: genblk_outreg1_asyncreset
            /* w/ Output Register */
            reg                           POS_DET_O_R = 1'b0;
            reg                           NEG_DET_O_R = 1'b0;
            reg                           DCLKO_R     = 1'b0;
            reg [(DATA_BIT_WIDTH  - 1):0] DATAO_R     = {(DATA_BIT_WIDTH){1'b0}};

            always @(posedge CLK_I or negedge N_RST_I) begin
                if (N_RST_I == 1'b0) begin
                    POS_DET_O_R <=               1'b0;
                    NEG_DET_O_R <=               1'b0;
                    DCLKO_R     <=               1'b0;
                    DATAO_R     <= {(DATA_BIT_WIDTH){1'b0}};
                end else begin
                    POS_DET_O_R <= POS_DET_R;
                    NEG_DET_O_R <= NEG_DET_R;
                    DCLKO_R     <= DCLK_R   ;
                    DATAO_R     <= DATA_R   ;
                end
            end

            assign DCLKO_W     = DCLKO_R    ;
            assign DATAO_W     = DATAO_R    ;
            assign POS_DET_O_W = POS_DET_O_R;
            assign NEG_DET_O_W = NEG_DET_O_R;
        end else begin: genblk_outreg0_asyncreset
            /* w/o Output Register */
            assign DCLKO_W     = DCLK_R   ;
            assign DATAO_W     = DATA_R   ;
            assign POS_DET_O_W = POS_DET_R;
            assign NEG_DET_O_W = NEG_DET_R;
        end
    endgenerate

    /* Output assign */
    assign DCLK_O    = DCLKO_W    ;
    assign DATA_O    = DATAO_W    ;
    assign POS_DET_O = POS_DET_O_W;
    assign NEG_DET_O = NEG_DET_O_W;

    /* Formal Property Check (w/ sby) */
    `ifdef FORMAL
        always @(posedge CLK_I) begin
            if (N_RST_I) begin
                // (1). POS_DET_O and NEG_DET_O must never be high in the same clock cycle.
                formal_POS_NEG_NAND: assert (!((POS_DET_O == 1'b1) && (NEG_DET_O == 1'b1)));

                // (2). POS_DET_O must be high for exactly one clock cycle only.
                formal_POS_1CYCLE: assert (!((POS_DET_O == 1'b1) && ($past(POS_DET_O) == 1'b1)));

                // (3). NEG_DET_O must be high for exactly one clock cycle only.
                formal_NEG_1CYCLE: assert (!((NEG_DET_O == 1'b1) && ($past(NEG_DET_O) == 1'b1)));

                // (4). When POS_DET_O rises, DCLK_O shall rise simultaneously.
                formal_DCLK_POS: assert ((POS_DET_O == 1'b0) || ($rose(POS_DET_O) && $rose(DCLK_O)));

                // (5). When NEG_DET_O rises, DCLK_O shall fall simultaneously.
                formal_DCLK_NEG: assert ((NEG_DET_O == 1'b0) || ($rose(NEG_DET_O) && $fell(DCLK_O))); 
            end
        end
    `endif // FORMAL
    
endmodule

`default_nettype wire
