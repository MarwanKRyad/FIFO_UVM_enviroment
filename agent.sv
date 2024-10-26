package agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh";
import FIFO_driver_pack::*;
import monitor_pkg::*;
import sequencer_pkg::*;
import seq_item_pkg::*;
import FIFO_config_pack::*;


	class agent extends uvm_agent;
		`uvm_component_utils(agent);
		monitor monitor_comp;
		FIFO_driver driver_comp;
		sequencer sequencer_comp;
		FIFO_config agent_config;
		uvm_analysis_port #(seq_item) agent_port;
	
	function new (string name="agent",uvm_component parent=null );
			super.new(name,parent);
		endfunction 

	function void build_phase(uvm_phase phase );
		super.build_phase(phase);
		driver_comp=FIFO_driver::type_id::create("driver_comp",this);
		sequencer_comp=sequencer::type_id::create("sequencer_comp",this);
		monitor_comp=monitor::type_id::create("monitor_comp",this);
		agent_port=new("agent_port",this);
		agent_config=FIFO_config::type_id::create("agent_config",this);
		if(!(uvm_config_db#(FIFO_config)::get(this, "", "CFG", agent_config)))
				`uvm_fatal("build_phase","agent failed to get config object");

		endfunction 

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		driver_comp.driver_vif=agent_config.FIFO_virtual;
		monitor_comp.mon_vif=agent_config.FIFO_virtual;
		monitor_comp.mon_port.connect(agent_port);
		driver_comp.seq_item_port.connect(sequencer_comp.seq_item_export);
	endfunction 
	endclass 
endpackage