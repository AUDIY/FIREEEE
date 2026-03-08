add log -r *

atv log -asserts -enable /FIREEEE_DCLK_EDGE_DET_tb/sva_pos_neg_nand1
atv log -asserts -enable /FIREEEE_DCLK_EDGE_DET_tb/sva_pos_neg_nand2
atv log -asserts -enable /FIREEEE_DCLK_EDGE_DET_tb/sva_pos_1cycle
atv log -asserts -enable /FIREEEE_DCLK_EDGE_DET_tb/sva_neg_1cycle
atv log -asserts -enable /FIREEEE_DCLK_EDGE_DET_tb/sva_dclk_pos
atv log -asserts -enable /FIREEEE_DCLK_EDGE_DET_tb/sva_dclk_neg

add wave /FIREEEE_DCLK_EDGE_DET_tb/sva_pos_neg_nand1 \
/FIREEEE_DCLK_EDGE_DET_tb/sva_pos_neg_nand2 \
/FIREEEE_DCLK_EDGE_DET_tb/sva_pos_1cycle \
/FIREEEE_DCLK_EDGE_DET_tb/sva_neg_1cycle \
/FIREEEE_DCLK_EDGE_DET_tb/sva_dclk_pos \
/FIREEEE_DCLK_EDGE_DET_tb/sva_dclk_neg

add wave -position insertpoint  \
sim:/FIREEEE_DCLK_EDGE_DET_tb/CLK_I \
sim:/FIREEEE_DCLK_EDGE_DET_tb/DCLK_I \
sim:/FIREEEE_DCLK_EDGE_DET_tb/DATA_I \
sim:/FIREEEE_DCLK_EDGE_DET_tb/N_RST_I \
sim:/FIREEEE_DCLK_EDGE_DET_tb/DCLK_O \
sim:/FIREEEE_DCLK_EDGE_DET_tb/DATA_O \
sim:/FIREEEE_DCLK_EDGE_DET_tb/POS_DET_O \
sim:/FIREEEE_DCLK_EDGE_DET_tb/NEG_DET_O

onfinish stop

run -all

coverage report -output FIREEEE_DCLK_EDGE_DET_coverage_report.txt -srcfile=* -assert -directive -cvg -codeAll
