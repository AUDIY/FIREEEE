/*-----------------------------------------------------------------------------
* FIREEEE_RAM_CTRL_tb.sv
*
* Testbench for FIREEEE_RAM_CTRL.v
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

module FIREEEE_RAM_CTRL_tb();
    
    timeunit 1ns / 1ps;

    /* Parameter Definition */
    localparam RESET_EN = 1'b1;
    localparam ASYNC_RESET_EN = 1'b1;
    localparam ADDR_WIDTH = 8;

    /* Input Signals */
    reg CLK_I   = 1'b0;
    reg WEN_I   = 1'b0;
    reg N_RST_I = 1'b0;

    /* Output Signals */
    wire unsigned [(ADDR_WIDTH - 1):0] WADDR_O;
    wire                               REN_O;
    wire unsigned [(ADDR_WIDTH - 1):0] RADDR_O;

    reg unsigned [(ADDR_WIDTH - 1):0] CLK_COUNT = '0;

    integer unsigned urand_rst = '0;

    /* Instantiation */
    generate
        if (RESET_EN == 1'b0) begin: dut_noreset
            /* w/o Reset */
            FIREEEE_RAM_CTRL #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .ADDR_WIDTH    (ADDR_WIDTH    )
            ) dut (
                .CLK_I  (CLK_I  ),
                .WEN_I  (WEN_I  ),
                .N_RST_I(1'b0   ),
                .WADDR_O(WADDR_O),
                .REN_O  (REN_O  ),
                .RADDR_O(RADDR_O)
            );
        end else if (ASYNC_RESET_EN == 1'b0) begin: dut_syncreset
            /* w/ Synchronous Reset */
            reg unsigned [1:0] N_RST_SYNC_I = '0;
            
            always @(posedge CLK_I) begin
                N_RST_SYNC_I <= {N_RST_SYNC_I[0], N_RST_I};
            end

            FIREEEE_RAM_CTRL #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .ADDR_WIDTH    (ADDR_WIDTH    )
            ) dut (
                .CLK_I  (CLK_I          ),
                .WEN_I  (WEN_I          ),
                .N_RST_I(N_RST_SYNC_I[1]),
                .WADDR_O(WADDR_O        ),
                .REN_O  (REN_O          ),
                .RADDR_O(RADDR_O        )
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

            FIREEEE_RAM_CTRL #(
                .RESET_EN      (RESET_EN      ),
                .ASYNC_RESET_EN(ASYNC_RESET_EN),
                .ADDR_WIDTH    (ADDR_WIDTH    )
            ) dut (
                .CLK_I  (CLK_I        ),
                .WEN_I  (WEN_I        ),
                .N_RST_I(N_RST_ASYNC_I),
                .WADDR_O(WADDR_O      ),
                .REN_O  (REN_O        ),
                .RADDR_O(RADDR_O      )
            );
        end
    endgenerate
    
    initial begin
        $dumpfile("FIREEEE_RAM_CTRL.vcd");
        $dumpvars(0, FIREEEE_RAM_CTRL_tb);

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
        WEN_I <= &CLK_COUNT;
    end

    `ifdef SVA
        // (1). WEN_I must have 1 cycle
        sva_wen_1cycle: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) $rose(WEN_I) |=> $fell(WEN_I)
        );

        // (2). If Write Enable and Read Enable is enable, 
        // Write addr and Read addr must not same value.
        sva_addr_neq: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) (WEN_I && REN_O) |-> (WADDR_O != RADDR_O)
        );

        // (3). If Write Enable is enabled and Addresses have same value, 
        // Read Enable must be disabled.
        sva_ren_disable: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) (WEN_I && (WADDR_O == RADDR_O)) |-> ~REN_O
        );

        // RADDR_O must have same value as WADDR_O after WEN_I is asseted.
        sva_addr_eq_start: assert property (
            @(posedge CLK_I) disable iff (!N_RST_I) $rose(WEN_I) |=> (WADDR_O == RADDR_O)
        );
    `endif // SVA

endmodule

`default_nettype wire
