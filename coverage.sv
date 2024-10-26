package coverage_pkg;
import uvm_pkg::*;
import seq_item_pkg::*;

`include "uvm_macros.svh";
	class coverage extends  uvm_component;
		`uvm_component_utils(coverage);
		uvm_analysis_export #(seq_item) coverage_export;
		uvm_tlm_analysis_fifo #(seq_item) coverage_fifo;
		seq_item cov_seq_item;

	covergroup cg;

	write:coverpoint cov_seq_item.wr_en 
	{
		bins write_0={0};
		bins write_1={1};
	}

	read:coverpoint cov_seq_item.rd_en 
	{
		bins read_0={0};
		bins read_1={1};
	}


	full:coverpoint cov_seq_item.full 
	{
		bins full_0={0};
		bins full_1={1};
	}


	empty:coverpoint cov_seq_item.empty
	{
		bins empty_0={0};
		bins empty_1={1};
	}


	almostfull:coverpoint cov_seq_item.almostfull 
	{
		bins almostfull_0={0};
		bins almostfull_1={1};
	}


	almostempty:coverpoint cov_seq_item.almostempty
	{
		bins almostempty_0={0};
		bins almostempty_1={1};
	}

	overflow:coverpoint cov_seq_item.overflow
	{
		bins overflow_0={0};
		bins overflow_1={1};
	}

	underflow:coverpoint cov_seq_item.underflow
	{
		bins underflow_0={0};
		bins underflow_1={1};
	}
	
	wr_ack:coverpoint cov_seq_item.wr_ack
	{
		bins wr_ack_0={0};
		bins wr_ack_1={1};
	}

	cross_full:cross write,read,full
	{

		illegal_bins f_000=binsof(write.write_0)&&binsof(read.read_0)&&binsof(full.full_0);
		illegal_bins f_001=binsof(write.write_0)&&binsof(read.read_0)&&binsof(full.full_1);

		illegal_bins f_111=binsof(write.write_1)&&binsof(read.read_1)&&binsof(full.full_1);
		illegal_bins f_011=binsof(write.write_0)&&binsof(read.read_1)&&binsof(full.full_1);
	}
	cross_empty:cross write,read,empty
	{

		illegal_bins e_000=binsof(write.write_0)&&binsof(read.read_0)&&binsof(empty.empty_0);
		illegal_bins e_001=binsof(write.write_0)&&binsof(read.read_0)&&binsof(empty.empty_1);


	}

	cross_almostfull:cross write,read,almostfull
	{

		illegal_bins alfull_000=binsof(write.write_0)&&binsof(read.read_0)&&binsof(almostfull.almostfull_0);
		illegal_bins alfull_001=binsof(write.write_0)&&binsof(read.read_0)&&binsof(almostfull.almostfull_1);

	}

	cross_almostempty:cross write,read,almostempty
	{
		illegal_bins alempty_000=binsof(write.write_0)&&binsof(read.read_0)&&binsof(almostempty.almostempty_0);
		illegal_bins alempty_001=binsof(write.write_0)&&binsof(read.read_0)&&binsof(almostempty.almostempty_1);

	}

	cross_overflow:cross write,read,overflow
	{
		illegal_bins ov_000=binsof(write.write_0)&&binsof(read.read_0)&&binsof(overflow.overflow_0);

		illegal_bins ov_001=binsof(write.write_0)&&binsof(read.read_0)&&binsof(overflow.overflow_1);
		illegal_bins ov_011=binsof(write.write_0)&&binsof(read.read_1)&&binsof(overflow.overflow_1);
	}
	
	cross_underflow:cross write,read,underflow
	{

		illegal_bins uv_000=binsof(write.write_0)&&binsof(read.read_0)&&binsof(underflow.underflow_0);
		

		illegal_bins uv_101=binsof(write.write_1)&&binsof(read.read_0)&&binsof(underflow.underflow_1);
		illegal_bins uv_001=binsof(write.write_0)&&binsof(read.read_0)&&binsof(underflow.underflow_1);
	}

	cross_wr_ack:cross write,read,wr_ack
	{
		illegal_bins wack_000=binsof(write.write_0)&&binsof(read.read_0)&&binsof(wr_ack.wr_ack_0);
		illegal_bins wack_001=binsof(write.write_0)&&binsof(read.read_0)&&binsof(wr_ack.wr_ack_1);

		illegal_bins wack_011=binsof(write.write_0)&&binsof(read.read_1)&&binsof(wr_ack.wr_ack_1);
	}

	endgroup  
		
	function new (string name="coverage",uvm_component parent=null );
		super.new(name,parent);
		cg=new();
	endfunction 
		
	function void build_phase(uvm_phase phase );
		super.build_phase(phase);
		coverage_export=new("coverage_export",this);
		coverage_fifo=new("coverage_fifo",this);
	endfunction 


	function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			coverage_export.connect(coverage_fifo.analysis_export);
		endfunction 

	task run_phase(uvm_phase phase );
			super.run_phase(phase);
			cov_seq_item=seq_item::type_id::create("cov_seq_item");
			forever begin
			coverage_fifo.get(cov_seq_item);
			cg.sample();
			end
		endtask

	endclass 
endpackage 