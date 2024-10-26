package read_seq_pkg;
import seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh";
	class read_only_seq extends uvm_sequence #(seq_item);
		`uvm_object_utils(read_only_seq);
		seq_item read_only_seq_item;

		function new (string name="read_only_seq");
			super.new(name);
		endfunction

		task body;
			read_only_seq_item=seq_item::type_id::create("read_only_seq_item");
			read_only_seq_item.rd_en=1;
			read_only_seq_item.wr_en=0;
			repeat(100)
			begin	
			start_item(read_only_seq_item);
			assert(read_only_seq_item.randomize());
			finish_item(read_only_seq_item);
			end
			


		endtask 
	endclass 
endpackage 