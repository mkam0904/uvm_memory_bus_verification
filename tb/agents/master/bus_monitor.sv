// Passively observes completed bus transactions at clocking events.
// Captures address, read/write direction, and data into bus_item objects.
// Publishes observed transactions through a UVM analysis port for
// scoreboard checking and other verification subscribers.

class bus_monitor extends uvm_monitor;

    // factory registration 
    `uvm_component_utils(bus_monitor)

    // variable declaration 
    virtual bus_if.monitor vif; 
    uvm_analysis_port #(bus_item) ap;
    bus_item tr; 

    // constructor 
    function new( string name = "bus_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);  
    endfunction

    // build_phase
    function void build_phase (uvm_phase phase);
        super.build_phase(phase); 
        if (!uvm_config_db #(virtual bus_if.monitor)::get(this,"","vif",vif))
            `uvm_fatal("MON","virtual interface not found")

    endfunction 

    // run_phase 
    task run_phase (uvm_phase phase);
        wait(vif.rst_n); 
        forever begin 
            @vif.mon_cb; 
            if (vif.rst_n == 1'b1 && vif.mon_cb.valid == 1'b1 && vif.mon_cb.ready == 1'b1) begin
                tr = bus_item::type_id::create("tr"); 
                tr.addr     = vif.mon_cb.addr; 
                tr.wr_data  = vif.mon_cb.wr_data; 
                tr.wr_en    = vif.mon_cb.wr_en; 
                tr.rd_data  = vif.mon_cb.rd_data; 
                `uvm_info("MON",$sformatf("addr%0h wr_en:%0b wr_data:%0h read_data:%0h",tr.addr, tr.wr_en, tr.wr_data, tr.rd_data),UVM_MEDIUM)
                ap.write(tr); 
            end 
        end
    endtask 

endclass 