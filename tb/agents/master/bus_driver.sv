// Converts bus_item requests from the sequencer into bus signal
// activity using the master clocking block and valid/ready handshake.
// Captures read data, handles transaction aborts caused by reset,
// and returns response objects to the requesting sequence.

class bus_driver extends uvm_driver #(bus_item);

    // factory registration 
    `uvm_component_utils(bus_driver)

    // variable declaration 
    bus_item    req; 
    bus_item    rsp; 
    virtual bus_if.master   vif; 

    // constructor 
    function new (string name = "bus_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    //
    task drive_bus(bus_item req);
    
        req.aborted = 1'b0; 

        // Synchronize to the next clocking block event (posedge clk)
        @ vif.master_cb;
        
        if (vif.rst_n == 1'b1) begin 
            vif.master_cb.addr      <= req.addr;            
            vif.master_cb.wr_data   <= req.wr_data;
            vif.master_cb.wr_en     <= req.wr_en;
            vif.master_cb.valid     <= 1'b1;
            
            // Wait for transaction completion or asynchronous reset 
            fork
                // Branch 1: Wait for the ready handshake
                begin 
                    do begin
                        @vif.master_cb; 
                    end while (!vif.master_cb.ready);
                end
                // Branch 2: Detect asynchronous reset
                begin
                    wait(!vif.rst_n);
                    req.aborted = 1'b1;
                    `uvm_warning("DRV", "Transaction aborted due to reset")
                end 
            join_any 
            // Terminate the remaining branch
            disable fork;

            // Reset takes priority over transaction completion
            if (!vif.rst_n) begin
                req.aborted = 1'b1;
                `uvm_warning("DRV", "Transaction aborted due to reset")
            end

            // Deassert the valid 
            vif.master_cb.valid <= 1'b0; 

            // Capture read data only after a successful transaction
            if (!req.aborted && !req.wr_en) begin 
                req.rd_data = vif.master_cb.rd_data;
            end 
        end
        else begin 
            vif.master_cb.valid <= 1'b0;
            req.aborted = 1'b1;
            `uvm_warning("DRV", "Transaction aborted due to reset")
        end 

    endtask 

    // build_phase 
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if (!(uvm_config_db#(virtual bus_if.master)::get(this,"","vif",vif)))
            `uvm_fatal("DRV","virtual interface not found") 
    endfunction

    // run_phase 
    task run_phase(uvm_phase phase);
        vif.master_cb.valid     <= 1'b0;
        forever begin
            wait(vif.rst_n); 

            seq_item_port.get_next_item(req);
            drive_bus(req);
            
            rsp = bus_item::type_id::create("rsp"); 
            rsp.copy(req); 
            rsp.set_id_info(req);
            
            seq_item_port.item_done(rsp);
        end
    endtask 

endclass 