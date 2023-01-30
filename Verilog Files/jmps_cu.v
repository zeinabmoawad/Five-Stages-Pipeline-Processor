module jumpsCU (
    input clk, rst, branch,
    input [1:0] jtype,
    input [2:0] ccr,
    input [15:0] rdst,
    output[31:0] pc,
    output taken
  );
  parameter jz = 0,
  jmp = 3,
  jn = 1,
  jc = 2;
  assign taken = (branch === 1'bx)? 1'b0:(branch == 1'b0) ? 1'b0 : (jtype == jmp) || (jtype == jz && ccr[0] == 1'b1) || (jtype == jn && ccr[2] == 1'b1) || (jtype == jc && ccr[3] == 1'b1);
  assign pc = {16'b0, rdst};

endmodule


////////To be moved to control unit/////////////////////////
//branch = opCode[4] & ~opCode[3] & opCode[2]
//if branch && taken ==> change pc to the output of jmpsCU