module control_unit(
  input [18:0] instruction,
  output [2:0] sel,
  output [1:0] select_A,
  output [1:0] select_B,
  output [1:0] write_select,
  output [3:0] immediate,
  output mem_write,
  output mem_read,
  output mem_to_reg,
  output write_enable,
  output alu_src,
  output branch,
  output halt
);
  assign immediate=instruction[18:15];
  assign sel=instruction[14:12];
  assign select_A=instruction[11:10];
  assign select_B=instruction[9:8];
  assign write_select=instruction[7:6];
  assign mem_write=instruction[5];
  assign mem_read=instruction[4];
  assign mem_to_reg=instruction[3];
  assign write_enable=instruction[2];
  assign alu_src=instruction[1];
  assign branch=instruction[0];
  assign halt=(instruction==19'b1111111111111111111);

endmodule 