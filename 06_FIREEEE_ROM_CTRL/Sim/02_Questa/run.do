add log -r *

add wave -position insertpoint  \
sim:/FIREEEE_ROM_CTRL_tb/dut/CLK_I \
sim:/FIREEEE_ROM_CTRL_tb/dut/DCLK_POS_DET_I \
sim:/FIREEEE_ROM_CTRL_tb/dut/N_RST_I \
sim:/FIREEEE_ROM_CTRL_tb/dut/RADDR_O

onfinish stop

run -all

coverage report -output FIREEEE_ROM_CTRL_coverage_report.txt -du=FIREEEE_ROM_CTRL -assert -directive -cvg -codeAll
