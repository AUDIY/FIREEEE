vlib work
vdel -lib work -all
vlib work

vmap work work

vlog ../../../01_FIREEEE_DCLK_EDGE_DET/FIREEEE_DCLK_EDGE_DET.v
vlog ../../../02_FIREEEE_RAM/SDPRAM_SINGLECLK.v
vlog ../../../02_FIREEEE_RAM/FIREEEE_RAM.v
vlog ../../../03_FIREEEE_RAM_CTRL/FIREEEE_RAM_CTRL.v
vlog +cover=bcefst ../../FIREEEE_DATA_RAM.v
vlog -sv ../../FIREEEE_DATA_RAM_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_DATA_RAM_tb -do "do run.do"
