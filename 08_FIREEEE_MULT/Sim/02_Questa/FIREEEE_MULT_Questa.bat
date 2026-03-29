vlib work
vdel -lib work -all
vlib work

vmap work work

vlog ../../ARESETN_SYNC.v
vlog +cover=bcesft ../../fireeee_mult_no_reset.v
vlog +cover=bcesft ../../fireeee_mult_sync_reset.v
vlog +cover=bcesft ../../fireeee_mult_async_reset.v
vlog +cover=bcesft ../../FIREEEE_MULT.v
vlog -sv ../../FIREEEE_MULT_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_MULT_tb -do "do run.do"