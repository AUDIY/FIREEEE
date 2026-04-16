/*----------------------------------------------------------------------------
* FIREEEE_ROM_tb.sv
*
* Testbench for FIREEEE_ROM.v
*
* Version: 0.03
* Author : AUDIY
* Date   : 2026/04/13
*
* License under CERN-OHL-P v2
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

`define FIREEEE_ROM_IP SPROM // Define Instanciated ROM IP

module FIREEEE_ROM_tb ();

	timeunit 1ns / 1ps;

	localparam DATA_WIDTH    = 16;
	localparam ADDR_WIDTH    = 8;
	localparam OUT_REG_EN    = 1'b0;
	localparam ROM_INIT_FILE = "../initrom.hex";

	reg     [ADDR_WIDTH  - 1 : 0] ADDR       ;
	reg                           clock      ;
	reg     [DATA_WIDTH  - 1 : 0] expected   ;
	wire    [DATA_WIDTH  - 1 : 0] OUT        ;
	integer                       cycle_count;

	FIREEEE_ROM #(
		.DATA_WIDTH   (DATA_WIDTH   ),
		.ADDR_WIDTH   (ADDR_WIDTH   ),
		.OUT_REG_EN   (OUT_REG_EN   ),
		.ROM_INIT_FILE(ROM_INIT_FILE)
	) dut (
		.CLK_I  (clock),
		.RADDR_I(ADDR ),
		.RDATA_O(OUT  )
	);

	// Initialize inputs
	initial begin
		$dumpfile("FIREEEE_ROM.vcd");
		$dumpvars(0, FIREEEE_ROM_tb);
   
		ADDR        =  0;
		clock       =  0;
		cycle_count = -2;
	end

	// Generate the clock
	always #100 clock = ~clock;

	// Simulate
	always @(negedge clock) begin
		if (cycle_count == -1) begin
		end
	   
		else if (cycle_count >= 0) begin
			$display("=== === === Cycle:%d === === ===", cycle_count);
			$display("ADDR : %x", ADDR);
			$display("\tOUT : %x", OUT);
		
			// ROM with the pattern 3F .. 30
			expected = 16'hFF - (cycle_count % 256);
		
			// increament address every cycle
			ADDR = ADDR + 1;
		
			if (expected !== OUT) begin
				$display("\tMISMATCH: Expected %x got OUT : %x", expected, OUT);
				$display("TEST : FAIL");
				$finish();
			end
		
			if (cycle_count == 320) begin
				$display("TEST : PASS");
				$finish;
			end
		end
	
		cycle_count = cycle_count + 1;
	
	end

endmodule

`default_nettype wire
