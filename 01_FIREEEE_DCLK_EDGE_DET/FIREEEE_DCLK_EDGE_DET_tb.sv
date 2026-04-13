/*-----------------------------------------------------------------------------
* FIREEEE_DCLK_EDGE_DET_tb.sv
*
* Testbench for FIREEEE_DCLK_EDGE_DET.v
*
* Version: 0.03
* Author : AUDIY
* Date   : 2026/04/13
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

module FIREEEE_DCLK_EDGE_DET_tb ();

    timeunit 1ns / 1ps;

    localparam RESET_EN        = 1'b1;
    localparam ASYNC_RESET_EN  = 1'b1;
    localparam DATA_BIT_WIDTH  = 8;
    localparam IN_REG_EN       = 1'b1;
    localparam OUT_REG_EN      = 1'b1;
    localparam CLK_COUNT_WIDTH = 10;

    reg                                 CLK_I   = 1'b0;
    reg                                 DCLK_I  = 1'b0;
    reg signed [(DATA_BIT_WIDTH - 1):0] DATA_I  = {(DATA_BIT_WIDTH){1'b0}};
    reg                                 N_RST_I = 1'b0;

    wire                                 DCLK_O;
    wire signed [(DATA_BIT_WIDTH - 1):0] DATA_O;
    wire                                 POS_DET_O;
    wire                                 NEG_DET_O;

    reg     unsigned [(CLK_COUNT_WIDTH - 1):0] CLK_COUNT = '0;
    
    integer unsigned urandom = '0;
    integer signed   random  = '0;

    /* Instantiation */
    generate
        if (RESET_EN == 1'b0) begin: dut_noreset
            /* w/o Reset */
            FIREEEE_DCLK_EDGE_DET #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) dut (
                .CLK_I    (CLK_I    ),
                .DCLK_I   (DCLK_I   ),
                .DATA_I   (DATA_I   ),
                .N_RST_I  (1'b0     ), // No effect 
                .DCLK_O   (DCLK_O   ),
                .DATA_O   (DATA_O   ),
                .POS_DET_O(POS_DET_O),
                .NEG_DET_O(NEG_DET_O)
            );
        end else if (ASYNC_RESET_EN == 1'b0) begin: dut_syncreset
            /* w/ Synchronous Reset */
            reg unsigned [1:0] N_RST_SYNC_I = '0;

            always @(posedge CLK_I) begin
                N_RST_SYNC_I <= {N_RST_SYNC_I[0], N_RST_I};
            end 

            FIREEEE_DCLK_EDGE_DET #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) dut (
                .CLK_I    (CLK_I          ),
                .DCLK_I   (DCLK_I         ),
                .DATA_I   (DATA_I         ),
                .N_RST_I  (N_RST_SYNC_I[1]),
                .DCLK_O   (DCLK_O         ),
                .DATA_O   (DATA_O         ),
                .POS_DET_O(POS_DET_O      ),
                .NEG_DET_O(NEG_DET_O      )
            );
        end else begin: dut_asyncreset
            /* w/ Asynchronous Reset */
            wire N_RST_ASYNC_I;

            // Asynchronous Reset Synchronizer.
            // Please Refer https://github.com/AUDIY/AUDIY_Verilog_IP/tree/main/ARESETN_SYNC
            ARESETN_SYNC #(
                .STAGES(2)
            ) rst_sync (
                .CLK_I    (CLK_I        ),
                .ARESETN_I(N_RST_I      ),
                .RESETN_O (N_RST_ASYNC_I)
            );

            FIREEEE_DCLK_EDGE_DET #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .DATA_BIT_WIDTH(DATA_BIT_WIDTH),
                .IN_REG_EN     (IN_REG_EN     ),
                .OUT_REG_EN    (OUT_REG_EN    )
            ) dut (
                .CLK_I    (CLK_I        ),
                .DCLK_I   (DCLK_I       ),
                .DATA_I   (DATA_I       ),
                .N_RST_I  (N_RST_ASYNC_I),
                .DCLK_O   (DCLK_O       ),
                .DATA_O   (DATA_O       ),
                .POS_DET_O(POS_DET_O    ),
                .NEG_DET_O(NEG_DET_O    )
            );
        end
    endgenerate

    initial begin
        $dumpfile("FIREEEE_DCLK_EDGE_DET.vcd");
        $dumpvars(0, FIREEEE_DCLK_EDGE_DET_tb);

        #1000 $finish();
    end

    /* Reset Generation */
    initial begin
        #1 N_RST_I = 1'b1;

        forever begin
            urandom = $urandom_range(200, 300);
            #(urandom) N_RST_I = 1'b0;

            urandom = $urandom_range(0, 20);
            #(urandom) N_RST_I = 1'b1; 
        end
    end

    /* Clock Generation */
    initial begin
        forever begin
            #3 CLK_I = ~CLK_I;
        end
    end

    /* Data Clock Generation */
    always @(posedge CLK_I) begin
        CLK_COUNT <= CLK_COUNT + 1'b1;

        DCLK_I <= CLK_COUNT[2];
    end

    /* Random Data Generation */
    always @(negedge DCLK_I) begin
        random <= $random();
        DATA_I <= {random[31], random[(DATA_BIT_WIDTH - 2):0]}; // Any Signed Data
    end

    /* Assetions */
    `ifdef SVA
        // (1). If POS_DET_O is high,  NEG_DET_O must never be high in the same clock cycle.
        sva_pos_neg_nand1: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) (POS_DET_O |-> !NEG_DET_O)
        );

        // (2). If NEG_DET_O is high,  POS_DET_O must never be high in the same clock cycle.
        sva_pos_neg_nand2: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) (NEG_DET_O |-> !POS_DET_O)
        );

        // (3). POS_DET_O must be high for exactly one clock cycle only.
        sva_pos_1cycle: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) ($rose(POS_DET_O) |=> $fell(POS_DET_O))
        );

        // (4). NEG_DET_O must be high for exactly one clock cycle only.
        sva_neg_1cycle: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) ($rose(NEG_DET_O) |=> $fell(NEG_DET_O))
        );

        // (5). When POS_DET_O rises, DCLK_O shall rise simultaneously.
        sva_dclk_pos: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) ($rose(POS_DET_O) |-> $rose(DCLK_O))
        );

        // (6). When NEG_DET_O rises, DCLK_O shall fall simultaneously.
        sva_dclk_neg: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) ($rose(NEG_DET_O) |-> $fell(DCLK_O))
        );
    `endif // SVA

endmodule

`default_nettype wire
