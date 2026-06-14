module program_counter(
  input clk,rst,en,
  input [7:0] nxt_pc,
  output reg [7:0] pc
);
  always @(posedge  clk or posedge rst)
    begin
      if (rst)
        pc<=8'b00000000;
      else if (en)
          pc<=nxt_pc;
    end
endmodule