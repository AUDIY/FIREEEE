/*-----------------------------------------------------------------------------
* FIREEEE_COEF_ROM.v
*
* Input Data RAM for FIREEEE
*
* Version: 0.03
* Author : AUDIY
* Date   : 2026/04/13
*
* Port
*   Input
*       CLK_I          : Clock
*       DCLK_EDGE_DET_I: Data clock positive edge detection
*       N_RST_I        : Reset (Active LOW)
*
*   Output
*       RADDR_O: Read Address
*       COEF_O : Filter Coefficient
*
* Parameter
*   RESET_EN       : Reset Enable (Default: 1'b1 = Enable)
*   ASYNC_RESET_EN : Asynchronous Reset Enable (Default: 1'b1 = Asynchronous Reset)
*   ROM_DATA_WIDTH : ROM data width
*   ROM_ADDR_WIDTH : ROM Address width
*   OUT_REG_EN     : Additional Output Register (Default: 1'b0 = Disable)
*   ROM_INIT_FILE  : ROM Initialization File
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

module FIREEEE_COEF_ROM #(
    parameter RESET_EN       = 1'b1,
    parameter ASYNC_RESET_EN = 1'b1,
    parameter ROM_DATA_WIDTH = 32,
    parameter ROM_ADDR_WIDTH = 9,
    parameter OUT_REG_EN     = 1'b0,
    parameter ROM_INIT_FILE  = "initrom.hex"
) (
    input  wire                                 CLK_I,
    input  wire                                 DCLK_EDGE_DET_I,
    input  wire                                 N_RST_I,
    output wire        [(ROM_ADDR_WIDTH - 1):0] RADDR_O,
    output wire signed [(ROM_DATA_WIDTH - 1):0] COEF_O
);

    /* Internal wire/reg */
    wire [(ROM_ADDR_WIDTH - 1):0] RADDR;
    reg  [(ROM_ADDR_WIDTH - 1):0] RADDR_REG1 = {(ROM_ADDR_WIDTH){1'b0}};
    reg  [(ROM_ADDR_WIDTH - 1):0] RADDR_REG2 = {(ROM_ADDR_WIDTH){1'b0}};

    /* Instantiate FIREEEE_ROM_CTRL */
    // Please refer https://github.com/AUDIY/FIREEEE/tree/main/06_FIREEEE_ROM_CTRL for detail.
    FIREEEE_ROM_CTRL #(
        .RESET_EN      (RESET_EN      ),
        .ASYNC_RESET_EN(ASYNC_RESET_EN),
        .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
    ) u_rom_ctrl (
        .CLK_I          (CLK_I          ),
        .DCLK_EDGE_DET_I(DCLK_EDGE_DET_I),
        .N_RST_I        (N_RST_I        ),
        .RADDR_O        (RADDR          )
    );

    /* Instantiate FIREEEE_ROM */
    // Please refer https://github.com/AUDIY/FIREEEE/tree/main/05_FIREEEE_ROM for detail.
    FIREEEE_ROM #(
        .DATA_WIDTH   (ROM_DATA_WIDTH),
        .ADDR_WIDTH   (ROM_ADDR_WIDTH),
        .OUT_REG_EN   (OUT_REG_EN    ),
        .ROM_INIT_FILE(ROM_INIT_FILE )
    ) u_rom (
        .CLK_I  (CLK_I ),
        .RADDR_I(RADDR ),
        .RDATA_O(COEF_O)
    );

    generate
        if (RESET_EN == 1'b0) begin : genblk_coefrom_noreset
            /* w/o Reset */
            always @(posedge CLK_I) begin
                RADDR_REG1 <= RADDR;
                RADDR_REG2 <= RADDR_REG1;
            end
        end else if (ASYNC_RESET_EN == 1'b0) begin : genblk_coefrom_syncreset
            /* w/ Synchronous Reset */
            always @(posedge CLK_I) begin
                if (N_RST_I == 1'b0) begin
                    RADDR_REG1 <= {(ROM_ADDR_WIDTH){1'b0}};
                    RADDR_REG2 <= {(ROM_ADDR_WIDTH){1'b0}};
                end else begin
                    RADDR_REG1 <= RADDR;
                    RADDR_REG2 <= RADDR_REG1; 
                end
            end
        end else begin : genblk_coefrom_asyncreset
            /* w/ Asynchronous Reset */
            always @(posedge CLK_I or negedge N_RST_I) begin
                if (N_RST_I == 1'b0) begin
                    RADDR_REG1 <= {(ROM_ADDR_WIDTH){1'b0}};
                    RADDR_REG2 <= {(ROM_ADDR_WIDTH){1'b0}};
                end else begin
                    RADDR_REG1 <= RADDR;
                    RADDR_REG2 <= RADDR_REG1; 
                end
            end
        end
    endgenerate

    generate
        if (OUT_REG_EN == 1'b0) begin : genblk_oreg_0
            /* w/o Output Register */
            assign RADDR_O = RADDR_REG1;
        end else begin : genblk_oreg_1
            /* w/ Output Register */
            assign RADDR_O = RADDR_REG2;
        end
    endgenerate
    
endmodule

`default_nettype wire
