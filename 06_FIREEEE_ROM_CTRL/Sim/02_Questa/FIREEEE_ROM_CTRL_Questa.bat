vlib work
vdel -lib work -all
vlib work

vmap work work

vlog +cover=bcefst ../../FIREEEE_ROM_CTRL.v
vlog -sv ../../FIREEEE_ROM_CTRL_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_ROM_CTRL_tb -do "do run.do"
