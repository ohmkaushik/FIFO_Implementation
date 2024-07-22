`timescale 1ns / 1ps

module asyn_fifo_tb();

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    
    reg wr_clk, rd_clk, reset, wr_en, rd_en;
    reg [DATA_WIDTH-1:0] wr_data;
    wire [DATA_WIDTH-1:0] rd_data;
    wire full, empty;

    asyn_fifo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) uut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .reset(reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    // Clock Generation
    always #5 wr_clk = ~wr_clk;
    always #7 rd_clk = ~rd_clk;

    initial begin
        // Initialize inputs
        wr_clk = 0;
        rd_clk = 0;
        reset = 1;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;
        
        // Reset the FIFO
        #10 reset = 0;

        // Write data to the FIFO
        wr_data = 8'hAA; wr_en = 1;
        #10 wr_data = 8'hBB;
        #10 wr_data = 8'hCC;
        #10 wr_en = 0;

        // Read data from the FIFO
        #30 rd_en = 1;
        #20 rd_en = 0;

        // Finish simulation
        #300 $finish;
    end

    initial begin
        $monitor("Time: %0t | wr_data: %h | rd_data: %h | full: %b | empty: %b", 
                 $time, wr_data, rd_data, full, empty);
    end

endmodule
