add wave -position end  sim:/main/Clk
add wave -position end  sim:/main/Rst
force -freeze sim:/main/Clk 1 0, 0 {25 ns} -r 50
add wave -position end  sim:/main/BUS_DATA
noforce sim:/main/BUS_DATA
add wave -position end  sim:/main/EXE
add wave -position end  sim:/main/TO_RAM
add wave -position end  sim:/main/mar_out
add wave -position end  sim:/main/mdr_out
add wave -position end  sim:/main/mem_to_mdr
force -freeze sim:/main/Rst 1 0
run
force -freeze sim:/main/Rst 0 0
run
force -freeze sim:/main/mdr_out 16'hf051 0
force -freeze sim:/main/mar_out 16'h0000 0
force -freeze sim:/main/TO_RAM 1 0
force -freeze sim:/main/EXE 24'h000000 0
run
force -freeze sim:/main/mar_out 16'h0001 0
force -freeze sim:/main/TO_RAM 0 0
noforce sim:/main/mdr_out
force -freeze sim:/main/EXE(21) 1 0
run
force -freeze sim:/main/TO_RAM 1 0
force -freeze sim:/main/EXE(21) 0 0
run
force -freeze sim:/main/TO_RAM 0 0
force -freeze sim:/main/EXE(21) 1 0
force -freeze sim:/main/mar_out 16'h0000 0
run