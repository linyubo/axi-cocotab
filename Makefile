TOPLEVEL      = top
MODULE        = test_basic,test_random
VERILOG_SOURCES = $(PWD)/top.sv
SIM           = verilator
EXTRA_ARGS   += --trace --trace-structs -Wno-fatal -Wno-WIDTH -Wno-WIDTHEXPAND -Wno-LITENDIAN

include $(shell cocotb-config --makefiles)/Makefile.sim
