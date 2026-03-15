vlib work
vdel -lib work -all
vlib work

vmap work work

vlog ../../ARESETN_SYNC.v
vlog +cover=bcesft ../../fireeee_ram_ctrl_no_reset.v
vlog +cover=bcesft ../../fireeee_ram_ctrl_sync_reset.v
vlog +cover=bcesft ../../fireeee_ram_ctrl_async_reset.v
vlog +cover=bcefst ../../FIREEEE_RAM_CTRL.v
vlog +define+SVA=1 -sv ../../FIREEEE_RAM_CTRL_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_RAM_CTRL_tb -do "do run.do"
