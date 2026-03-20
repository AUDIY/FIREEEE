/*----------------------------------------------------------------------------
* FIREEEE_ROM_CTRL_tb.sv
*
* Testbench for FIREEEE_ROM_CTRL.v
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/03/20
*
* License under CERN-OHL-P v2
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

module FIREEEE_ROM_CTRL_tb ();

    timeunit 1ns / 1ps;

    localparam RESET_EN = 1'b0;
    localparam ASYNC_RESET_EN = 1'b1;
    localparam ROM_ADDR_WIDTH = 6;

    reg                                    CLK_I = 1'b0;
    reg                                    DCLK_EDGE_DET_I = 1'b0;
    reg                                    N_RST_I = 1'b0;
    wire unsigned [(ROM_ADDR_WIDTH - 1):0] RADDR_O;

    reg unsigned [(ROM_ADDR_WIDTH - 1):0] CLK_COUNT = '0;

    integer unsigned urand_rst = '0;

    /* Instantiation */
    generate
        if (RESET_EN == 1'b0) begin: dut_noreset
            /* w/o Reset */
            FIREEEE_ROM_CTRL #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
            ) dut (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .N_RST_I        (1'b0           ),
                .RADDR_O        (RADDR_O        )
            );
        end else if (ASYNC_RESET_EN == 1'b0) begin: dut_syncreset
            /* w/ Synchronous Reset */
            reg unsigned [1:0] N_RST_SYNC_I = '0;
            
            always @(posedge CLK_I) begin
                N_RST_SYNC_I <= {N_RST_SYNC_I[0], N_RST_I};
            end

            FIREEEE_ROM_CTRL #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
            ) dut (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .N_RST_I        (N_RST_SYNC_I[1]),
                .RADDR_O        (RADDR_O        )
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

            FIREEEE_ROM_CTRL #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
            ) dut (
                .CLK_I          (CLK_I          ),
                .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
                .N_RST_I        (N_RST_ASYNC_I  ),
                .RADDR_O        (RADDR_O        )
            );
        end
    endgenerate

    initial begin
        $dumpfile("FIREEEE_ROM_CTRL.vcd");
        $dumpvars(0, FIREEEE_ROM_CTRL_tb);

        #10000 $finish();
    end

    /* Reset Generation */
    initial begin
        #1 N_RST_I = 1'b1;

        forever begin
            urand_rst = $urandom_range(5000, 6000);
            #(urand_rst) N_RST_I = 1'b0;

            urand_rst = $urandom_range(3, 6);
            #(urand_rst) N_RST_I = 1'b1;
        end
    end

    /* Clock generation */
    initial begin
        forever begin
            #1 CLK_I = ~CLK_I;
        end
    end

    always @(posedge CLK_I) begin
        CLK_COUNT <= CLK_COUNT + 1'b1;
    end

    /* Signal Generation */
    always @(posedge CLK_I) begin
        DCLK_EDGE_DET_I <= &CLK_COUNT;
    end

    `ifdef SVA
        // (1). When DCLK_EDGE_DET_I falls, the value of RADDR_O must be set to 0.
        sva_raddr_start: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) $fell(DCLK_EDGE_DET_I) |-> RADDR_O == {(ROM_ADDR_WIDTH){1'b0}}
        );

        // (2). Otherwise, RADDR_O must increment by 1 from its value in the previous cycle.
        sva_raddr_incr: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) !($fell(DCLK_EDGE_DET_I)) |-> (RADDR_O == {(ROM_ADDR_WIDTH){1'b0}} || RADDR_O == $past(RADDR_O, 1) + 1'b1)
        );
    `endif // SVA
    
endmodule

`default_nettype wire
