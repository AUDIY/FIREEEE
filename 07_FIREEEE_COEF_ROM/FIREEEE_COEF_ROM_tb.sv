/*-----------------------------------------------------------------------------
* FIREEEE_COEF_ROM_tb.sv
*
* Testbench for FIREEEE_COEF_ROM.v
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/03/22
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

module FIREEEE_COEF_ROM_tb ();
    
    timeunit 1ns / 1ps;

    localparam RESET_EN       = 1'b1;
    localparam ASYNC_RESET_EN = 1'b1;
    localparam ROM_ADDR_WIDTH = 8;
    localparam ROM_DATA_WIDTH = 8;
    localparam OUT_REG_EN     = 1'b1;
    localparam ROM_INIT_FILE  = "../initrom.hex";

    localparam CLK_COUNT_WIDTH = 8;

    `define FIREEEE_ROM_IP SPROM

    reg  CLK_I           = 1'b0;
    reg  DCLK_EDGE_DET_I = 1'b0;
    reg  RST             = 1'b0;
    wire N_RST_I;

    wire        [(ROM_ADDR_WIDTH - 1):0] RADDR_O;
    wire signed [(ROM_DATA_WIDTH - 1):0] COEF_O;

    reg [(CLK_COUNT_WIDTH - 1):0] CLK_COUNT = '0;

    integer unsigned urand_rst = '0;

    generate
        if (RESET_EN == 1'b0) begin: dut_noreset
            FIREEEE_COEF_ROM #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .ROM_DATA_WIDTH(ROM_ADDR_WIDTH),
                .ROM_ADDR_WIDTH(ROM_DATA_WIDTH),
                .OUT_REG_EN    (OUT_REG_EN    ),
                .ROM_INIT_FILE (ROM_INIT_FILE )
            ) dut (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .N_RST_I        (1'b0           ),
                .RADDR_O        (RADDR_O        ),
                .COEF_O         (COEF_O         )
            );

        end else if (ASYNC_RESET_EN == 1'b0) begin: dut_syncreset
            /* w/ Synchronous Reset */
            reg unsigned [1:0] N_RST_SYNC_I = '0;

            always @(posedge CLK_I) begin
                N_RST_SYNC_I <= {N_RST_SYNC_I[0], RST};
            end

            assign N_RST_I = N_RST_SYNC_I[1];

            FIREEEE_COEF_ROM #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .ROM_DATA_WIDTH(ROM_ADDR_WIDTH),
                .ROM_ADDR_WIDTH(ROM_DATA_WIDTH),
                .OUT_REG_EN    (OUT_REG_EN    ),
                .ROM_INIT_FILE (ROM_INIT_FILE )
            ) dut (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .N_RST_I        (N_RST_I        ),
                .RADDR_O        (RADDR_O        ),
                .COEF_O         (COEF_O         )
            );
        end else begin: dut_asyncreset
            /* w/ Asynchronous Reset */

            // Asynchronous Reset Synchronizer.
            // Please Refer https://github.com/AUDIY/AUDIY_Verilog_IP/tree/main/ARESETN_SYNC
            ARESETN_SYNC #(
                .STAGES(2)
            ) rst_sync (
                .CLK_I    (CLK_I  ),
                .ARESETN_I(RST    ),
                .RESETN_O (N_RST_I)
            );

            FIREEEE_COEF_ROM #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .ROM_DATA_WIDTH(ROM_ADDR_WIDTH),
                .ROM_ADDR_WIDTH(ROM_DATA_WIDTH),
                .OUT_REG_EN    (OUT_REG_EN    ),
                .ROM_INIT_FILE (ROM_INIT_FILE )
            ) dut (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .N_RST_I        (N_RST_I        ),
                .RADDR_O        (RADDR_O        ),
                .COEF_O         (COEF_O         )
            );
        end
    endgenerate

    initial begin
        $dumpfile("FIREEEE_COEF_ROM.vcd");
        $dumpvars(0, FIREEEE_COEF_ROM_tb);
        
        #100000 $finish();
    end

    /* Clock generation */
    initial begin
        forever begin
            #3 CLK_I = ~CLK_I;
        end
    end

    /* Reset Generation */
    initial begin
        #1 RST = 1'b1;

        forever begin
            urand_rst = $urandom_range(50000, 60000);
            #(urand_rst) RST = 1'b0;

            urand_rst = $urandom_range(3, 10);
            #(urand_rst) RST = 1'b1;
        end
    end

    /* Flag generation */
    always @(posedge CLK_I) begin
        CLK_COUNT <= CLK_COUNT + 1'b1;
    end

    always @(posedge CLK_I) begin
        DCLK_EDGE_DET_I <= &CLK_COUNT;
    end

    `ifdef SVA
        sva_addr_reset: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) ($fell(DCLK_EDGE_DET_I) |-> ##[1:2] (RADDR_O == {(ROM_ADDR_WIDTH){1'b0}}))
        );
    `endif // SVA

endmodule

`default_nettype wire
