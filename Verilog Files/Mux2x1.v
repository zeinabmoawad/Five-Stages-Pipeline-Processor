module Mux16Bit(a,b,sel,out);
input [15:0] a,b;
input sel;
output [15:0]out;
assign out=(sel)?b:a;
endmodule
