import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def basic_test(dut):
    cocotb.start_soon(Clock(dut.clk, 10, "ns").start())
    dut.rst.value = 1
    await RisingEdge(dut.clk); await RisingEdge(dut.clk)
    dut.rst.value = 0

    # Write
    dut.s_axil_awaddr.value = 0x8000
    dut.s_axil_awvalid.value = 1
    dut.s_axil_wdata.value = 0xDEADBEEF
    dut.s_axil_wstrb.value = 0xF
    dut.s_axil_wvalid.value = 1
    await RisingEdge(dut.clk)  # Write happens on this edge
    dut.s_axil_awvalid.value = 0  # Deassert after transfer
    dut.s_axil_wvalid.value = 0
    await RisingEdge(dut.clk)  # Extra cycle to ensure update

    # Read
    dut.s_axil_araddr.value = 0x8000
    dut.s_axil_arvalid.value = 1
    await RisingEdge(dut.clk)  # Read data available after this edge (combo now)
    assert dut.s_axil_rvalid.value == 1, "rvalid not high!"
    assert int(dut.s_axil_rdata.value) == 0xDEADBEEF, f"Got {hex(int(dut.s_axil_rdata.value))}"
    dut.s_axil_arvalid.value = 0  # Deassert
    dut._log.info("Basic read/write PASSED!")