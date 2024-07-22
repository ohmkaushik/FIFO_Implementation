`timescale 1ns / 1ps
module syn_fifo_tb();
parameter clk_period = 10;
reg clk,rst_n;
reg wr_en_i,rd_en_i;
reg [7:0] data_i;

wire[7:0] data_o;
wire full_o,empty_o;
syn_fifo SYN_FIFO(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en_i(wr_en_i),
    .data_i(data_i),
    .rd_en_i(rd_en_i),
    .data_o(data_o),
    .full_o(full_o),
    .empty_o(empty_o)
);

integer i=1'b0;

initial begin 
clk=1'b1;
end
always #(clk_period/2) clk= ~clk;

initial begin
    rst_n = 1'b1;
    
    wr_en_i = 1'b0;
    rd_en_i = 1'b0;
    
    data_i = 8'b0;
    
    #clk_period;
    rst_n = 1'b0;
    
     #clk_period;
    rst_n = 1'b1;
    
    //write data
    wr_en_i = 1'b1;
    rd_en_i = 1'b0;
    
    for(i=0; i<8; i=i+1)begin
         data_i = i;
         #clk_period;
      end
      
     //read data
     wr_en_i =1'b0;
     rd_en_i =1'b1;
     
     for(i=0; i<8; i=i+1) begin
     #clk_period;
     end
     
     //write data
      wr_en_i = 1'b1;
    rd_en_i = 1'b0;
    
    for(i=0; i<8; i=i+1)begin
         data_i = i;
         #clk_period;
      end
      
      #clk_period;
      #clk_period;
      #clk_period;
end
endmodule
