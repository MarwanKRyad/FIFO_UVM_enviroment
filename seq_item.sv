package seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh";
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

	class seq_item extends  uvm_sequence_item;
		`uvm_object_utils(seq_item);
rand logic[FIFO_WIDTH-1:0] data_in;
rand logic  rst_n;
logic wr_en, rd_en;
logic[FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow, underflow, full, empty, almostfull, almostempty;

	function new (string name="seq_item");
			super.new(name);
		endfunction 

	function string covert2string();
		return $sformatf("%s data_in=0b%0b , rst_n=0b%0b , wr_en=0b%0b , rd_en=0b%0b ,data_out=0b%0b , wr_ack=0b%0b , overflow=0b%0b, underflow=0b%0b,full=0b%0b,empty=0b%0b,almostfull=0b%0b,almostempty=0b%0b",super.convert2string(),data_in,rst_n,wr_en,rd_en,data_out,wr_ack,overflow,underflow,full,empty,almostfull,almostempty );
	endfunction 

	function string covert2string_stimuluts();
		return $sformatf("data_in=0b%0b , rst_n=0b%0b , wr_en=0b%0b , rd_en=0b%0b ",data_in,rst_n,wr_en,rd_en );
	endfunction 


	/*............................................................  constraints ......................................................................*/
	constraint reset_const {rst_n dist {1:/98 , 0:/2};};
	
	
	endclass 
endpackage 