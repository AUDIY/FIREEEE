add log -r *

add wave -position insertpoint  \
sim:/FIREEEE_DATA_RAM_tb/CLK_I \
sim:/FIREEEE_DATA_RAM_tb/WEN \
sim:/FIREEEE_DATA_RAM_tb/WDATA \
sim:/FIREEEE_DATA_RAM_tb/N_RST_I \
sim:/FIREEEE_DATA_RAM_tb/RDATA_O

onfinish stop

run -all

coverage report -output FIREEEE_DATA_RAM_coverage.txt -srcfile=* -detail -annotate -assert -directive -cvg -codeAll
