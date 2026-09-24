// Defines the signals connecting the DUT and UVM testbench.
// Provides master, slave, and monitor modports with clocking blocks.
// Clocking blocks define signal sampling and driving timing relative
// to the clock edge, reducing race conditions between DUT and testbench.

interface bus_if (input logic clk, input logic rst_n); 

    logic [7:0] addr; 
    logic [31:0] wr_data;
    logic [31:0] rd_data; 
    logic wr_en; 
    logic valid; 
    logic ready; 

    modport master (
        input rst_n,
        clocking master_cb
     );

    modport slave (
        input rst_n,
        clocking slave_cb 
    );

    modport monitor (
        input rst_n,
        clocking mon_cb
     );

     clocking master_cb @ (posedge clk);
        default input #1step output #0; 
        output  addr; 
        output  wr_data;
        input   rd_data; 
        output  wr_en;
        output  valid; 
        input   ready;
     endclocking 

    clocking mon_cb @ (posedge clk);
        default input #1step;
        input addr; 
        input wr_data;
        input rd_data; 
        input wr_en; 
        input valid; 
        input ready;
     endclocking 


     clocking slave_cb @ (posedge clk);
        default input #1step output #0; 
        input  addr; 
        input  wr_data;
        output   rd_data; 
        input  wr_en;
        input  valid; 
        output   ready;
     endclocking 

endinterface 