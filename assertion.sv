module FIFO_assertion (the_interface.DUT inter_type);


//  - over - under - full - empty - almostfull - almostempty

always_comb 
begin
	if(inter_type.rst_n==0)
		assert final (inter_type.empty);
end

property wr_ack;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0) 
inter_type.full |=> !inter_type.wr_ack ;
endproperty


property full_prop;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0) 
inter_type.almostfull && inter_type.wr_en && ~ inter_type.rd_en |=> inter_type.full ;
endproperty


property almostfull_prop;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0) 
inter_type.full && ~inter_type.wr_en &&  inter_type.rd_en |=> inter_type.almostfull ;
endproperty

property empty_prop;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0) 
inter_type.almostempty && inter_type.rd_en && ~ inter_type.wr_en |=> inter_type.empty ;
endproperty

property almostempty_prop;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0) 
inter_type.empty && ~inter_type.rd_en &&  inter_type.wr_en |=> inter_type.almostempty ;
endproperty


property overflow_prop;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0) 
inter_type.full  &&  inter_type.wr_en |=> inter_type.overflow ;
endproperty

property underflow_prop;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0) 
inter_type.empty  &&  inter_type.rd_en |=> inter_type.underflow ;
endproperty





wr_ack_assert: assert property (wr_ack);
full_assert: assert property (full_prop);
empty_assert: assert property (empty_prop);
almostfull_assert: assert property (almostfull_prop);
almostempty_assert: assert property (almostempty_prop);
overflow_assert: assert property (overflow_prop);
underflow_assert: assert property (underflow_prop);

wr_ack_cover: cover property (wr_ack);
full_cover: cover property (full_prop);
empty_cover: cover property (empty_prop);
almostfull_cover: cover property (almostfull_prop);
almostempty_cover: cover property (almostempty_prop);
overflow_cover: cover property (overflow_prop);
underflow_cover: cover property (underflow_prop);










property overflow2;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0) 
inter_type.wr_en  && DUT.count==8 |=> inter_type.overflow ;
endproperty


property underflow2;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0) 
inter_type.rd_en && DUT.count==0 |=> inter_type.underflow ;
endproperty


property wr_ack2;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0)
 inter_type.wr_en  && DUT.count!=8  |=> inter_type.wr_ack ;
endproperty

property wr_ack3;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0)
 inter_type.wr_en  && DUT.count==8  |=> ~inter_type.wr_ack ;
endproperty


overflow2_assert: assert property (overflow2);
underflow2_assert: assert property (underflow2);
wr_ack2_assert: assert property (wr_ack2);
wr_ack3_assert: assert property (wr_ack3);



overflow1_cover: cover property (overflow2);
underflow1_cover: cover property (underflow2);
wr_ack1_cover: cover property (wr_ack2);
wr_ack2_cover: cover property (wr_ack3);














endmodule 