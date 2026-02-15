add log -r *

add wave -position insertpoint  \
sim:/FIREEEE_ROM_tb/dut/CLK_I \
sim:/FIREEEE_ROM_tb/dut/RADDR_I \
sim:/FIREEEE_ROM_tb/dut/RDATA_O

onfinish stop

run -all

coverage report -output FIREEEE_ROM_coverage_report.txt -du=FIREEEE_ROM -assert -directive -cvg -codeAll
