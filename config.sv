package FIFO_config_pack;
import uvm_pkg::*;
`include "uvm_macros.svh";
	class FIFO_config extends uvm_object;
		`uvm_object_utils(FIFO_config);
		virtual the_interface FIFO_virtual;
		function new (string name="FIFO_config");
			super.new(name);
		endfunction 
	endclass 
	
endpackage 