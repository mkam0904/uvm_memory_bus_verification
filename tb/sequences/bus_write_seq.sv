// Generates configurable numbers of randomized bus write requests.
// Supports random or directed, four-byte-aligned addresses.
// Starts transactions through the sequencer and retrieves driver
// responses to detect and report aborted write transactions.

class bus_write_seq extends uvm_sequence #(bus_item);

    // factory registration 
    `uvm_object_utils(bus_write_seq)

    // variable declaration 
    bus_item wreq; 
    bus_item wrsp; 
    int unsigned num_transactions = 10; 
    bit use_fixed_addr = 0; 
    bit [7:0] fixed_addr; 

    // constructor 
    function new (string name = "bus_write_seq");
        super.new(name);
    endfunction 

    // body 
    task body ();

        if (num_transactions < 1 || num_transactions > 100)
            `uvm_fatal("SEQ","num_transactions must be between 1 and 100")

        for (int i = 0;i < num_transactions; i++) begin

            wreq = bus_item::type_id::create("wreq"); 
        
            start_item(wreq);
        
            if (!(wreq.randomize() with {
                wr_en == 1'b1; 
                if (local::use_fixed_addr == 1'b1) {
                    addr == local::fixed_addr; 
                }
            }))  
            `uvm_fatal("SEQ","Randomization failed.");
        
            finish_item(wreq);
        
            get_response(rsp);
            if (rsp.aborted == 1'b1) begin
                `uvm_error("SEQ",$sformatf("transaction aborted seq_id:%0h xn_id:%0h",rsp.get_sequence_id(), rsp.get_transaction_id())) 
            end 
            else begin 
                `uvm_info("READ_SEQ",$sformatf("transaction seq_id:%0h xn_id:%0h, ",rsp.get_sequence_id(), rsp.get_transaction_id())) 
            end 
        end 

    endtask


endclass 