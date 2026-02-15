add log -r *

add wave -position insertpoint  \
sim:/FIREEEE_RAM_tb/dut/CLK_I \
sim:/FIREEEE_RAM_tb/dut/WEN_I \
sim:/FIREEEE_RAM_tb/dut/WADDR_I \
sim:/FIREEEE_RAM_tb/dut/WDATA_I \
sim:/FIREEEE_RAM_tb/dut/REN_I \
sim:/FIREEEE_RAM_tb/dut/RADDR_I \
sim:/FIREEEE_RAM_tb/dut/RDATA_O

onfinish stop

run -all

coverage report -output FIREEEE_RAM_coverage_report.txt -du=FIREEEE_RAM -assert -directive -cvg -codeAll
