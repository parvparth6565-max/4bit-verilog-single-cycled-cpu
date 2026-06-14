module reg_out(
  input clk,rst,en,
  input [3:0] D,
  output reg [3:0]Q
);
  always @(posedge clk or posedge rst)
    begin
      if (rst)
      Q<=4'b0000;
      else if(en)
        Q<=D;
    end
endmodule
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
module instruction_memory(
  input [7:0] pc,
  output [18:0] instruction
);
  parameter DEPTH =226;
  reg[18:0]mem
  [0:DEPTH+1];
  initial begin
   mem[0]  = 19'b0000_000_00_01_10_0_0_0_1_0_0; // ADD  R0 + R1 -> R2

    mem[1]  = 19'b0000_001_01_10_11_0_0_0_1_0_0; // SUB  R1 - R2 -> R3

    mem[2]  = 19'b0000_010_00_11_01_0_0_0_1_0_0; // AND  R0 & R3 -> R1

    mem[3]  = 19'b0000_011_01_10_00_0_0_0_1_0_0; // OR   R1 | R2 -> R0

    mem[4]  = 19'b0000_100_10_11_01_0_0_0_1_0_0; // XOR  R2 ^ R3 -> R1

    mem[5]  = 19'b0000_101_00_00_00_0_0_0_1_0_0; // SHL  R0 -> R0

    mem[6]  = 19'b0000_110_01_01_01_0_0_0_1_0_0; // SHR  R1 -> R1

    mem[7]  = 19'b0101_000_00_00_00_0_0_0_1_1_0; // ADDI R0 + 5 -> R0

    mem[8]  = 19'b0011_000_01_00_01_0_0_0_1_1_0; // ADDI R1 + 3 -> R1

    mem[9]  = 19'b0010_001_10_00_10_0_0_0_1_1_0; // SUBI R2 - 2 -> R2

    mem[10] = 19'b0000_000_00_10_00_1_0_0_0_0_0; // STORE R1 -> MEM[R2]

    mem[11] = 19'b0000_000_00_10_11_0_1_1_1_0_0; // LOAD MEM[R2] -> R3

    mem[12] = 19'b0011_001_00_01_00_0_0_0_0_0_1; // BEQ R0,R1 , PC = PC+3 if equal
    mem[13] = 19'b1111111111111111111;
  end
  assign instruction=mem[pc];
endmodule 
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
module alu_datapath(
  input [3:0] data_A,
  input [3:0] data_B,
  input [2:0] sel,
  output reg [3:0] result,
  output zero_flag,
  output sign_flag,
  output carry_flag
);
  wire [4:0] add_out    =data_A+data_B;
  wire [3:0] sub_out    =data_A+(~data_B+1);
  wire [3:0] and_out    =data_A&data_B;
  wire [3:0] or_out     =data_A|data_B;
  wire [3:0] xor_out    =data_A^data_B;
  wire [3:0] shift_left =data_A<<1;
  wire [3:0] shift_right=data_A>>1;
  
  always @(*)
    begin
      case (sel)
        3'b000:result=add_out;
        3'b001:result=sub_out;
        3'b010:result=and_out;
        3'b011:result=or_out;
        3'b100:result=xor_out;
        3'b101:result=shift_left;
        3'b110:result=shift_right;
        default:result=4'b0000;
      endcase
    end
  assign zero_flag=(result==4'b0000);
  assign sign_flag=result[3];
  assign carry_flag=add_out[4];
endmodule
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