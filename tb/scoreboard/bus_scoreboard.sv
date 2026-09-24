// Receives completed transactions from the bus monitor.
// Maintains an associative-array reference memory updated by writes.
// Compares returned read data against expected memory values.
// Tracks passing, failing, and unknown read comparisons and
// reports verification results at the end of simulation.

class bus_scoreboard extends uvm_scoreboard;

    // factory registration
    `uvm_component_utils(bus_scoreboard)

    // variable declaration 
    uvm_analysis_imp #(bus_item, bus_scoreboard) imp; 
    logic [31:0]    expected_mem[bit [7:0]];
    int unsigned pass_count = 0; 
    int unsigned fail_count = 0; 
    int unsigned unknown_count = 0; 

    // constructor
    function new (string name = "bus_scoreboard",uvm_component parent = null);
        super.new(name, parent); 
        imp = new ("imp", this);
    endfunction 

    // 
    function void write (bus_item tr);
        
        // Write transactions 
        if (tr.wr_en == 1'b1) begin 
            expected_mem[tr.addr] = tr.wr_data; 
        end  
        else begin
            // Read Transactions
            if (expected_mem.exists(tr.addr)) begin 
                if (expected_mem[tr.addr] !== tr.rd_data) begin 
                    `uvm_error("BUS_SB",$sformatf("Mismatch: addr:%0h, exp:%0h act:%0h",tr.addr, expected_mem[tr.addr],tr.rd_data))
                    fail_count = fail_count + 1; 
                end
                else begin 
                    `uvm_info("BUS_SB",$sformatf("Match: addr:%0h, exp:%0h act:%0h",tr.addr,expected_mem[tr.addr],tr.rd_data),UVM_DEBUG)
                    pass_count = pass_count + 1; 
                end
            end 
            else begin
                `uvm_warning("BUS_SB",$sformatf("Read from unwritten address: addr:%0h, exp:NONE act:%0h",tr.addr,tr.rd_data))
                unknown_count = unknown_count + 1; 
            end 
        end 
    endfunction 

    // report_phase 
    function void report_phase(uvm_phase phase);
        super.report_phase(phase); 

        `uvm_info("BUS_SB",$sformatf("pass: %0d",pass_count),UVM_LOW)
        `uvm_info("BUS_SB",$sformatf("fail: %0d",fail_count),UVM_LOW)
        `uvm_info("BUS_SB",$sformatf("unknown: %0d",unknown_count),UVM_LOW)
        `uvm_info("BUS_SB",$sformatf("total: %0d",pass + fail + unknown_count),UVM_LOW)
    endfunction



endclass 