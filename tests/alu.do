add wave -position end  sim:/alu/operationControl
add wave -position end  sim:/alu/A
add wave -position end  sim:/alu/B
add wave -position end  sim:/alu/F
add wave -position end  sim:/alu/flagIn
add wave -position end  sim:/alu/flagOut
add wave -position end  sim:/alu/sigA
add wave -position end  sim:/alu/sigB
add wave -position end  sim:/alu/sigF
add wave -position end  sim:/alu/subTowsCompB
add wave -position end  sim:/alu/sbcResult
add wave -position end  sim:/alu/carryTwosComp
add wave -position end  sim:/alu/carryIn
add wave -position end  sim:/alu/carryOut
add wave -position end  sim:/alu/sbcCarryOut
add wave -position end  sim:/alu/FTemp
force -freeze sim:/alu/operationControl 5'h00 0
force -freeze sim:/alu/A 16'h0003 0
force -freeze sim:/alu/B 16'h0002 0
force -freeze sim:/alu/flagIn 5'h00 
run
force -freeze sim:/alu/operationControl 5'h02 0
run
force -freeze sim:/alu/operationControl 5'h03 0
force -freeze sim:/alu/A 16'hFFFF 0
force -freeze sim:/alu/flagIn 16'h01 0
run
force -freeze sim:/alu/operationControl 5'h04 0
force -freeze sim:/alu/A 16'h0005 0
force -freeze sim:/alu/B 16'hFFFF 0
force -freeze sim:/alu/flagIn 16'h01 0
run
force -freeze sim:/alu/operationControl 5'h08 0
run
force -freeze sim:/alu/operationControl 5'h09 0
run