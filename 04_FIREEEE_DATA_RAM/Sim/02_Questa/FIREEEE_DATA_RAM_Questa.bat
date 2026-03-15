vlib work
vdel -lib work -all
vlib work

vmap work work

vlog ../../ARESETN_SYNC.v
vlog ../../../01_FIREEEE_DCLK_EDGE_DET/fireeee_dclk_edge_det_no_reset.v
vlog ../../../01_FIREEEE_DCLK_EDGE_DET/fireeee_dclk_edge_det_sync_reset.v
vlog ../../../01_FIREEEE_DCLK_EDGE_DET/fireeee_dclk_edge_det_async_reset.v
vlog ../../../01_FIREEEE_DCLK_EDGE_DET/FIREEEE_DCLK_EDGE_DET.v
vlog +cover=bcesft ../../../02_FIREEEE_RAM/SDPRAM_SINGLECLK.v
vlog +cover=bcesft ../../../02_FIREEEE_RAM/FIREEEE_RAM.v
vlog +cover=bcesft ../../../03_FIREEEE_RAM_CTRL/fireeee_ram_ctrl_no_reset.v
vlog +cover=bcesft ../../../03_FIREEEE_RAM_CTRL/fireeee_ram_ctrl_sync_reset.v
vlog +cover=bcesft ../../../03_FIREEEE_RAM_CTRL/fireeee_ram_ctrl_async_reset.v
vlog +cover=bcesft ../../../03_FIREEEE_RAM_CTRL/FIREEEE_RAM_CTRL.v
vlog +cover=bcefst ../../FIREEEE_DATA_RAM.v
vlog -sv ../../FIREEEE_DATA_RAM_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_DATA_RAM_tb -do "do run.do"
