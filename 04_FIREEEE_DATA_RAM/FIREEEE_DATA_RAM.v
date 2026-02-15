/*-----------------------------------------------------------------------------
* FIREEEE_DATA_RAM.v
*
* Input Data RAM for FIREEEE
*
* Version: 0.02
* Author : AUDIY
* Date   : 2026/02/15
*
* Port
*   Input
*       CLK_I  : Clock
*       WEN_I  : Write Enable
*       WDATA_I: Write Data
*       N_RST_I: Synchronous Reset (Active LOW)
*
*   Output
*       RDATA_O: Read data
*
* Parameter
*       DATA_WIDTH   : Input/Output data width
*       ADDR_WIDTH   : Input/Output Address width
*       OUTPUT_REG   : Additional Output Register
*       RAM_INIT_FILE: RAM Initialization File
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

module FIREEEE_DATA_RAM #(
    parameter RAM_DATA_WIDTH = 32,
    parameter RAM_ADDR_WIDTH = 8,
    parameter OUTPUT_REG     = "FALSE",
    parameter RAM_INIT_FILE  = ""
) (
    input  wire                                 CLK_I  ,
    input  wire                                 WEN_I  ,
    input  wire signed [(RAM_DATA_WIDTH - 1):0] WDATA_I,
    input  wire                                 N_RST_I,
    output wire signed [(RAM_DATA_WIDTH - 1):0] RDATA_O
);

    /* Internal wire/reg */
    wire [(RAM_ADDR_WIDTH - 1):0] WADDR;
    wire                          REN;
    wire [(RAM_ADDR_WIDTH - 1):0] RADDR;

    /* Instantiate FIREEEE_RAM_CTRL */
    // Please refer https://github.com/AUDIY/FIREEEE/tree/main/03_FIREEEE_RAM_CTRL for detail.
    FIREEEE_RAM_CTRL #(
        .ADDR_WIDTH(RAM_ADDR_WIDTH)
    ) fireeee_ram_ctrl (
        .CLK_I  (CLK_I  ),
        .WEN_I  (WEN_I  ),
        .N_RST_I(N_RST_I),
        .WADDR_O(WADDR  ),
        .REN_O  (REN    ),
        .RADDR_O(RADDR  )
    );

    /* Instantiate FIREEEE_RAM */
    // Please refer https://github.com/AUDIY/FIREEEE/tree/main/02_FIREEEE_RAM for detail.
    FIREEEE_RAM #(
        .DATA_WIDTH   (RAM_DATA_WIDTH),
        .ADDR_WIDTH   (RAM_ADDR_WIDTH),
        .OUTPUT_REG   (OUTPUT_REG    ),
        .RAM_INIT_FILE(RAM_INIT_FILE )
    ) fireee_ram (
        .CLK_I  (CLK_I  ),
        .WEN_I  (WEN_I  ),
        .WADDR_I(WADDR  ),
        .WDATA_I(WDATA_I),
        .REN_I  (REN    ),
        .RADDR_I(RADDR  ),
        .RDATA_O(RDATA_O)
    );
    
endmodule

`default_nettype wire
