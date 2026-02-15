:@echo off

cd /d %~dp1

del /Q FIREEEE_DCLK_EDGE_DET.o
del /Q FIREEEE_DCLK_EDGE_DET.vcd

iverilog -o FIREEEE_DCLK_EDGE_DET.o -s FIREEEE_DCLK_EDGE_DET_tb ^
-g2012 ../../FIREEEE_DCLK_EDGE_DET_tb.sv ^
../../FIREEEE_DCLK_EDGE_DET.v

vvp FIREEEE_DCLK_EDGE_DET.o

gtkwave FIREEEE_DCLK_EDGE_DET.vcd