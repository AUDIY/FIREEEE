add log -r *

atv log -asserts -enable /FIREEEE_COEF_ROM_tb/sva_addr_reset

add wave /FIREEEE_COEF_ROM_tb/sva_addr_reset

add wave -position insertpoint  \
sim:/FIREEEE_COEF_ROM_tb/CLK_I \
sim:/FIREEEE_COEF_ROM_tb/DCLK_EDGE_DET_I \
sim:/FIREEEE_COEF_ROM_tb/RST \
sim:/FIREEEE_COEF_ROM_tb/N_RST_I \
sim:/FIREEEE_COEF_ROM_tb/RADDR_O \
sim:/FIREEEE_COEF_ROM_tb/COEF_O

onfinish stop

run -all

coverage report -output FIREEEE_DATA_RAM_coverage.txt -srcfile=* -detail -annotate -assert -directive -cvg -codeAll