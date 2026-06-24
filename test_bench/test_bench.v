`timescale 1ns/1ps

module test_bench;

reg load_acc;       //loads value from IR/RAM to ACC
reg store;          // stores ACC value into RAM
reg add;            //performs the add operation in ALU nd stores it in ACC only
reg sub;            //performs the subtract operation in ALU and stores it in ACC only
reg load_b;          //loads value from IR/RAM to B
reg jump;           //jumps the PC to the desired address
reg drive_acc;      //display the value of ACC
reg halt;            //stop the program

wire [7:0]bus;

reg load_ir,drive_ir,reset_ir;
reg [7:0]bus_tb;
reg bus_drive;

reg clk,reset_registers,drive_b,alu_drive;
reg [1:0]op;         //opcode for which operation to use in the ALU
wire [7:0]ALU_out;

reg wr,switch;          // internal variables for RAM
reg pc_out,ce,reset_pc; // internal variables for PC
wire [7:0]stored_value;

    assign bus = (bus_drive) ? bus_tb : 8'bz;

    bus_system b1(.bus(bus),.clk(clk),.reset(reset_registers),.load_acc(load_acc),.drive_acc(drive_acc),
    .load_b(load_b),.drive_b(drive_b),.alu_drive(alu_drive),.op(op),.ALU_out(ALU_out));

    PC_model pc(.bus(bus),.pc_out(pc_out),.ce(ce),.jump(jump),.clk(clk),.reset(reset_pc));
    
    ram_model ram(.clk(clk),.wr(wr),.bus(bus),.switch(switch));
    
    instruction__register ir(.bus(bus),.clk(clk),.load(load_ir),.drive(drive_ir),.reset(reset_ir),.stored_value(stored_value));

    initial
        begin
            clk = 0;
            forever #5 clk = ~clk;
        end

    initial
        begin
            load_acc = 1'b0; 
            store = 1'b0;          
            add = 1'b0;           
            sub = 1'b0;            
            load_b = 1'b0;          
            jump = 1'b0;           
            drive_acc = 1'b0;     
            halt = 1'b0;
            reset_registers = 1'b1; //resets are on 
            load_b = 1'b0;
            drive_b = 1'b0;
            alu_drive = 1'b0;
            switch = 1'b0;          //bus is zz;
            wr=1'b1;
            pc_out = 1'b0;
            reset_pc = 1'b1;        //resets are on 
            bus_drive = 1'b0;
            bus_tb = 8'b0000_0000;
            reset_ir = 1'b1;        //resets are on 
            op = 2'b00;
            load_ir = 1'b0;
            drive_ir = 1'b0;
            ce = 1'b0;
            
            #11;

            pc_out = 1'b1;
            wr = 1'b1;              //read
            reset_ir = 1'b0;
            reset_registers = 1'b0;     //bus is 00;
            reset_pc = 1'b0;

            #10;

            pc_out =1'b0;           //bus value should come as 0f
            wr = 1'b0;              //write
            ce = 1'b1;              //count enable
            load_ir =1'b1;          // ir takes the input

            #10;

            drive_ir = 1'b1;
            load_ir = 1'b0;         //bus is 0f
            wr = 1'b1;              //read
            load_acc = 1'b1;
            ce = 1'b0;

            #10;

            drive_ir = 1'b0;
            pc_out = 1'b1;          // bus is 01
            wr = 1'b1;              //read;
            load_acc = 1'b0;

            #10;

            pc_out = 1'b0;
            wr = 1'b0;              //write;
            load_ir = 1'b1;         // bus value should be 0e
            ce = 1'b1;

            #10;

            drive_ir = 1'b1;
            wr = 1'b1;              //read;
            load_ir = 1'b0;         // bus is 0e
            load_b = 1'b1;
            ce = 1'b0;

            #10;

            drive_ir = 1'b0;        //bus is 0f + 0e = 1d;
            load_b = 1'b0;
            alu_drive = 1'b1;

            #10;

            alu_drive = 1'b0;       // bus is zz
            op = 2'b01;

            #10;

            bus_drive = 1'b1;
            bus_tb = 8'b0000_0111;      // bus is 07
            jump = 1'b1;

            #10;

            bus_drive = 1'b0;
            jump = 1'b0;                // bus is 07
            pc_out = 1'b1;
            wr = 1'b1;

            #10;

            pc_out = 1'b0;
            wr = 1'b0;                  // bus is 03
            load_ir = 1'b1;

            #10;

            load_ir = 1'b0;             // bus is 03;
            wr = 1'b1;
            drive_ir = 1'b1;
            load_b = 1'b1;

            #10;

            load_b = 1'b0;              // bus is 0f - 03 = 0c
            drive_ir = 1'b0;
            alu_drive = 1'b1;

            #10;

            alu_drive = 1'b0;

            $stop;
        end
endmodule
            


            
            











