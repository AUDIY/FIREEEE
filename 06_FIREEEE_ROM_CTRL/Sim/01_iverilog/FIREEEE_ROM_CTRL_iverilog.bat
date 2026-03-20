:@echo off

cd /d %~dp1

del /Q FIREEEE_ROM_CTRL.o
del /Q FIREEEE_ROM_CTRL.vcd

iverilog -o FIREEEE_ROM_CTRL.o -s FIREEEE_ROM_CTRL_tb ^
-g2012 ../../FIREEEE_ROM_CTRL_tb.sv ^
../../ARESETN_SYNC.v ^
../../fireeee_rom_ctrl_no_reset.v ^
../../fireeee_rom_ctrl_sync_reset.v ^
../../fireeee_rom_ctrl_async_reset.v ^
../../FIREEEE_ROM_CTRL.v

vvp FIREEEE_ROM_CTRL.o

gtkwave FIREEEE_ROM_CTRL.vcd
