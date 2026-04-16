/*-----------------------------------------------------------------------------
* FIREEEE_RAM_tb.sv
*
* Testbench for FIREEEE_RAM.v
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

module FIREEEE_RAM_tb ();

    timeunit 1ns / 10ps;

    localparam int unsigned ADDR_WIDTH = 9;
    localparam int unsigned DATA_WIDTH = 8;
    localparam OUT_REG_EN    = 1'b0;
    localparam RAM_INIT_FILE = "../ram_init_file.mem";

    reg                               CLK_I   = 1'b0;
    reg                               WEN_I   = 1'b0;
    reg unsigned [(ADDR_WIDTH - 1):0] WADDR_I = '0;
    reg unsigned [(DATA_WIDTH - 1):0] WDATA_I = '0;
    reg                               REN_I   = 1'b0;
    reg unsigned [(ADDR_WIDTH - 1):0] RADDR_I = '0;
    reg unsigned [(DATA_WIDTH - 1):0] RDATA_O;

    integer signed                        CYCLE_COUNT = '0;
    reg                                   SYS_CLK     = 1'b0;
    reg                                   RCLK        = 1'b0;
    reg     unsigned [(DATA_WIDTH - 1):0] EXPECTED    = '0;

    /* Instansiation */
    FIREEEE_RAM #(
        .DATA_WIDTH   (DATA_WIDTH   ),
        .ADDR_WIDTH   (ADDR_WIDTH   ),
        .OUT_REG_EN   (OUT_REG_EN   ),
        .RAM_INIT_FILE(RAM_INIT_FILE)
    ) dut (
        .CLK_I  (CLK_I  ),
        .WEN_I  (WEN_I  ),
        .WADDR_I(WADDR_I),
        .WDATA_I(WDATA_I),
        .REN_I  (REN_I  ),
        .RADDR_I(RADDR_I),
        .RDATA_O(RDATA_O)
    );

    initial begin
        $dumpfile("FIREEEE_RAM.vcd");
        $dumpvars(0, FIREEEE_RAM_tb);

        WDATA_I = 70;

        CYCLE_COUNT = -4;
    end

    /* Clock generation */
    always #75 begin
	        SYS_CLK = ~SYS_CLK;
        #25 RCLK    = ~RCLK;
        #25 CLK_I   = ~CLK_I;
    end
    
    /* Increment the cycle counter on the postive clock */
    always @(negedge SYS_CLK) begin
        CYCLE_COUNT = CYCLE_COUNT + 1;
        
        /* Allow 3 complete traversals of the memory address space */
        if (CYCLE_COUNT == 1023) begin
            $display("TEST : PASS");
            $finish;
        end
    end

/* Simulate the write port */
always @(negedge CLK_I) begin
	// let some cycles go before starting the writing and reading
	if (CYCLE_COUNT == -1) begin
	   // Enable writing just before cycle 0
	   WEN_I = 1'b1;
	end
	
	else if (CYCLE_COUNT >= 0) begin
		$display("%t === === === Write Cycle:%d === === ===", $time, CYCLE_COUNT);
		$display("WDATA : %d\tWADDR : %d\tWE : %d", WDATA_I, WADDR_I, WEN_I);
	
		//Increment data and address
		WDATA_I = WDATA_I + 2;
		WADDR_I = WADDR_I + 1;
	end
end

/* Simulate the read port */
always @(negedge CLK_I) begin
	// let some cycles go before starting the writing and reading
	if (CYCLE_COUNT == -1) begin
		// Enable reading just before cycle 0
		REN_I = 1'b1;
	end
   
	else if (CYCLE_COUNT >= 0) begin
	    $display("%t === === === Read Cycle: %d === === ===", $time, CYCLE_COUNT);
		$display("RADDR : %d\tRE : %d", RADDR_I, REN_I);
		$display("RDATA : %d", RDATA_O);

		// First read 256 uninitialized memory locations
		if (CYCLE_COUNT < 512) begin
			EXPECTED = 255 - CYCLE_COUNT;
		end

		// For the next 256 reads the data should be the value 00-FF
		if (CYCLE_COUNT >= 512) begin
			EXPECTED = 70 + ((CYCLE_COUNT - 512) * 2);
		end
 	 		 		 
		if (EXPECTED !== RDATA_O) begin
			$display("\tMISMATCH: Expected %d got RDATA : %d", EXPECTED, RDATA_O);
			$display("TEST : FAIL");
			$finish();
		end

		// Increment address
		RADDR_I = RADDR_I + 1;

	end
end

endmodule

`default_nettype wire
