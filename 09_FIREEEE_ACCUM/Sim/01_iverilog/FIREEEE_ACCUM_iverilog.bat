:@echo off

cd /d %~dp1

del /Q FIREEEE_ACCUM.o
del /Q FIREEEE_ACCUM.vcd

iverilog -o FIREEEE_ACCUM.o -s FIREEEE_ACCUM_tb ^
-g2012 ../../FIREEEE_ACCUM_tb.sv ^
../../FIREEEE_ACCUM.v ^
../../fireeee_accum_no_reset.v ^
../../fireeee_accum_sync_reset.v ^
../../fireeee_accum_async_reset.v ^
../../ARESETN_SYNC.v

vvp FIREEEE_ACCUM.o

gtkwave FIREEEE_ACCUM.vcd