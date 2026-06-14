module data_memory(
  input clk,
  input mem_write,
  input mem_read,
  input [3:0] address,
  input [3:0] write_data,
  output reg [3:0] read_data
);
  reg[3:0]mem[0:15];
  always @(posedge clk)
    begin
      if(mem_write)
        mem[address]<=write_data;
    end
  always @(*)
    begin
      if(mem_read)
        read_data=mem[address];
      else
        read_data=4'b0000;
    end
endmodule