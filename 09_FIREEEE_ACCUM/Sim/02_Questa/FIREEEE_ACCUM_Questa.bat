vlib work
vdel -lib work -all
vlib work

vmap work work

vlog ../../ARESETN_SYNC.v
vlog +cover=bcesft ../../fireeee_accum_no_reset.v
vlog +cover=bcesft ../../fireeee_accum_sync_reset.v
vlog +cover=bcesft ../../fireeee_accum_async_reset.v
vlog +cover=bcesft ../../FIREEEE_ACCUM.v
vlog -sv ../../FIREEEE_ACCUM_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_ACCUM_tb -do "do run.do"