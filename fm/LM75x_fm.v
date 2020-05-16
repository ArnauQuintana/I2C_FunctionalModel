module LM75x_fm(inout Sda,
input Scl);

  reg Enable_sda = 1'b0;
  bufif1(Sda,1'b0,Enable_sda);
  
  reg Stop;
  always@(posedge Sda)
    Stop = Scl;
  
  integer i = 0;
  always@(posedge Scl or posedge Stop)
    if (i<9) begin
      if (Stop)
        i = 1;
      else
        i = i + 1;
    end
    else if (i==9)
      i = 1;
    else
      i = i;

  reg R_W,Pointer;
  integer a = 0;
  always@(i)
    if (i==9 && a==0) begin
      R_W = Sda; 
      if (Sda == 1'b0)
      a = a + 1;
      else 
      a = a + 4; 
      #1250 Enable_sda = 1'b1;
      #2500 Enable_sda = 1'b0;
    end
   else if (i == 9 && a == 1) begin
     a = a + 1;
     Pointer = Sda;
     #1250 Enable_sda = 1'b1;
     #3000 Enable_sda = 1'b0;  
   end
  else if (i == 9 && a == 2)begin
     if (Pointer == 1'b1)
       a = 0;
     else
       a = a + 1;
     #1250 Enable_sda = 1'b1;
     #3000 Enable_sda = 1'b0;
   end
  else if (i == 9 && a == 3) begin
     a = 0;
     #1250 Enable_sda = 1'b1;
     #2500 Enable_sda = 1'b0;
  end
  
  












  

endmodule
