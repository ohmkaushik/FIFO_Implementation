`timescale 1ns / 1ps
module asyn_fifo #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 4)
(
    input wire wr_clk, 
    input wire rd_clk,
    input wire reset,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] wr_data,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire full,
    output wire empty
);

    reg [DATA_WIDTH-1:0] fifo_mem [0:(1<<ADDR_WIDTH)-1];
    reg [ADDR_WIDTH:0] wr_ptr = 0, rd_ptr = 0;
    reg [ADDR_WIDTH:0] wr_ptr_gray = 0, rd_ptr_gray = 0;
    reg [ADDR_WIDTH:0] wr_ptr_gray_rdclk = 0, rd_ptr_gray_wrclk = 0;

    // FIFO Write Logic
    always @(posedge wr_clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
        wr_ptr_gray <= wr_ptr ^ (wr_ptr >> 1);
    end

    // FIFO Read Logic
    always @(posedge rd_clk or posedge reset) begin
        if (reset) begin
            rd_ptr <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;
        end
        rd_ptr_gray <= rd_ptr ^ (rd_ptr >> 1);
    end

    // Synchronize Write Pointer to Read Clock Domain
    always @(posedge rd_clk or posedge reset) begin
        if (reset) begin
            wr_ptr_gray_rdclk <= 0;
        end else begin
            wr_ptr_gray_rdclk <= wr_ptr_gray;
        end
    end

    // Synchronize Read Pointer to Write Clock Domain
    always @(posedge wr_clk or posedge reset) begin
        if (reset) begin
            rd_ptr_gray_wrclk <= 0;
        end else begin
            rd_ptr_gray_wrclk <= rd_ptr_gray;
        end
    end

    // Generate Empty and Full Flags
    assign empty = (rd_ptr_gray == wr_ptr_gray_rdclk);
    assign full = ((wr_ptr[ADDR_WIDTH-1:0] == rd_ptr_gray_wrclk[ADDR_WIDTH-1:0]) &&
                   (wr_ptr[ADDR_WIDTH] != rd_ptr_gray_wrclk[ADDR_WIDTH]));

    // Read Data
    assign rd_data = fifo_mem[rd_ptr[ADDR_WIDTH-1:0]];

endmodule

