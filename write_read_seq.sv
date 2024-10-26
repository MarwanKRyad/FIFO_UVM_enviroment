package write_read_seq_pkg;
import seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh";
	class write_read_seq extends uvm_sequence #(seq_item);
		`uvm_object_utils(write_read_seq);
		seq_item write_read_seq_item;

		function new (string name="write_read_seq");
			super.new(name);
		endfunction

		task body;
			write_read_seq_item=seq_item::type_id::create("write_read_seq_item");
			write_read_seq_item.rd_en=1;
			write_read_seq_item.wr_en=1;
			repeat(100)
			begin
			start_item(write_read_seq_item);
			assert(write_read_seq_item.randomize());
			finish_item(write_read_seq_item);	
			end
		

		endtask 
	endclass 
endpackage 
