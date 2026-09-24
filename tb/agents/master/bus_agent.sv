// Encapsulates the bus sequencer, driver, and monitor.
// Creates and connects the driver and sequencer in active mode.
// Creates the monitor in both active and passive modes.
// Provides a reusable verification component for the bus protocol.

class bus_agent extends uvm_agent; 

    // factory registration 
    `uvm_component_utils(bus_agent)

    // variable declarations 
    bus_sequencer   bus_sqr; 
    bus_driver      bus_drv;
    bus_monitor     bus_mon; 
    
    // constructor 
    function new (string name = "bus_agent", 
                    uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (is_active == UVM_ACTIVE) begin 
            // create sequencer  
            bus_sqr = bus_sequencer::type_id::create("bus_sqr", this);
            // default case (hence, optional) 
            bus_sqr.set_arbitration(UVM_SEQ_ARB_FIFO);
            // create driver         
            bus_drv = bus_driver::type_id::create("bus_drv", this);
        end    

        // create monitor 
        bus_mon = bus_monitor::type_id::create("bus_mon",this);
    endfunction

    function void connect_phase(uvm_phase phase); 
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE) begin        
            // connect the driver to the sequencer 
            bus_drv.seq_item_port.connect(bus_sqr.seq_item_export);
        end 
    endfunction

endclass 