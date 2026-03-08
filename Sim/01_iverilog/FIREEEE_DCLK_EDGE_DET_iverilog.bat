:@echo off

cd /d %~dp1

del /Q FIREEEE_DCLK_EDGE_DET.o
del /Q FIREEEE_DCLK_EDGE_DET.vcd

iverilog -o FIREEEE_DCLK_EDGE_DET.o -s FIREEEE_DCLK_EDGE_DET_tb ^
-g2012 ../../FIREEEE_DCLK_EDGE_DET_tb.sv ^
../../ARESETN_SYNC.v ^
../../FIREEEE_DCLK_EDGE_DET.v ^
../../fireeee_dclk_edge_det_no_reset.v ^
../../fireeee_dclk_edge_det_sync_reset.v ^
../../fireeee_dclk_edge_det_async_reset.v

vvp FIREEEE_DCLK_EDGE_DET.o

gtkwave FIREEEE_DCLK_EDGE_DET.vcd
