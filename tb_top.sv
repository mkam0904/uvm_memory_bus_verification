// Generates the clock and reset signals.
// Instantiates the bus interface and memory-slave DUT.
// Connects DUT ports to the interface signals.
// Configures the UVM driver and monitor virtual interfaces and
// launches the UVM test using run_test().

import uvm_pkg::*; 
import bus_tb_pkg::*; 

module tb_top; 

    timeunit 1ns; 
    timeprecision 1ps; 

    logic clk = 0; 
    logic rst_n = 0; 

    // Clock: 10ns period 
    always #5 clk = ~clk;  

    // Reset: 
    initial begin 
        rst_n = 1'b0; 
        #20;  
        rst_n = 1'b1; 
    end 

    // Instantiate the interface 
    bus_if      bus_vif(
                    .clk(clk), 
                    .rst_n(rst_n)
                ); 
    bus_slave dut(
                .clk(clk),
                .rst_n(rst_n),
                .addr(bus_vif.addr),
                .wr_data(bus_vif.wr_data),
                .wr_en(bus_vif.wr_en),
                .valid(bus_vif.valid),
                .rd_data(bus_vif.rd_data),
                .ready(bus_vif.ready)
                ); 

    // 
    initial begin 
        uvm_config_db#(virtual bus_if.master)::set(null,"uvm_test_top.env.agent.bus_drv","vif",bus_vif);
        uvm_config_db#(virtual bus_if.monitor)::set(null,"uvm_test_top.env.agent.bus_mon","vif",bus_vif); 
        run_test("bus_test");
    end 

endmodule 