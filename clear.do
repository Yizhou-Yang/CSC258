# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns clear.v

# Load simulation using mux as the top level simulation module.
vsim clearCards
# vsim datapath

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values usingthe force command, signal names need to be in {} brackets.
force {reset_n} 0 0, 1 1
run 2ns
force {in} 1 50
force {x0} 0
force {y0} 0
force {clk} 1 0, 0 1 -r 2
run 5000ns 