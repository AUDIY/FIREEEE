add log -r *

add wave -position insertpoint  \
sim:/FIREEEE_DATA_RAM_tb/dut/CLK_I \
sim:/FIREEEE_DATA_RAM_tb/dut/WEN_I \
sim:/FIREEEE_DATA_RAM_tb/dut/WDATA_I \
sim:/FIREEEE_DATA_RAM_tb/dut/N_RST_I \
sim:/FIREEEE_DATA_RAM_tb/dut/RDATA_O

onfinish stop

run -all

coverage report -output FIREEEE_DATA_RAM_coverage_report.txt -du=FIREEEE_DATA_RAM -assert -directive -cvg -codeAll
