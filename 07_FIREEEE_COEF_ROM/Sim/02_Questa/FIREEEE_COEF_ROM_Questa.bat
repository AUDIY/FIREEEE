vlib work
vdel -lib work -all
vlib work

vmap work work

vlog ../../ARESETN_SYNC.v
vlog +cover=bcesft ../../../05_FIREEEE_ROM/SPROM.v
vlog +cover=bcesft ../../../05_FIREEEE_ROM/FIREEEE_ROM.v
vlog +cover=bcesft ../../../06_FIREEEE_ROM_CTRL/fireeee_rom_ctrl_no_reset.v
vlog +cover=bcesft ../../../06_FIREEEE_ROM_CTRL/fireeee_rom_ctrl_sync_reset.v
vlog +cover=bcesft ../../../06_FIREEEE_ROM_CTRL/fireeee_rom_ctrl_async_reset.v
vlog +cover=bcesft ../../../06_FIREEEE_ROM_CTRL/FIREEEE_ROM_CTRL.v
vlog +cover=bcefst ../../FIREEEE_COEF_ROM.v
vlog +define+SVA=1 -sv ../../FIREEEE_COEF_ROM_tb.sv

vsim -t ns -coverage -voptargs=+acc -debugdb=+acc -assertdebug work.FIREEEE_COEF_ROM_tb -do "do run.do"