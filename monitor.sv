package monitor_pkg;
import uvm_pkg::*;
import seq_item_pkg::*;
`include "uvm_macros.svh";
	class monitor extends uvm_monitor;
		`uvm_component_utils(monitor);
		virtual the_interface mon_vif;
		seq_item mon_seq;
		uvm_analysis_port #(seq_item) mon_port;

		function new (string name="monitor",uvm_component parent=null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase );
		super.build_phase(phase);
		mon_port=new("mon_port",this);
		mon_seq=seq_item::type_id::create("mon_seq");
		endfunction 
		
		task run_phase(uvm_phase phase );
			super.run_phase(phase);
			
			forever begin
			mon_seq=seq_item::type_id::create("mon_seq");
			@(negedge (mon_vif.clk));

			mon_seq.rst_n=mon_vif.rst_n;
			mon_seq.rd_en=mon_vif.rd_en;
			mon_seq.wr_en=mon_vif.wr_en;
			mon_seq.wr_ack=mon_vif.wr_ack;
			mon_seq.data_out=mon_vif.data_out; 
			mon_seq.overflow=mon_vif.overflow; 
			mon_seq.underflow=mon_vif.underflow;
			mon_seq.almostempty=mon_vif.almostempty;
			mon_seq.almostfull=mon_vif.almostfull;
			mon_seq.data_in=mon_vif.data_in;
			mon_seq.empty=mon_vif.empty;
			mon_seq.full=mon_vif.full;

			
			mon_port.write(mon_seq);

			end
			
		endtask

	endclass 
endpackage 