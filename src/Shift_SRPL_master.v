module Shift_SRPL_master(input Clk,
input Rst, 
input Load,
input In,
output [7:0] Out);
  
  reg [7:0] temp;

  always@(posedge Clk or negedge Rst)  
  if(!Rst)
    temp <= 8'b0;
  else if(Load) 
    temp <= {temp[6:0],In}; //carga les dades en sèrie
  else    
    temp <= temp;  

  assign Out = temp;  //sortida paral·lel
  
endmodule
