# uvm_memory_bus_verification

I developed a reusable UVM verification environment for a memory-mapped bus with a 64-word memory slave. 
The environment includes a master agent, randomized and directed sequences, a transaction-level scoreboard with an independent reference memory model, and request/response handling. 
The testbench uses clocking blocks and modports for synchronized bus access, with reset-aware transaction handling. 
I structured the environment to support future slave-agent, functional coverage, and register-model integration.
