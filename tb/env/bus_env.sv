// Creates the bus agent and scoreboard.
// Connects the monitor's analysis port to the scoreboard's
// analysis implementation for transaction-level checking.
// Provides the verification hierarchy used by UVM tests.

class bus_env extends uvm_env;

    // factory registration
    `uvm_component_utils(bus_env)

    // variable declaration
    bus_scoreboard sb; 
    bus_agent agent; 

    // constructor  
    function new (string name = "bus_env", uvm_component parent = null);
        super.new(name, parent); 
    endfunction 

    // 
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        agent = bus_agent::type_id::create("agent",this);
        sb = bus_scoreboard::type_id::create("sb",this);
    endfunction 

    // 
    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        agent.bus_mon.ap.connect(sb.imp); 

    endfunction 

endclass 