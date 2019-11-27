vlib work
vlog -timescale 1ns/1ns *.v
vsim datapathControl
log {/*}
add wave {/*}

force {reset_n} 1
run 1ns
force {reset_n} 0
run 1ns
force {reset_n} 1
force {selectdone} 1
run 5ns
force {in} 1
force {selections} 000000001
force {clk} 0 0, 1 1 -r 2
run 6000ns
force {selectdone} 0
run 1ns
force {clk} 0 0, 1 1 -r 2
run 50ns
force {selectdone} 1
run 1ns
force {selectdone} 0
run 1ns
force {clk} 0
run 1ns
force {clk} 1
run 1ns
force {selections} 000000010
run 1ns
force {clk} 0 0, 1 1 -r 2
run 50ns
force {selectdone} 1
run 1ns
force {selectdone} 0
run 1ns
force {clk} 0
run 1ns
force {clk} 1
run 1ns
force {selections} 000001000
run 1ns
force {clk} 0 0, 1 1 -r 2
run 100ns
force {selectdone} 1
run 1ns
force {selectdone} 0
run 1ns
force {clk} 0
run 1ns
force {clk} 1
run 1ns
force {selections} 100000000
run 1ns
force {clk} 0 0, 1 1 -r 2
run 50ns
force {selectdone} 1
run 1ns
force {selectdone} 0
run 1ns
force {clk} 0 0, 1 1 -r 2
run 50ns
force {selectdone} 1
run 1ns
force {selectdone} 0
run 1ns
force {clk} 0 0, 1 1 -r 2
run 50ns
force {clk} 0 0, 1 1 -r 2
run 100ns
force {selectdone} 1
run 1ns
force {selectdone} 0
run 1ns
force {clk} 0 0, 1 1 -r 2
run 50ns
force {selectdone} 1
run 1ns
force {selectdone} 0
run 1ns
force {clk} 0 0, 1 1 -r 2
run 50ns
force {selectdone} 1
run 1ns
force {selectdone} 0
run 1ns
force {clk} 0 0, 1 1 -r 2
run 50ns
force {clk} 0 0, 1 1 -r 2
run 100ns
