add log -r *

add wave -position insertpoint  \
sim:/FIREEEE_DCLK_EDGE_DET_tb/dut/CLK_I \
sim:/FIREEEE_DCLK_EDGE_DET_tb/dut/DCLK_I \
sim:/FIREEEE_DCLK_EDGE_DET_tb/dut/DATA_I \
sim:/FIREEEE_DCLK_EDGE_DET_tb/dut/N_RST_I \
sim:/FIREEEE_DCLK_EDGE_DET_tb/dut/DCLK_O \
sim:/FIREEEE_DCLK_EDGE_DET_tb/dut/DATA_O \
sim:/FIREEEE_DCLK_EDGE_DET_tb/dut/POS_DET_O \
sim:/FIREEEE_DCLK_EDGE_DET_tb/dut/NEG_DET_O

onfinish stop

run -all

coverage report -output FIREEEE_DCLK_EDGE_DET_coverage_report.txt -du=FIREEEE_DCLK_EDGE_DET -assert -directive -cvg -codeAll
