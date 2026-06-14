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