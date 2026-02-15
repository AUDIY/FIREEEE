vlib work
vdel -lib work -all
vlib work

vmap work work

vlog ../../SDPRAM_SINGLECLK.v
vlog +cover=bcefst ../../FIREEEE_RAM.v
vlog -sv ../../FIREEEE_RAM_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_RAM_tb -do "do run.do"