/*-----------------------------------------------------------------------------
* FIREEEE_ROM.v
*
* Single Port ROM for FIREEEE
*
* Version: 0.01
* Author : AUDIY
* Date   : 2026/02/15
*
* Port
*   Input
*       CLK_I  : Clock
*       RADDR_I: Read Address
*
*   Output
*       RDATA_O: Read data
*
* Parameter
*       DATA_WIDTH   : Input/Output data width
*       ADDR_WIDTH   : Input/Output Address width
*       OUTPUT_REG   : Additional Output Register
*       ROM_INIT_FILE: ROM Initialization File
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

module FIREEEE_ROM #(
    parameter DATA_WIDTH    = 16           ,
    parameter ADDR_WIDTH    = 8            ,
    parameter OUTPUT_REG    = "FALSE"      ,
    parameter ROM_INIT_FILE = "initrom.hex"
) (
    input  wire                      CLK_I  ,
    input  wire [(ADDR_WIDTH - 1):0] RADDR_I,
    output wire [(DATA_WIDTH - 1):0] RDATA_O
);
    
    `ifndef FIREEEE_ROM_IP
        // If `FIREEEE_ROM_IP is not defined, use SPROM as default.
        // Please visit https://github.com/AUDIY/AUDIY_Verilog_IP/tree/main/Memory/SPROM to refer.
        `define FIREEEE_ROM_IP SPROM
    `endif

    `FIREEEE_ROM_IP #(
        .DATA_WIDTH   (DATA_WIDTH   ),
        .ADDR_WIDTH   (ADDR_WIDTH   ),
        .OUTPUT_REG   (OUTPUT_REG   ),
        .ROM_INIT_FILE(ROM_INIT_FILE)
    ) u_single_port_rom (
        .CLK_I  (CLK_I  ),
        .RADDR_I(RADDR_I),
        .RDATA_O(RDATA_O)
    );

endmodule

`default_nettype wire
