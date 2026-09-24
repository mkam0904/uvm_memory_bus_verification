// Generates configurable numbers of randomized bus read requests.
// Supports random or directed, four-byte-aligned addresses.
// Retrieves driver responses, checks transaction abort status,
// and reports successfully returned read data.

class bus_read_seq extends uvm_sequence #(bus_item); 

    // factory registration 
    `uvm_object_utils(bus_read_seq)

    // variable declaration
    int unsigned num_transactions = 10; 
    bus_item rreq; 
    bus_item rsp; 
    bit use_fixed_addr = 0; 
    bit [7:0] fixed_addr; 

    // constructor 
    function new (string name = "bus_read_seq");
        super.new(name); 
    endfunction 

    // body 
    task body();
        if ((num_transactions < 1) || (num_transactions > 100))
            `uvm_fatal("READ_SEQ",$sformatf("num_transactions: %0d. must be between 1 and 100.", num_transactions))

        for (int i=0; i<num_transactions; i++) begin 
         
            // create req 
            rreq = bus_item::type_id::create("rreq");

            // start_item 
            start_item(rreq);
         
            // randomize the request 
            if (!(rreq.randomize() with {
                wr_en == 1'b0;
                if (local::use_fixed_addr == 1'b1) {
                    addr == local::fixed_addr; 
                }
            }))
                `uvm_fatal("READ_SEQ","Randomization failed !")
         
            // finish_item: send request to driver  
            finish_item(rreq);

            get_response(rsp);
            if (rsp.aborted == 1'b1) begin
                `uvm_error("READ_SEQ",$sformatf("transaction aborted seq_id:%0h txn_id:%0h, addr: %0h",rsp.get_sequence_id(), rsp.get_transaction_id(),rsp.addr
                ));
            end 
            else begin 
                `uvm_info("READ_SEQ",$sformatf("Read completed: addr=%0h rd_data=%0h",rsp.addr, rsp.rd_data),UVM_MEDIUM)
            end 
        end 
    endtask 
endclass 