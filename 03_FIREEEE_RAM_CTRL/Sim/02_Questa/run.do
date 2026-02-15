add log -r *

add wave -position insertpoint  \
sim:/FIREEEE_RAM_CTRL_tb/dut/CLK_I \
sim:/FIREEEE_RAM_CTRL_tb/dut/WEN_I \
sim:/FIREEEE_RAM_CTRL_tb/dut/N_RST_I \
sim:/FIREEEE_RAM_CTRL_tb/dut/WADDR_O \
sim:/FIREEEE_RAM_CTRL_tb/dut/REN_O \
sim:/FIREEEE_RAM_CTRL_tb/dut/RADDR_O

onfinish stop

run -all

coverage report -output FIREEEE_RAM_CTRL_coverage_report.txt -du=FIREEEE_RAM_CTRL -assert -directive -cvg -codeAll
