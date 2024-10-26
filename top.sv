import uvm_pkg::*;
import test_pack::*;

`include "uvm_macros.svh";
module top ();
bit clk;

initial
begin	
clk=0;
forever 
#1 clk=~clk;
end

the_interface inter_type(clk);
FIFO DUT(inter_type);
bind DUT FIFO_assertion SVA(inter_type);

initial 
begin
uvm_config_db#(virtual the_interface)::set(null, "uvm_test_top", "interface", inter_type);
run_test("test");	
end
endmodule 


