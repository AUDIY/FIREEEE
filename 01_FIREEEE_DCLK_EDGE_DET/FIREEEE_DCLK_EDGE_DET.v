/*-----------------------------------------------------------------------------
* FIREEEE_DCLK_EDGE_DET.v
*
* Data Clock Edge Detector for FIREEEE
*
* Version: 0.03
* Date   : 2026/02/15
* Author : AUDIY
*
* Port
*   Input
*       CLK_I  : Clock
*       DCLK_I : Data Clock
*       DATA_I : Data
*       N_RST_I: Synchronous Reset (Active LOW)
*
*   Output
*       DCLK_O   : Data Clock
*       DATA_O   : Data
*       POS_DET_O: Positive Edge Flag
*       NEG_DET_O: Negative Edge Flag
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
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8
) (
    input  wire                             CLK_I    ,
    input  wire                             DCLK_I   ,
    input  wire signed [(DATA_WIDTH - 1):0] DATA_I   ,
    input  wire                             N_RST_I  ,
    output wire                             DCLK_O   ,
    output wire signed [(DATA_WIDTH - 1):0] DATA_O   ,
    output wire                             POS_DET_O,
    output wire                             NEG_DET_O
);

    reg [(ADDR_WIDTH - 1):0] POS_COUNT = {(ADDR_WIDTH){1'b0}};
    reg [(ADDR_WIDTH - 1):0] NEG_COUNT = {(ADDR_WIDTH){1'b0}};

    reg                             DCLK1 = 1'b0;
    reg signed [(DATA_WIDTH - 1):0] DATA1 = {(DATA_WIDTH){1'b0}};

    wire POS_DET_W;
    wire NEG_DET_W;

    reg POS_DET_R = 1'b0;
    reg NEG_DET_R = 1'b0;

    always @(posedge CLK_I) begin
        DCLK1 <= DCLK_I;
    end

    /* Edge Flag generation. */
    assign POS_DET_W =   DCLK_I  & (~DCLK1);
    assign NEG_DET_W = (~DCLK_I) &   DCLK1 ;

    /* Positive Edge Count for Flag & Data Mute. */
    always @(posedge CLK_I) begin
        if (!N_RST_I) begin
            POS_COUNT <= {(ADDR_WIDTH){1'b0}};
        end else begin
            if (POS_DET_W && (POS_COUNT != {(ADDR_WIDTH){1'b1}})) begin
                POS_COUNT <= POS_COUNT + 1'b1;
            end else begin
                POS_COUNT <= POS_COUNT;
            end
        end
    end

    /* Negative Edge Count for Flag & Data Mute. */
    always @(posedge CLK_I) begin
        if (!N_RST_I) begin
            NEG_COUNT <= {(ADDR_WIDTH){1'b0}};
        end else begin
            if (NEG_DET_W && (NEG_COUNT != {(ADDR_WIDTH){1'b1}})) begin
                NEG_COUNT <= NEG_COUNT + 1'b1;
            end else begin
                NEG_COUNT <= NEG_COUNT;
            end
        end
    end

    /* Edge Flag */
    always @(posedge CLK_I) begin
        POS_DET_R <= POS_DET_W;
        NEG_DET_R <= NEG_DET_W;
    end

    /* Data Mute */
    always @(posedge CLK_I) begin
        if (!N_RST_I || (~&POS_COUNT) || (~&NEG_COUNT)) begin
            DATA1 <= {(DATA_WIDTH){1'b0}};
        end else begin
            DATA1 <= DATA_I;
        end
    end

    /* Output Assign */
    assign DCLK_O    = DCLK1    ;
    assign DATA_O    = DATA1    ;
    assign POS_DET_O = POS_DET_R;
    assign NEG_DET_O = NEG_DET_R;
    
endmodule

`default_nettype wire
