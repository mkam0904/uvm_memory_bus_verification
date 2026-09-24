// Defines the bus transaction containing address, write data,
// write enable, returned read data, and transaction abort status.
// Constrains addresses to four-byte alignment.
// Implements do_copy() to support independent request and response objects.

class bus_item extends uvm_sequence_item; 
    // factory registration 
    `uvm_object_utils(bus_item) 
    
    // variable declaration 
    rand bit [7:0]  addr; 
    rand bit [31:0] wr_data; 
    rand bit        wr_en; 
    bit [31:0]      rd_data; 
    bit             aborted; 
    
    // constructor 
    function new (string name = "bus_item"); 
        super.new(name); 
    endfunction 
    
    // do_copy
    function void do_copy(uvm_object rhs); 
        
        bus_item _rhs;
        super.do_copy(rhs);

        if (!$cast(_rhs, rhs)) begin
            `uvm_fatal("SEQ_ITEM","casting failed.")
        end
        this.addr    = _rhs.addr;
        this.wr_data = _rhs.wr_data;
        this.wr_en   = _rhs.wr_en;
        this.rd_data = _rhs.rd_data;
        this.aborted = _rhs.aborted;
    endfunction

    // constraints 
    constraint four_byte_aligned{ 
        addr[1:0] == 2'b00; 
    }


endclass