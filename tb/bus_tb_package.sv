// Imports the UVM package and includes the UVM reporting/factory macros.
// Includes all transaction, agent, sequence, scoreboard, environment,
// and test classes in dependency order for compilation.
// Provides a common package containing the UVM verification classes.

package bus_tb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // include order matters because a class must be declared 
    // before another class can reference its type.
    `include  "tb/transactions/bus_item.sv"
    `include "tb/agents/bus_sequencer.sv"
    `include  "tb/agents/master/bus_driver.sv"
    `include "tb/agents/master/bus_monitor.sv"
    `include "tb/agents/master/bus_agent.sv"
    `include  "tb/sequences/bus_write_seq.sv"
    `include "tb/sequences/bus_read_seq.sv"
    `include  "tb/scoreboard/bus_scoreboard.sv"
    `include "tb/env/bus_env.sv"
    `include "tb/tests/bus_test.sv"

endpackage 
