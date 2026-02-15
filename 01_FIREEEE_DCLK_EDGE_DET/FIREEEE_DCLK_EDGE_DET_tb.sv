/*-----------------------------------------------------------------------------
* FIREEEE_DCLK_EDGE_DET_tb.sv
*
* Testbench for FIREEEE_DCLK_EDGE_DET.v
*
* Version: 0.03
* Author : AUDIY
* Date   : 2026/02/15
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

module FIREEEE_DCLK_EDGE_DET_tb ();

    timeunit 1ns / 1ps;

    localparam DATA_WIDTH      = 8;
    localparam ADDR_WIDTH      = 3;
    localparam CLK_COUNT_WIDTH = 10;

    reg                             CLK_I   = 1'b0;
    reg                             DCLK_I  = 1'b0;
    reg signed [(DATA_WIDTH - 1):0] DATA_I  = {(DATA_WIDTH){1'b0}};
    reg                             N_RST_I = 1'b0;
    
    wire                             DCLK_O;
    wire signed [(DATA_WIDTH - 1):0] DATA_O;
    wire                             POS_DET_O;
    wire                             NEG_DET_O;

    reg     unsigned [(CLK_COUNT_WIDTH - 1):0] CLK_COUNT = '0;
    
    integer unsigned urandom = '0;
    integer signed   random  = '0;

    /* Instantiation */
    FIREEEE_DCLK_EDGE_DET #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .CLK_I    (CLK_I    ),
        .DCLK_I   (DCLK_I   ),
        .DATA_I   (DATA_I   ),
        .N_RST_I  (N_RST_I  ),
        .DCLK_O   (DCLK_O   ),
        .DATA_O   (DATA_O   ),
        .POS_DET_O(POS_DET_O),
        .NEG_DET_O(NEG_DET_O)
    );

    initial begin
        $dumpfile("FIREEEE_DCLK_EDGE_DET.vcd");
        $dumpvars(0, FIREEEE_DCLK_EDGE_DET_tb);

        #1000 $finish();
    end

    /* Clock Generation */
    initial begin
        forever begin
            #1 CLK_I = ~CLK_I;
        end
    end

    /* Reset & Data Clock Generation */
    always @(posedge CLK_I) begin
        CLK_COUNT <= CLK_COUNT + 1'b1;

        DCLK_I <= CLK_COUNT[2];

        urandom = $urandom_range(1000);
        if (urandom >= 990) begin
            N_RST_I <= 1'b0;
        end else begin
            N_RST_I <= 1'b1;
        end
    end

    /* Random Data Generation */
    always @(negedge DCLK_I) begin
        random = $random();
        DATA_I <= {random[31], random[(DATA_WIDTH - 2):0]}; // Any Signed Data
    end

endmodule

`default_nettype wire
