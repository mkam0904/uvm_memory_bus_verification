// Arbitrates requests from UVM sequences and supplies bus_item
// transactions to the driver through the sequence-item interface.
// Uses the default UVM FIFO arbitration policy unless reconfigured.

class bus_sequencer extends uvm_sequencer #(bus_item); 

    // factory registration 
    `uvm_component_utils(bus_sequencer)

    // constructor
    function new (string name = "bus_sequencer", uvm_component parent = null);
        super.new(name, parent); 
    endfunction

endclass 