:@echo off

cd /d %~dp1

del /Q FIREEEE_COEF_ROM.o
del /Q FIREEEE_COEF_ROM.vcd

iverilog -o FIREEEE_COEF_ROM.o -s FIREEEE_COEF_ROM_tb ^
-g2012 ../../FIREEEE_COEF_ROM_tb.sv ^
../../FIREEEE_COEF_ROM.v ^
../../../05_FIREEEE_ROM/SPROM.v ^
../../../05_FIREEEE_ROM/FIREEEE_ROM.v ^
../../../06_FIREEEE_ROM_CTRL/fireeee_rom_ctrl_no_reset.v ^
../../../06_FIREEEE_ROM_CTRL/fireeee_rom_ctrl_sync_reset.v ^
../../../06_FIREEEE_ROM_CTRL/fireeee_rom_ctrl_async_reset.v ^
../../../06_FIREEEE_ROM_CTRL/FIREEEE_ROM_CTRL.v ^
../../ARESETN_SYNC.v

vvp FIREEEE_COEF_ROM.o

gtkwave FIREEEE_COEF_ROM.vcd
