add log -r *

atv log -asserts -enable /FIREEEE_ROM_CTRL_tb/sva_raddr_start
atv log -asserts -enable /FIREEEE_ROM_CTRL_tb/sva_raddr_incr

add wave /FIREEEE_ROM_CTRL_tb/sva_raddr_start \
/FIREEEE_ROM_CTRL_tb/sva_raddr_incr

add wave -position insertpoint  \
sim:/FIREEEE_ROM_CTRL_tb/CLK_I \
sim:/FIREEEE_ROM_CTRL_tb/DCLK_EDGE_DET_I \
sim:/FIREEEE_ROM_CTRL_tb/N_RST_I \
sim:/FIREEEE_ROM_CTRL_tb/RADDR_O

onfinish stop

run -all

coverage report -output FIREEEE_ROM_CTRL_coverage.txt -srcfile=* -detail -annotate -assert -directive -cvg -codeAll
