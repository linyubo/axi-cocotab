import cocotb, random
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def random_test(dut):
    cocotb.start_soon(Clock(dut.clk, 10, "ns").start())
    dut.rst.value = 1
    await RisingEdge(dut.clk); await RisingEdge(dut.clk)
    dut.rst.value = 0

    for _ in range(1000):
        addr = random.randrange(0, 65536, 4)
        data = random.getrandbits(32)

        # Write
        dut.s_axil_awaddr.value = addr
        dut.s_axil_awvalid.value = 1
        dut.s_axil_wdata.value = data
        dut.s_axil_wstrb.value = 0xF
        dut.s_axil_wvalid.value = 1
        await RisingEdge(dut.clk)
        dut.s_axil_awvalid.value = 0
        dut.s_axil_wvalid.value = 0
        await RisingEdge(dut.clk)  # Extra cycle

        # Read
        dut.s_axil_araddr.value = addr
        dut.s_axil_arvalid.value = 1
        await RisingEdge(dut.clk)
        assert dut.s_axil_rvalid.value == 1, "rvalid not high!"
        assert int(dut.s_axil_rdata.value) == data, f"Got {hex(int(dut.s_axil_rdata.value))}"
        dut.s_axil_arvalid.value = 0

    dut._log.info("1000 random transactions ALL PASSED!")
