vlib work
vdel -lib work -all
vlib work

vmap work work

vlog +cover=bcefst ../../FIREEEE_ROM_CTRL.v
vlog +cover=bcefst ../../fireeee_rom_ctrl_no_reset.v
vlog +cover=bcefst ../../fireeee_rom_ctrl_sync_reset.v
vlog +cover=bcefst ../../fireeee_rom_ctrl_async_reset.v
vlog ../../ARESETN_SYNC.v
vlog +define+SVA=1 -sv ../../FIREEEE_ROM_CTRL_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_ROM_CTRL_tb -do "do run.do"
