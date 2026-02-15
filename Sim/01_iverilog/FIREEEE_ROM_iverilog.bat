:@echo off

cd /d %~dp1

del /Q FIREEEE_ROM.o
del /Q FIREEEE_ROM.vcd

iverilog -o FIREEEE_ROM.o -s FIREEEE_ROM_tb ^
-g2012 ../../FIREEEE_ROM_tb.sv ^
../../SPROM.v ^
../../FIREEEE_ROM.v

vvp FIREEEE_ROM.o

gtkwave FIREEEE_ROM.vcd 
