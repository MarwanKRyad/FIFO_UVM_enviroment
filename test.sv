package test_pack;
import uvm_pkg::*;
import env_pack::*;
import FIFO_config_pack::*;
import write_read_seq_pkg::*;
import write_seq_pkg::*;
import read_seq_pkg::*;



`include "uvm_macros.svh";
	class test extends uvm_test;
		`uvm_component_utils(test);
		env env_obj;
		FIFO_config FIFO_object;
		write_read_seq wr_seq;
		write_only_seq w_seq;
		read_only_seq r_seq ;
		int i=0;

		function new (string name="test",uvm_component parent=null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
		 	super.build_phase(phase);
		 	env_obj=env::type_id::create("env_obj",this);
			FIFO_object=FIFO_config::type_id::create("FIFO_object");
			wr_seq=write_read_seq::type_id::create("wr_seq");
			w_seq=write_only_seq::type_id::create("w_seq");
			r_seq=read_only_seq::type_id::create("r_seq");
			if(!(uvm_config_db#(virtual the_interface)::get(this, "", "interface", FIFO_object.FIFO_virtual)))
			`uvm_fatal("build_phase","test failed to get config object")
			uvm_config_db#(FIFO_config)::set(this, "*", "CFG",FIFO_object );

		 endfunction 

		 task run_phase(uvm_phase phase);
		 	super.run_phase(phase);
		 	phase.raise_objection(this);

		 	repeat(100)
		 	begin
		 		i++;
		 	`uvm_info("run_phase",$sformatf("loop number %0d",i),UVM_MEDIUM);
			w_seq.start(env_obj.agent_env.sequencer_comp);
			wr_seq.start(env_obj.agent_env.sequencer_comp);
			r_seq.start(env_obj.agent_env.sequencer_comp);
			w_seq.start(env_obj.agent_env.sequencer_comp);
			r_seq.start(env_obj.agent_env.sequencer_comp);

		 	end
		
		 	
		 	phase.drop_objection(this);
		 endtask

	endclass 
endpackage 
