add log -r *

add wave -position insertpoint  \
sim:/FIREEEE_ACCUM_tb/CLK_I \
sim:/FIREEEE_ACCUM_tb/DCLK_EDGE_DET_I \
sim:/FIREEEE_ACCUM_tb/CLKS_I \
sim:/FIREEEE_ACCUM_tb/MULT_I \
sim:/FIREEEE_ACCUM_tb/N_RST_I \
sim:/FIREEEE_ACCUM_tb/CLKS_O \
sim:/FIREEEE_ACCUM_tb/ACCUM_O

onfinish stop

run -all

coverage report -output FIREEEE_ACCUM_coverage.txt -srcfile=* -detail -annotate -assert -directive -cvg -codeAll