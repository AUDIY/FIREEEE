vlib work
vdel -lib work -all
vlib work

vmap work work

vlog +cover=bcseft ../../FIREEEE_DCLK_EDGE_DET.v
vlog -sv ../../FIREEEE_DCLK_EDGE_DET_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_DCLK_EDGE_DET_tb -do "do run.do"
