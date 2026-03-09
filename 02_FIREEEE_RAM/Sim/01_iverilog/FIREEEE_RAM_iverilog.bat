:@echo off

cd /d %~dp1

del /Q FIREEEE_RAM.o
del /Q FIREEEE_RAM.vcd

iverilog -o FIREEEE_RAM.o -s FIREEEE_RAM_tb ^
-D FIREEEE_RAM_IP=SDPRAM_SINGLECLK ^
-g2005-sv ../../FIREEEE_RAM_tb.sv ^
../../SDPRAM_SINGLECLK.v ^
../../FIREEEE_RAM.v

vvp FIREEEE_RAM.o

gtkwave FIREEEE_RAM.vcd
