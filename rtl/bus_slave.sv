// 64-word, 32-bit memory slave with an 8-bit byte-addressed interface.
// Supports read and write transactions using a valid/ready handshake.
// Performs synchronous writes and provides combinational read data.
// Implements active-low asynchronous reset and clears memory on reset.

// Module declaration 
module bus_slave (
    input logic             clk,
    input logic             rst_n, 
    input logic [7:0]       addr, 
    input logic [31:0]      wr_data,
    input logic             wr_en,
    input logic             valid, 

    output logic [31:0]     rd_data,
    output logic            ready
);

    // DUT's 64-word memory array, with each word 32 bits wide
    localparam int MEM_SIZE = 64;  
    logic [31:0] mem[MEM_SIZE];

    // reset 
    always_ff @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i=0; i<MEM_SIZE; i++) begin
                mem[i] <= 32'b0; 
            end
        end 
        else begin
            if (valid && ready && wr_en) begin 
                mem[addr[7:2]] <= wr_data;
            end 
        end
    end 

    assign ready = rst_n;

    assign rd_data = (rst_n && valid && !wr_en) 
                            ? mem[addr[7:2]] 
                            : 32'h0; 

endmodule 