add log -r *

add wave -position insertpoint  \
sim:/FIREEEE_MULT_tb/CLK_I \
sim:/FIREEEE_MULT_tb/CLKS_I \
sim:/FIREEEE_MULT_tb/DATA_I \
sim:/FIREEEE_MULT_tb/COEF_I \
sim:/FIREEEE_MULT_tb/RST \
sim:/FIREEEE_MULT_tb/N_RST_I \
sim:/FIREEEE_MULT_tb/CLKS_O \
sim:/FIREEEE_MULT_tb/MULT_O

onfinish stop

run -all

coverage report -output FIREEEE_MULT_coverage.txt -srcfile=* -detail -annotate -assert -directive -cvg -codeAll