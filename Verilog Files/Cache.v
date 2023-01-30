
module Memory #(parameter addBusWidth = 32, width = 16, instrORdata) (  //instr = 1  data = 0
    clk, rst, memR, memWR, addR, addWR, dataWR, dataR  
);
    input clk, rst, memR, memWR;
    input [width - 1 : 0] dataWR;
    input [addBusWidth - 1 : 0] addR, addWR;
    output reg [width - 1 : 0] dataR;
    reg [width - 1 : 0] memory [0 : 2**addBusWidth - 1];
    integer i;

    always @(negedge clk , posedge rst) begin
        if(rst)
        begin
            if(instrORdata) begin
                $readmemb("Memory.mif", memory);
            end
            else begin
                $readmemb("data.mif", memory);
            end
        end
        else if (~clk & memWR) begin  //write
            memory[addWR] = dataWR;
        end
    end

    //asynch reading
    // assign dataR =  memory[addR];

    always @* begin   //read
        if (memR & ~rst) begin
            dataR = memory[addR];
        end
    end

endmodule