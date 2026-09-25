class bus_slave_driver extends uvm_driver #(bus_item);

    // factory registration 
    `uvm_component_utils(bus_slave_driver)

    // variable declaration 
    bus_item    req; 
    bus_item    rsp; 
    virtual bus_if.slave   vif; 

    // constructor 
    function new (string name = "bus_slave_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    // build_phase 
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if (!(uvm_config_db#(virtual bus_if.slave)::get(this,"","vif",vif)))
            `uvm_fatal("DRV","virtual interface not found") 
    endfunction

    //
    task drive_bus(bus_item req);
    
    endtask 

    
  

endclass 