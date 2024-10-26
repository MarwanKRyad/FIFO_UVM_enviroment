package FIFO_driver_pack;
import uvm_pkg::*;
`include "uvm_macros.svh";
import seq_item_pkg::*;

	class FIFO_driver extends uvm_driver #(seq_item);
		`uvm_component_utils(FIFO_driver);
		seq_item my_seq_item;

		virtual the_interface driver_vif;

		function new (string name="FIFO_driver",uvm_component parent=null );
			super.new(name,parent);
		endfunction 


	

		task run_phase(uvm_phase phase );
			super.run_phase(phase);
			my_seq_item=seq_item::type_id::create("my_seq_item");
			forever begin
			seq_item_port.get_next_item(my_seq_item);
			driver_vif.rd_en=my_seq_item.rd_en;
			driver_vif.wr_en=my_seq_item.wr_en; 
			driver_vif.rst_n=my_seq_item.rst_n; 
			driver_vif.data_in=my_seq_item.data_in;
		
			@(negedge (driver_vif.clk));
			seq_item_port.item_done();
			end
		endtask

	endclass 
	
endpackage 