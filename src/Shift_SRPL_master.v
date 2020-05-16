module Shift_SRPL_master(input Clk,
input Load,
input In,
output [7:0] Out);
  
  reg [7:0] temp;

  always@(posedge Clk)  //carga les dades en sèrie
  if(Load) 
    temp <= {temp[6:0],In};
  else                  //sortida paral·lel
    temp <= temp;

  assign Out = temp;

endmodule
