:@echo off

cd /d %~dp1

del /Q FIREEEE_ROM_CTRL.o
del /Q FIREEEE_ROM_CTRL.vcd

iverilog -o FIREEEE_ROM_CTRL.o -s FIREEEE_ROM_CTRL_tb ^
-g2012 ../../FIREEEE_ROM_CTRL_tb.sv ^
../../FIREEEE_ROM_CTRL.v

vvp FIREEEE_ROM_CTRL.o

gtkwave FIREEEE_ROM_CTRL.vcd
