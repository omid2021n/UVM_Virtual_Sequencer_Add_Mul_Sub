This project demonstrates a UVM testbench implementation using a virtual sequencer to coordinate multiple sequence items targeting three arithmetic modules: Adder (ADD), Multiplier (MUL), and Subtractor (SUB).

Project Overview
Implements three DUT modules: ADD, MUL, and SUB — each performing their respective arithmetic operations.

Uses separate UVM agents and sequences for each module.

Coordinates all sequences with a virtual sequencer to enable parallel and synchronized stimulus generation.

Interfaces are used to connect the testbench with DUT signals cleanly.

Provides examples of sequences, drivers, monitors, and scoreboard integration.

Suitable as a learning reference for UVM users who want to understand multi-agent coordination.

Features
Virtual Sequencer: Centralized control of multiple sequences running on different agents.

UVM Sequences: Separate sequences for ADD, MUL, and SUB with randomized inputs.

Agents and Drivers: Dedicated UVM agents for each module.

Scoreboarding: Basic result checking for functional correctness.

Interface-based DUT connections: Modular and reusable testbench structure.

Reset and Clock Control: Synchronized reset and clock for all modules.

# KERNEL: ASDB file was created in location /home/runner/dataset.asdb
# KERNEL: UVM_INFO @ 0: reporter [RNTST] Running test test...
# KERNEL: UVM_INFO /home/runner/testbench.sv(764) @ 0: uvm_test_top [TEST] Starting ADD Generator
# KERNEL: UVM_INFO /home/runner/testbench.sv(67) @ 0: uvm_test_top.env.aa.d [ADD_DRV]  add_in1:11 add_in2:12 
# KERNEL: UVM_INFO /home/runner/testbench.sv(770) @ 20: uvm_test_top [TEST] Starting MUL Generator
# KERNEL: UVM_INFO /home/runner/testbench.sv(776) @ 20: uvm_test_top [TEST] Starting SUB Generator
# KERNEL: UVM_INFO /home/runner/testbench.sv(230) @ 20: uvm_test_top.env.ma.d [MUL_DRV]  mul_in1:9 mul_in2:3 
# KERNEL: UVM_INFO /home/runner/testbench.sv(386) @ 20: uvm_test_top.env.sa.d [SUB_DRV]  sub_in1:8 sub_in2:7 
# KERNEL: UVM_INFO /home/runner/testbench.sv(537) @ 50: uvm_test_top.env.s [ADD_SCO] TEST PASSED : AOUT:23 AIN1:11 AIN2:12
# KERNEL: =======================================================
# KERNEL: UVM_INFO /home/runner/testbench.sv(521) @ 50: uvm_test_top.env.s [MUL_SCO] TEST PASSED : MOUT:27 MIN1:9 MIN2:3
# KERNEL: =======================================================
# KERNEL: UVM_INFO /home/runner/testbench.sv(555) @ 50: uvm_test_top.env.s [SUB_SCO] TEST PASSED : SOUT:1 SIN1:8 SIN2:7
# KERNEL: =======================================================
# KERNEL: UVM_INFO /home/runner/testbench.sv(67) @ 50: uvm_test_top.env.aa.d [ADD_DRV]  add_in1:12 add_in2:9 
# KERNEL: UVM_INFO /home/runner/testbench.sv(230) @ 70: uvm_test_top.env.ma.d [MUL_DRV]  mul_in1:10 mul_in2:0 
# KERNEL: UVM_INFO /home/runner/testbench.sv(386) @ 70: uvm_test_top.env.sa.d [SUB_DRV]  sub_in1:9 sub_in2:4 
# KERNEL: UVM_INFO /home/runner/testbench.sv(537) @ 110: uvm_test_top.env.s [ADD_SCO] TEST PASSED : AOUT:21 AIN1:12 AIN2:9
# KERNEL: =======================================================
# KERNEL: UVM_INFO /home/runner/testbench.sv(521) @ 110: uvm_test_top.env.s [MUL_SCO] TEST PASSED : MOUT:0 MIN1:10 MIN2:0
# KERNEL: =======================================================
# KERNEL: UVM_INFO /home/runner/testbench.sv(555) @ 110: uvm_test_top.env.s [SUB_SCO] TEST PASSED : SOUT:5 SIN1:9 SIN2:4
