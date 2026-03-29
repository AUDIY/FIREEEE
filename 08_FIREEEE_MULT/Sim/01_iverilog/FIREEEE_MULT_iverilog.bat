:@echo off

cd /d %~dp1

del /Q FIREEEE_MULT.o
del /Q FIREEEE_MULT.vcd

iverilog -o FIREEEE_MULT.o -s FIREEEE_MULT_tb ^
-g2012 ../../FIREEEE_MULT_tb.sv ^
../../FIREEEE_MULT.v ^
../../fireeee_mult_no_reset.v ^
../../fireeee_mult_sync_reset.v ^
../../fireeee_mult_async_reset.v ^
../../ARESETN_SYNC.v

vvp FIREEEE_MULT.o

gtkwave FIREEEE_MULT.vcd