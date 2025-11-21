`timescale 1ns/1ps
module top (
    input  logic        clk,
    input  logic        rst,

    input  logic [31:0] s_axil_awaddr,
    input  logic [2:0]  s_axil_awprot,
    input  logic        s_axil_awvalid,
    output logic        s_axil_awready,
    input  logic [31:0] s_axil_wdata,
    input  logic [3:0]  s_axil_wstrb,
    input  logic        s_axil_wvalid,
    output logic        s_axil_wready,
    output logic [1:0]  s_axil_bresp,
    output logic        s_axil_bvalid,
    input  logic        s_axil_bready,

    input  logic [31:0] s_axil_araddr,
    input  logic [2:0]  s_axil_arprot,
    input  logic        s_axil_arvalid,
    output logic        s_axil_arready,
    output logic [31:0] s_axil_rdata,
    output logic [1:0]  s_axil_rresp,
    output logic        s_axil_rvalid,
    input  logic        s_axil_rready
);
    logic [7:0] mem [0:65535];

    // Write (clocked)
    always_ff @(posedge clk) begin
        if (s_axil_awvalid && s_axil_wvalid) begin
            if (s_axil_wstrb[0]) mem[s_axil_awaddr[15:0]  ] <= s_axil_wdata[ 7:0];
            if (s_axil_wstrb[1]) mem[s_axil_awaddr[15:0]+1] <= s_axil_wdata[15:8];
            if (s_axil_wstrb[2]) mem[s_axil_awaddr[15:0]+2] <= s_axil_wdata[23:16];
            if (s_axil_wstrb[3]) mem[s_axil_awaddr[15:0]+3] <= s_axil_wdata[31:24];
        end
    end

    // Read (combinational, low latency)
    assign s_axil_rdata = {mem[s_axil_araddr[15:0]+3],
                           mem[s_axil_araddr[15:0]+2],
                           mem[s_axil_araddr[15:0]+1],
                           mem[s_axil_araddr[15:0]  ]};

    assign s_axil_awready = 1'b1;
    assign s_axil_wready  = 1'b1;
    assign s_axil_bresp   = 2'b00;
    assign s_axil_bvalid  = s_axil_awvalid && s_axil_wvalid;

    assign s_axil_arready = 1'b1;
    assign s_axil_rresp   = 2'b00;
    assign s_axil_rvalid  = s_axil_arvalid;

    initial $display("64KB AXI4-Lite RAM ready");

    /* verilator lint_off WIDTH */
    /* verilator lint_off WIDTHEXPAND */
    /* verilator lint_off LITENDIAN */
    /* verilator lint_on WIDTH */
    /* verilator lint_on WIDTHEXPAND */
    /* verilator lint_on LITENDIAN */
endmodule
