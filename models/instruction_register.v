module instruction__register
(
    inout [7:0]bus,
    input clk,load,drive,reset,
    output [7:0]stored_value
);

    reg [7:0]data;

    always@(posedge clk)
        begin
            if(reset)
                data <= 8'b0000_0000;
            else if(load)
                data <= bus;
        end
    
    assign stored_value = data;
    assign bus = (drive) ? data : 8'bz;
endmodule