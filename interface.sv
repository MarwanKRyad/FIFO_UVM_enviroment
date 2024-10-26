interface the_interface (clk);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
localparam max_fifo_addr = $clog2(FIFO_DEPTH);
input clk;
logic  [FIFO_WIDTH-1:0] data_in,data_out;
logic rst_n, wr_en, rd_en,wr_ack, overflow,underflow,full, empty, almostfull, almostempty;
modport DUT (input data_in ,clk , rst_n, wr_en, rd_en,output data_out, wr_ack, overflow, underflow, full, empty, almostfull, almostempty );

endinterface 