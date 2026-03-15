:@echo off

cd /d %~dp1

del /Q FIREEEE_RAM_CTRL.o
del /Q FIREEEE_RAM_CTRL.vcd

iverilog -o FIREEEE_RAM_CTRL.o -s FIREEEE_RAM_CTRL_tb ^
-g2012 ../../FIREEEE_RAM_CTRL_tb.sv ^
../../ARESETN_SYNC.v ^
../../fireeee_ram_ctrl_no_reset.v ^
../../fireeee_ram_ctrl_sync_reset.v ^
../../fireeee_ram_ctrl_async_reset.v ^
../../FIREEEE_RAM_CTRL.v

vvp FIREEEE_RAM_CTRL.o

gtkwave FIREEEE_RAM_CTRL.vcd
