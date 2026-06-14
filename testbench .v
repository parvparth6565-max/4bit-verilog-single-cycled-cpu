`timescale 1ns/1ps

module tb_cpu;

reg clk;
reg rst;
reg en;

wire [3:0] result;

cpu_datapath dut(
    .clk(clk),
    .rst(rst),
    .en(en),
    .result(result)
);

/////////////////////////////////////////////////////
// Clock Generation
/////////////////////////////////////////////////////

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

/////////////////////////////////////////////////////
// Waveform Dump
/////////////////////////////////////////////////////

initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0,tb_cpu);
end

/////////////////////////////////////////////////////
// Reset and Enable
/////////////////////////////////////////////////////

initial begin

    $display("===============================================");
    $display("        CPU V4 VERIFICATION STARTED");
    $display("===============================================");

    rst = 1;
    en  = 0;

    #20;

    rst = 0;
    en  = 1;

end

/////////////////////////////////////////////////////
// Timeout Protection
/////////////////////////////////////////////////////

initial begin
    #2000;

    $display("-------------------------------------------");
    $display("Simulation Finished");
    $display("-------------------------------------------");

    $finish;
end

/////////////////////////////////////////////////////
// CPU Monitor
/////////////////////////////////////////////////////

initial begin

$display("----------------------------------------------------------------------------");
$display("Time\tPC\tResult\tZF\tSF\tBranch\tTaken");
$display("----------------------------------------------------------------------------");

$monitor("%0t\t%0d\t%0d\t%b\t%b\t%b\t%b",

$time,
dut.pc,
dut.result,
dut.zero_flag,
dut.sign_flag,
dut.branch,
dut.branch_taken

);

end

/////////////////////////////////////////////////////
// Register Dump
/////////////////////////////////////////////////////

always @(posedge clk)
begin

$display("------------------------------------------------");

$display("PC = %0d",dut.pc);

$display("R0 = %0d",dut.rf.r[0]);
$display("R1 = %0d",dut.rf.r[1]);
$display("R2 = %0d",dut.rf.r[2]);
$display("R3 = %0d",dut.rf.r[3]);

$display("Result = %0d",dut.result);

$display("ZF = %b",dut.zero_flag);
$display("SF = %b",dut.sign_flag);

$display("------------------------------------------------");

end

/////////////////////////////////////////////////////
// Data Memory Dump
/////////////////////////////////////////////////////

always @(posedge clk)
begin

$display("MEMORY");

$display("MEM[0] = %0d",dut.dmem.mem[0]);
$display("MEM[1] = %0d",dut.dmem.mem[1]);
$display("MEM[2] = %0d",dut.dmem.mem[2]);
$display("MEM[3] = %0d",dut.dmem.mem[3]);

end

/////////////////////////////////////////////////////
// Final Summary
/////////////////////////////////////////////////////

initial begin

#1990;

$display("");
$display("========================================");
$display(" CPU Verification Completed ");
$display("========================================");

end

endmodule