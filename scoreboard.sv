package FIFO_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh";
import seq_item_pkg::*;
	class FIFO_scoreboard extends  uvm_scoreboard;
		`uvm_component_utils(FIFO_scoreboard);
		uvm_analysis_export #(seq_item) scoreboard_export;
		uvm_tlm_analysis_fifo #(seq_item) scoreboard_fifo;
		seq_item score_seq_item;


		parameter FIFO_WIDTH = 16;
		reg[FIFO_WIDTH-1:0] fifo [$];
		int q_size_before;
		logic [FIFO_WIDTH-1:0] data_out_ref;
		int correct_count=0;
		int error_count=0;
		logic overflow,underflow,wr_ack,full,empty,almostfull,almostempty;

	function new (string name="FIFO_scoreboard",uvm_component parent=null );
		super.new(name,parent);
	endfunction 
		
	function void build_phase(uvm_phase phase );
		super.build_phase(phase);
		scoreboard_export=new("scoreboard_export",this);
		scoreboard_fifo=new("scoreboard_fifo",this);
	endfunction 

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		scoreboard_export.connect(scoreboard_fifo.analysis_export);
	endfunction 

	task run_phase(uvm_phase phase );
		super.run_phase(phase);
		score_seq_item=seq_item::type_id::create("score_seq_item");
		forever begin
			scoreboard_fifo.get(score_seq_item);
			golden_model(score_seq_item);
			if(score_seq_item.data_out!=data_out_ref && score_seq_item.underflow!=underflow && score_seq_item.overflow!=overflow&& score_seq_item.wr_ack!=wr_ack
			 && score_seq_item.full!=full && score_seq_item.almostfull!=almostfull && score_seq_item.empty!=empty && score_seq_item.almostempty!=almostempty)
				begin
					`uvm_error("run_phase",$sformatf("error at trans %s while the ref 0b%0b",score_seq_item.convert2string(),data_out_ref));
					error_count++;

				end
			
			else
			
					correct_count++;
			end
		endtask

function void golden_model(seq_item seq_item_param);     

		q_size_before=fifo.size();
		if(seq_item_param.rst_n==0)
		  begin
			data_out_ref=0;
			for(int i=0 ; i<q_size_before;i++)
			fifo.pop_front();
			{full,almostfull,empty,almostempty,overflow,underflow,wr_ack}=7'b0000000;
			end
			else 
			begin
			case({seq_item_param.wr_en,seq_item_param.rd_en})
			2'b00:
			begin
				data_out_ref=0;

			end
			2'b10:
			begin 
				if(fifo.size()!=8)
					begin

					fifo.push_back(seq_item_param.data_in);
					data_out_ref=0;
					if(fifo.size()==7)
						begin
						full=1;
						almostfull=1;	
						almostempty=0;
						end

					else if(fifo.size()==6)
						begin
						full=0;
						almostfull=1;
						almostempty=0;
						end
				
					
					else if(fifo.size()==0)
						begin
						full=0;
						almostfull=0;	
						almostempty=1;
						end

					{empty,overflow,underflow,underflow,wr_ack}=4'b0001;
					
					end

					else if(fifo.size()==8)
					begin
						{full,almostfull,empty,almostempty,overflow,underflow,wr_ack}=7'b1000100;

					end
			end

			2'b01:
			begin 
				if(fifo.size()==1)
					data_out_ref=fifo.pop_front();
				begin
					if(fifo.size()==1)
					begin
					empty=1;
					almostempty=0;
					underflow=0;
					end
					
				else if(fifo.size()==8)
					begin
					almostfull=1;
					empty=0;
					almostempty=0;
					underflow=0;
					end
				else if (fifo.size()==0)
					begin
					almostfull=0;
					empty=0;
					almostempty=0;
					underflow=1;
					end
				else 

					begin
					almostfull=0;
					empty=0;
					almostempty=0;
					underflow=0;
					end

				{full,overflow,underflow,wr_ack}=4'b000;

					data_out_ref=0;
				end
			end

			2'b11:
			begin
			if(fifo.size()==0)
				begin
					fifo.push_back(seq_item_param.data_in);
					data_out_ref=0;
					{full,almostfull,empty,almostempty,overflow,underflow,wr_ack}=7'b0010001;

				end
			

			else if (fifo.size()==8)
				begin
					data_out_ref=fifo.pop_front();
					{full,almostfull,empty,almostempty,overflow,underflow,wr_ack}=7'b0100000;
				end
					

			
			else
				begin
					fifo.push_back(seq_item_param.data_in);
					data_out_ref=fifo.pop_front();
					if(fifo.size()==7)
					{full,almostfull,empty,almostempty,overflow,underflow,wr_ack}=7'b0100001;
					else if (fifo.size()==1)
					{full,almostfull,empty,almostempty,overflow,underflow,wr_ack}=7'b0001001;
					
				end
					{full,almostfull,empty,almostempty,overflow,underflow,wr_ack}=7'b0000001;

			end

			endcase 

			end

endfunction


function void report_phase(uvm_phase phase );
		super.report_phase(phase);
		`uvm_info("report_phase",($sformatf("correct_count=%0d",correct_count)), UVM_MEDIUM );
		`uvm_info("report_phase",($sformatf("error_count=%0d",error_count)),UVM_MEDIUM );
	endfunction 


	endclass 
endpackage 