module Shift_PLSR_master(input [7:0] In,
input Load,
input Clk,
output reg Out);
  
  reg [7:0] temp =  8'b0;
  reg [3:0] Cont = 4'b0;

  always@(posedge Clk)
    if (Cont < 4'b1000 && !Load)
      Cont = Cont + 4'b0001;
    else begin
      if (Cont == 4'b1000)
        Cont = 4'b0;
      else
        Cont = Cont;
    end
  
  always@(posedge Clk)  //carga les dades en paral·lel
  if (Load && Cont == 4'b0)
      temp = In;
  else if (Load && Cont != 4'b0) begin
      temp = temp;
      Out = Out;
  end
  else begin   //sortida sèrie
    Out = temp[7];
    temp = {temp[6:0],1'b0};
  end
endmodule


