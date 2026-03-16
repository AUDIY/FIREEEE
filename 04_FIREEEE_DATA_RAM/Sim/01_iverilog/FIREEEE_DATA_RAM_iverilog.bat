:@echo off

cd /d %~dp1

del /Q FIREEEE_DATA_RAM.o
del /Q FIREEEE_DATA_RAM.vcd

iverilog -o FIREEEE_DATA_RAM.o -s FIREEEE_DATA_RAM_tb ^
-g2012 ../../FIREEEE_DATA_RAM_tb.sv ^
../../FIREEEE_DATA_RAM.v ^
../../../01_FIREEEE_DCLK_EDGE_DET/fireeee_dclk_edge_det_no_reset.v ^
../../../01_FIREEEE_DCLK_EDGE_DET/fireeee_dclk_edge_det_sync_reset.v ^
../../../01_FIREEEE_DCLK_EDGE_DET/fireeee_dclk_edge_det_async_reset.v ^
../../../01_FIREEEE_DCLK_EDGE_DET/FIREEEE_DCLK_EDGE_DET.v ^
../../../02_FIREEEE_RAM/SDPRAM_SINGLECLK.v ^
../../../02_FIREEEE_RAM/FIREEEE_RAM.v ^
../../../03_FIREEEE_RAM_CTRL/fireeee_ram_ctrl_no_reset.v ^
../../../03_FIREEEE_RAM_CTRL/fireeee_ram_ctrl_sync_reset.v ^
../../../03_FIREEEE_RAM_CTRL/fireeee_ram_ctrl_async_reset.v ^
../../../03_FIREEEE_RAM_CTRL/FIREEEE_RAM_CTRL.v ^
../../ARESETN_SYNC.v

vvp FIREEEE_DATA_RAM.o

gtkwave FIREEEE_DATA_RAM.vcd
