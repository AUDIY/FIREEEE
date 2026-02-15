/*-----------------------------------------------------------------------------
* FIREEEE_DATA_RAM_tb.sv
*
* Testbench for FIREEEE_DATA_RAM.v
*
* Version: 0.02
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

module FIREEEE_DATA_RAM_tb ();
    
    localparam RAM_DATA_WIDTH = 32;
    localparam RAM_ADDR_WIDTH = 6;
    localparam OUTPUT_REG     = "FALSE";
    localparam RAM_INIT_FILE  = "";

    localparam CLK_COUNT_WIDTH = 9;

    `define FIREEEE_RAM_IP SDPRAM_SINGLECLK

    reg                                  CLK_I = 1'b0;
    wire                                 DCLK_I;
    reg  signed [(RAM_DATA_WIDTH - 1):0] DATA_I = '0;
    wire                                 WEN;
    wire signed [(RAM_DATA_WIDTH - 1):0] WDATA;
    reg                                  N_RST_I = 1'b0;
    wire signed [(RAM_DATA_WIDTH - 1):0] RDATA_O;

    reg [(CLK_COUNT_WIDTH - 1):0] CLK_COUNT = '0;

    integer fp;
    integer rp;

    /* Data Clock Edge Detector */
    // Please refer https://github.com/AUDIY/FIREEEE/tree/main/01_FIREEEE_DCLK_EDGE_DET for detail
    FIREEEE_DCLK_EDGE_DET #(
        .DATA_WIDTH(RAM_DATA_WIDTH),
        .ADDR_WIDTH(RAM_ADDR_WIDTH)
    ) edge_det (
        .CLK_I    (CLK_I  ),
        .DCLK_I   (DCLK_I ),
        .DATA_I   (DATA_I ),
        .N_RST_I  (N_RST_I),
        .DCLK_O   (       ),
        .DATA_O   (WDATA  ),
        .POS_DET_O(WEN    ),
        .NEG_DET_O(       )
    );

    /* Instantiation DUT */
    FIREEEE_DATA_RAM #(
        .RAM_DATA_WIDTH(RAM_DATA_WIDTH),
        .RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
        .OUTPUT_REG    (OUTPUT_REG    ),
        .RAM_INIT_FILE (RAM_INIT_FILE )
    ) dut (
        .CLK_I  (CLK_I  ),
        .WEN_I  (WEN    ),
        .WDATA_I(WDATA  ),
        .N_RST_I(N_RST_I),
        .RDATA_O(RDATA_O)
    );

    initial begin
        $dumpfile("FIREEEE_DATA_RAM.vcd");
        $dumpvars(0, FIREEEE_DATA_RAM_tb);

        if (fp != 0) begin
            $fclose(fp);
        end

        fp = $fopen("../PCM_1kHz_44100fs_32bit.txt", "r");

        if (fp == 0) begin
            $display("ERROR: The file doesn't exist.");
            $finish(0);
        end

        #2 N_RST_I = 1'b1;

        #5001 N_RST_I = 1'b0;
        #2    N_RST_I = 1'b1;

        #250000 $finish();
    end

    /* Clock generation */
    initial begin
        forever begin
            #1 CLK_I = ~CLK_I;
        end
    end

    /* Data clock generation */
    always @(posedge CLK_I) begin
        CLK_COUNT <= CLK_COUNT + 1'b1;
    end

    assign DCLK_I = CLK_COUNT[CLK_COUNT_WIDTH - 1];

    /* Data generation */
    always @(negedge DCLK_I) begin
        rp = $fscanf(fp, "%d\n", DATA_I);
    end

endmodule

`default_nettype wire
