////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(the_interface.DUT inter_type);


reg [inter_type.FIFO_WIDTH-1:0] mem [inter_type.FIFO_DEPTH-1:0];

reg [inter_type.max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [inter_type.max_fifo_addr:0] count;

always @(posedge inter_type.clk or negedge inter_type.rst_n) begin
	if (!inter_type.rst_n) begin
		wr_ptr <= 0;
		/*Bug: in case of reset no defined behavior  for wr_ack , overflow */
		inter_type.wr_ack <= 0;
		inter_type.overflow <= 0;
	end
	else if (inter_type.wr_en && count < inter_type.FIFO_DEPTH) begin
		mem[wr_ptr] <= inter_type.data_in;
		inter_type.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		inter_type.overflow <= 0;
		
	end
	else begin 
		inter_type.wr_ack <= 0; 
		if (inter_type.full && inter_type.wr_en)
			inter_type.overflow <= 1;
		else
			inter_type.overflow <= 0;
	end
end

always @(posedge inter_type.clk or negedge inter_type.rst_n) begin
	if (!inter_type.rst_n) 
	begin
		rd_ptr <= 0;
		/*Bug: in case of reset no defined behavior for underflow  */
		inter_type.underflow <= 0;
		inter_type.data_out<=0;
	end
	else if (inter_type.rd_en && count != 0) 
	begin
		inter_type.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		inter_type.underflow <= 0;
	end
	/*Bug:this is the implementation for underflow since it sequential not in continuous assignment */
	else
	begin
		inter_type.data_out<=0;
		if (inter_type.empty && inter_type.rd_en)
			inter_type.underflow <= 1;
		else
			inter_type.underflow <= 0;

	end
	
end

always @(posedge inter_type.clk or negedge inter_type.rst_n) begin
	if (!inter_type.rst_n) begin
		count <= 0;
	end
	else begin
		/*Bug: there is no implementation for corner cases for empty and full FIFO*/
		if	( ( ({inter_type.wr_en, inter_type.rd_en} == 2'b10) && !inter_type.full ) || (({inter_type.wr_en, inter_type.rd_en} == 2'b11) && inter_type.empty ) )  
			count <= count + 1;
		else if ( ( ({inter_type.wr_en, inter_type.rd_en} == 2'b01) && !inter_type.empty ) || (({inter_type.wr_en, inter_type.rd_en} == 2'b11) && inter_type.full ) ) 
			count <= count - 1;
	end
end


assign inter_type.full = (count == inter_type.FIFO_DEPTH)? 1 : 0;
assign inter_type.empty = (count == 0)? 1 : 0;
assign inter_type.almostfull = (count == inter_type.FIFO_DEPTH-1)? 1 : 0;  //Bug:in case of almostfull it must be -1 not -2
assign inter_type.almostempty = (count == 1)? 1 : 0;

/*......................................... combinational output assertion ............................................................*/
always_comb 
begin
	if(count==8)
		assert(inter_type.full);
end

always_comb 
begin
	if(count==0)
		assert(inter_type.empty);
end

always_comb 
begin
	if(count==7)
		assert(inter_type.almostfull);
end

always_comb 
begin
	if(count==1)
		assert(inter_type.almostempty);
end


/*....................................... counter,write,read pointer assertion  .................................................*/

`ifdef SIM

/*...... wr_en=1 , rd_en=0 then count++ , rd_ptr const , wr_ptr++.........*/
property count1;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0) 
inter_type.wr_en && ~ inter_type.rd_en && count!=8 |=> count==$past(count)+1 && $stable(rd_ptr) && ( wr_ptr==$past(wr_ptr)+1 || ( $past(wr_ptr)==7 && wr_ptr==0) ) ;
endproperty

/*...... wr_en=0 , rd_en=1 then count-- , rd_ptr ++ , wr_ptr const.........*/
property count2;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0)
 ~inter_type.wr_en && inter_type.rd_en && count!=0  |=> count==$past(count)-1 && $stable(wr_ptr)&& ( rd_ptr==$past(rd_ptr)+1 || ( $past(rd_ptr)==7 && rd_ptr==0) ) ;
endproperty

/*...... wr_en=1 , rd_en=1 , full then count-- , rd_ptr ++ , wr_ptr const.........*/
property count3;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0)
 inter_type.wr_en && inter_type.rd_en && inter_type.full |=> count==$past(count)-1 && $stable(wr_ptr)&& ( rd_ptr==$past(rd_ptr)+1 || ( $past(rd_ptr)==7 && rd_ptr==0) )  ;
endproperty

/*...... wr_en=1 , rd_en=1 then count++ , rd_ptr const , wr_ptr++.........*/
property count4;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0)
 inter_type.wr_en && inter_type.rd_en && inter_type.empty  |=> count==$past(count)+1 && $stable(rd_ptr) &&  ( wr_ptr==$past(wr_ptr)+1 || ( $past(wr_ptr)==7 && wr_ptr==0) ) ;
endproperty

/*...... wr_en=1 , rd_en=1 , NOT full, NOT empty then count const , rd_ptr ++, wr_ptr++.........*/
property count5;
@(posedge inter_type.clk) disable iff(inter_type.rst_n==0)
 inter_type.wr_en && inter_type.rd_en && ~inter_type.empty && ~inter_type.full  |=> $stable(count) && 
 ( rd_ptr==$past(rd_ptr)+1 || ( $past(rd_ptr)==7 && rd_ptr==0) ) && ( wr_ptr==$past(wr_ptr)+1 || ( $past(wr_ptr)==7 && wr_ptr==0) )  ;
endproperty

count1_assert: assert property (count1);
count2_assert: assert property (count2);
count3_assert: assert property (count3);
count4_assert: assert property (count4);
count5_assert: assert property (count5);

count1_cover: cover property (count1);
count2_cover: cover property (count2);
count3_cover: cover property (count3);
count4_cover: cover property (count4);
count5_cover: cover property (count5);


/*........................................................................................*/


`endif


endmodule