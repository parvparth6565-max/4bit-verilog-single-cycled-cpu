module reg_out(
  input clk,rst,en,
  input [30] D,
  output reg [30]Q
);
  always @(posedge clk or posedge rst)
    begin
      if (rst)
      Q=4'b0000;
      else if(en)
        Q=D;
    end
endmodule