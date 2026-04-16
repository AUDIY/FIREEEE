/*-----------------------------------------------------------------------------
* FIREEEE_RAM.v
*
* Simple Dual Port RAM (Single Clock) for FIREEEE
*
* Version: 0.03
* Author : AUDIY
* Date   : 2026/04/13
*
* Port
*   Input
*       CLK_I  : Clock
*       WEN_I  : Write Enable
*       WADDR_I: Write Address
*       WDATA_I: Write Data
*       REN_I  : Read Enable
*       RADDR_I: Read Address
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
| the terms of the CERN-OHL-P v2 (https://cern.ch/cern-ohl).                   |
|                                                                              |
| This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,          |
| INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A         |
| PARTICULAR PURPOSE. Please see the CERN-OHL-P v2 for applicable conditions.  |
--------------------------------------------------------------------------------
*
-----------------------------------------------------------------------------*/
`default_nettype none

module FIREEEE_RAM #(
    parameter DATA_WIDTH       = 32,
    parameter ADDR_WIDTH       = 8,
    parameter OUT_REG_EN       = 1'b0,
    parameter RAM_INIT_FILE    = ""  // Optional: Specify RAM initialization file here
) (
    input  wire                             CLK_I  ,
    input  wire                             WEN_I  ,
    input  wire        [(ADDR_WIDTH - 1):0] WADDR_I,
    input  wire signed [(DATA_WIDTH - 1):0] WDATA_I,
    input  wire                             REN_I  ,
    input  wire        [(ADDR_WIDTH - 1):0] RADDR_I,
    output wire signed [(DATA_WIDTH - 1):0] RDATA_O
);

    `ifndef FIREEEE_RAM_IP
        // If `FIREEEE_RAM_IP is not defined, use SDPRAM_SINGLECLK as default.
        // Please visit https://github.com/AUDIY/AUDIY_Verilog_IP/tree/main/Memory/SDPRAM_SINGLECLK to refer.
        `define FIREEEE_RAM_IP SDPRAM_SINGLECLK
    `endif

    // Instantiate "your" single clock simple dual-port RAM.
    localparam OUTPUT_REG = (OUT_REG_EN == 1'b0) ? "FALSE" : "TRUE";
    
    `FIREEEE_RAM_IP #(
        .DATA_WIDTH   (DATA_WIDTH   ),
        .ADDR_WIDTH   (ADDR_WIDTH   ),
        .OUTPUT_REG   (OUTPUT_REG   ),
        .RAM_INIT_FILE(RAM_INIT_FILE)
    ) u_sdpram_singleclk (
        .CLK_I    (CLK_I  ),
        .WENABLE_I(WEN_I  ),
        .WADDR_I  (WADDR_I),
        .WDATA_I  (WDATA_I),
        .RENABLE_I(REN_I  ),
        .RADDR_I  (RADDR_I),
        .RDATA_O  (RDATA_O)
    );
    
endmodule

`default_nettype wire
