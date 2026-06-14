module cpu_datapath(
  input clk,rst,en,
  output [3:0] result
);
  wire [2:0] sel;
  wire [1:0] select_A;
  wire [1:0] select_B;
  wire [1:0] write_select;
  wire [3:0] write_data;
  wire [3:0] immediate;
  wire [3:0] alu_input_B;
  wire mem_write;
  wire mem_read;
  wire mem_to_reg;
  wire write_enable;
  wire [3:0] data_A;
  wire [3:0] data_B;
  wire [18:0] instruction;
  wire [7:0] pc;
  wire [3:0] read_data;
  wire alu_src;
  wire branch;
  wire branch_taken;
  wire [7:0] branch_target;
  wire [7:0] nxt_pc;
  wire zero_flag;
  wire sign_flag;
  wire carry_flag;
  wire halt;
  
  program_counter pc1(
    .clk(clk),
    .rst(rst),
    .en(en),
    .nxt_pc(nxt_pc),
    .pc(pc)
  );
  instruction_memory imem(
    .pc(pc),
    .instruction(instruction)
  );
  control_unit cu(
    .instruction(instruction),
    .sel(sel),
    .select_A(select_A),
    .select_B(select_B),
    .write_select(write_select),
    .immediate(immediate),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .mem_to_reg(mem_to_reg),
    .write_enable(write_enable),
    .alu_src(alu_src),
    .branch(branch),
    .halt(halt)
  );
  reg_file rf(
    .clk(clk),
    .rst(rst),
    .en(write_enable),
    .select_A(select_A),
    .select_B(select_B),
    .write_select(write_select),
    .write_data(write_data),
    .data_A(data_A),
    .data_B(data_B)
  );
  alu_datapath alu1(
    .data_A(data_A),
    .data_B(alu_input_B),
    .sel(sel),
    .result(result),
    .zero_flag(zero_flag),
    .carry_flag(carry_flag),
    .sign_flag(sign_flag)
  );
  assign alu_input_B=(alu_src)?immediate:data_B;
  assign branch_taken = branch & zero_flag;
  assign branch_target = (pc+1)+immediate;
  assign nxt_pc=halt?pc:branch_taken?branch_target:(pc+1);
  data_memory dmem(
    .clk(clk),
    .write_data(data_B),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .address(result),
    .read_data(read_data)
  );
  assign write_data=(mem_to_reg)?read_data:result;
endmodule