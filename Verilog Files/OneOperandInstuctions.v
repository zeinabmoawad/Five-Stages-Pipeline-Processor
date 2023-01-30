module Not(input[15:0] Rds,input Enable,input [2:0]previousflags,output reg[15:0] Out,output reg [2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = ~Rds;
//Assign zero flag to one if out is zeros
if(Out == 15'b0) begin
Ccr[0] = 1'b1;
end else begin
Ccr[0] = 1'b0;
end
//Assign negative flag to one if out is less than zero
if(Out[15] == 1'b1) begin
Ccr[1] = 1'b1;
end else begin
Ccr[1] = 1'b0;
end
Ccr[2]=previousflags[2];
end else begin
Out = 16'bz;
Ccr=3'bz;
end
end
endmodule

module SETC(input Enable,input[2:0] previousflags,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Ccr[2]=1'b1;
Ccr[0]=previousflags[0];
Ccr[1]=previousflags[1];
end
else begin
Ccr=3'bz;
end
end
endmodule

module CLRC(input Enable,input[2:0] previousflags,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Ccr[2]=1'b0;
Ccr[0]=previousflags[0];
Ccr[1]=previousflags[1];
end
else begin
Ccr=3'bz;
end
end
endmodule

module INC(input[15:0] Rds,input Enable,input[2:0] previousflags,output reg[15:0] Out,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = Rds+1;
//Assign zero flag to one if out is zeros
if(Out == 15'b0) begin
Ccr[0] = 1'b1;
end else begin
Ccr[0] = 1'b0;
end
//Assign negative flag to one if out is less than zero
if(Out[15] == 1'b1) begin
Ccr[1] = 1'b1;
end else begin
Ccr[1] = 1'b0;
end
Ccr[2]=previousflags[2];
end else begin
Out = 16'bz;
Ccr=3'bz;
end
end
endmodule

module DEC(input[15:0] Rds,input Enable,input[2:0] previousflags,output reg[15:0] Out,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = Rds-1;
//Assign zero flag to one if out is zeros
if(Out == 15'b0) begin
Ccr[0] = 1'b1;
end else begin
Ccr[0] = 1'b0;
end
//Assign negative flag to one if out is less than zero
if(Out[15] == 1'b1) begin
Ccr[1] = 1'b1;
end else begin
Ccr[1] = 1'b0;
end
Ccr[2]=previousflags[2];
end else begin
Out = 16'bz;
Ccr=3'bz;
end
end
endmodule


module OUT(input[15:0] Rds,input Enable,input[2:0] previousflags,output reg[15:0] Out,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = Rds;
Ccr = previousflags;
end
else begin
Out = 16'bz;
Ccr = 3'bz;
end
end
endmodule
module IN(input[15:0] Rds,input Enable,input[2:0] previousflags,output reg[15:0] Out,output reg[2:0] Ccr);
always@* begin
if(Enable == 1'b1) begin
Out = Rds;
Ccr = previousflags;
end
else begin
Out = 16'bz;
Ccr = 3'bz;
end
end
endmodule