// Creates the verification environment and read/write sequences.
// Configures transaction counts and directed test addresses.
// Executes a write followed by a read to the same memory location.
// Uses UVM phase objections to keep simulation active while
// stimulus executes and the scoreboard checks observed transactions.

class bus_test extends uvm_test; 

    // Factory registration
    `uvm_component_utils(bus_test)

    // Variable declarations
    bus_env env; 
    bus_read_seq read_seq; 
    bus_write_seq write_seq; 

    // constructor
    function new (string name = "bus_test", uvm_component parent = null);
        super.new(name, parent); 
    endfunction 

    // build_phase 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = bus_env::type_id::create("env",this);
        read_seq = bus_read_seq::type_id::create("read_seq");
        write_seq = bus_write_seq::type_id::create("write_seq"); 
    endfunction

    // run_phase
    task run_phase(uvm_phase phase);

        bit [7:0] addr = 8'h20; 
     
        write_seq.num_transactions = 1; 
        read_seq.num_transactions = 1; 
            
        write_seq.use_fixed_addr = 1'b1;
        write_seq.fixed_addr = addr; 

        read_seq.use_fixed_addr = 1'b1;
        read_seq.fixed_addr = addr; 

        phase.raise_objection(this);

        write_seq.start(env.agent.bus_sqr); 
        read_seq.start(env.agent.bus_sqr);

        phase.drop_objection(this);

    endtask 
    
endclass 