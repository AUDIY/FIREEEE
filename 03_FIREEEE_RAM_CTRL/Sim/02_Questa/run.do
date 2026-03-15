add log -r *

atv log -asserts -enable /FIREEEE_RAM_CTRL_tb/sva_wen_1cycle
atv log -asserts -enable /FIREEEE_RAM_CTRL_tb/sva_addr_neq
atv log -asserts -enable /FIREEEE_RAM_CTRL_tb/sva_ren_disable
atv log -asserts -enable /FIREEEE_RAM_CTRL_tb/sva_addr_eq_start

add wave /FIREEEE_RAM_CTRL_tb/sva_wen_1cycle \
/FIREEEE_RAM_CTRL_tb/sva_addr_neq \
/FIREEEE_RAM_CTRL_tb/sva_ren_disable \
/FIREEEE_RAM_CTRL_tb/sva_addr_eq_start

add wave -position insertpoint  \
sim:/FIREEEE_RAM_CTRL_tb/CLK_I \
sim:/FIREEEE_RAM_CTRL_tb/WEN_I \
sim:/FIREEEE_RAM_CTRL_tb/N_RST_I \
sim:/FIREEEE_RAM_CTRL_tb/WADDR_O \
sim:/FIREEEE_RAM_CTRL_tb/REN_O \
sim:/FIREEEE_RAM_CTRL_tb/RADDR_O

onfinish stop

run -all

coverage report -output FIREEEE_RAM_CTRL_coverage.txt -srcfile=* -detail -annotate -assert -directive -cvg -codeAll
