module reg_file(
  input clk,rst,en,
  input [1:0] select_A,
  input [1:0] select_B,
  input [1:0] write_select,
  input [3:0] write_data,
  output [3:0] data_A,
  output [3:0] data_B
);
  reg[3:0]r[0:3];
  assign data_A=r[select_A];
  assign data_B=r[select_B];
  always @(posedge clk or posedge rst)
    begin
      if (rst)
        begin
          r[0]<=4'b0000;
          r[1]<=4'b0000;
          r[2]<=4'b0000;
          r[3]<=4'b0000;
        end
      else if (en)
        begin
        r[write_select]<=write_data;
        end
    end
endmodule