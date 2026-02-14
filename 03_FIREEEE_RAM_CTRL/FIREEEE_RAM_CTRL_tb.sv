/*-----------------------------------------------------------------------------
* FIREEEE_RAM_CTRL_tb.sv
*
* Testbench for FIREEEE_RAM_CTRL.v
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/02/14
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

module FIREEEE_RAM_CTRL_tb #();
    
    timeunit 1ns / 1ps;

    /* Parameter Definition */
    localparam ADDR_WIDTH = 5;

    /* Input Signals */
    reg CLK_I = 1'b0;
    reg WEN_I = 1'b0;
    reg N_RST_I = 1'b0;

    /* Output Signals */
    wire unsigned [(ADDR_WIDTH - 1):0] WADDR_O;
    wire                               REN_O;
    wire unsigned [(ADDR_WIDTH - 1):0] RADDR_O;

    reg unsigned [(ADDR_WIDTH - 1):0] CLK_COUNT = '0;

    /* Instantiation */
    FIREEEE_RAM_CTRL #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .CLK_I  (CLK_I  ),
        .WEN_I  (WEN_I  ),
        .N_RST_I(N_RST_I),
        .WADDR_O(WADDR_O),
        .REN_O  (REN_O  ),
        .RADDR_O(RADDR_O)
    );

    initial begin
        $dumpfile("FIREEEE_RAM_CTRL_tb.vcd");
        $dumpvars(0, FIREEEE_RAM_CTRL_tb);

        N_RST_I = 1'b1;

        #5001 N_RST_I = 1'b0;
        #2 N_RST_I = 1'b1;

        #10000 $finish();
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

endmodule

`default_nettype wire
