package write_seq_pkg;
import seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh";
	class write_only_seq extends uvm_sequence #(seq_item);
		`uvm_object_utils(write_only_seq);
		seq_item write_only_seq_item;

		function new (string name="write_only_seq");
			super.new(name);
		endfunction

		task body;
			write_only_seq_item=seq_item::type_id::create("write_only_seq_item");
			write_only_seq_item.rd_en=0;
			write_only_seq_item.wr_en=1;
			repeat(100)
			begin
			start_item(write_only_seq_item);
			assert(write_only_seq_item.randomize());
			finish_item(write_only_seq_item);
	
			end
			
		endtask 
	endclass 
endpackage 