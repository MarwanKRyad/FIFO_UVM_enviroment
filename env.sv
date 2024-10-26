package env_pack;
import uvm_pkg::*;
import coverage_pkg::*;
import agent_pkg::*;
import FIFO_scoreboard_pkg::*;
`include "uvm_macros.svh"


  class env extends uvm_env;
	`uvm_component_utils(env);
	coverage coverage_env;
	agent agent_env;
	FIFO_scoreboard score_env;

function new (string name="shift_reg_env", uvm_component parent=null);
	super.new(name,parent);

endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	agent_env=agent::type_id::create("agent_env",this);
	coverage_env=coverage::type_id::create("coverage_env",this);
	score_env=FIFO_scoreboard::type_id::create("score_env",this);
	
endfunction 



function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
		agent_env.agent_port.connect(coverage_env.coverage_export);
		agent_env.agent_port.connect(score_env.scoreboard_export);
		endfunction 
	endclass 


endpackage 













