vlib work
vdel -lib work -all
vlib work

vmap work work

vlog ../../ARESETN_SYNC.v
vlog +cover=bcseft ../../fireeee_dclk_edge_det_no_reset.v
vlog +cover=bcseft ../../fireeee_dclk_edge_det_sync_reset.v
vlog +cover=bcseft ../../fireeee_dclk_edge_det_async_reset.v
vlog +cover=bcseft ../../FIREEEE_DCLK_EDGE_DET.v
vlog +define+SVA=1 -sv ../../FIREEEE_DCLK_EDGE_DET_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_DCLK_EDGE_DET_tb -do "do run.do"
