module Contador_rst(input En,
input Rst,
input Clk,
output reg [3:0] Out = 4'b0);

  parameter M = 4'b1000;
  
  always@(posedge Clk or negedge Rst)
    if (!Rst)
		Out <= 4'b0000;
	 else if (!En)
      Out <= 4'b0000;
    else begin
      if (Out == M)
        Out <= 4'b0001;
      else
        Out <= Out + 4'b0001;
    end
    
endmodule  


