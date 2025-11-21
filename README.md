# axi-cocotab
Cocotb + Verilator AXI4-Lite Verification
This is a compact, open-source verification environment for an AXI4-Lite RAM module, built using Cocotb and Verilator. It was created as a weekend project to explore HRT-style open-source DV flows for low-latency FPGA/ASIC designs in trading systems.

Features

RTL: Simple 64KB AXI4-Lite RAM with combinational read (zero-latency) and clocked write.

Tests:
Basic read/write test.
1000 randomized transactions with automatic scoreboard (aligned 32-bit accesses).

Stack: Pure Cocotb + Verilator (no commercial tools, zero dependencies beyond Python libs).
Performance: Runs full suite in ~0.4 seconds on a 2-core machine with 100% pass rate.
Coverage: Achieves 100% functional coverage for basic operations (extendable with cocotb-coverage).