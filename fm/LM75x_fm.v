module LM75x_fm(inout Sda,
input Scl,
input Rst);

  reg [15:0] Temp = 16'b1001100100110001;
  
  reg Enable_sda = 1'b0;
  bufif1(Sda,1'b0,Enable_sda);
  
  reg Start;
  always@(negedge Sda)
    Start = Scl;
      
  wire [3:0] Out_cont;    
  reg En_cont,Rst_cont;
  Contador_rst #(9) Contador(.En(En_cont),
  .Rst(Rst_cont),
  .Clk(Scl),
  .Out(Out_cont));

  reg R_W;
  reg [1:0] Pointer = 2'b10;//per defecte seria el reg 00 (només RD de 2Bytes), el nostre serà el reg de 2 bytes
  initial begin
  En_cont = 1'b0;
  R_W = 1'bx;
  end
  
  integer Times;
  always@(posedge Start) begin
    Rst_cont = 1'b0;
    #5 Rst_cont = 1'b1;
    En_cont = 1'b1;
    Times = 0;
  end

//Informa del moment de la simulació en que ens trobem
  always@(posedge Scl)
  if (R_W == 1'b0)begin
    if(Out_cont == 4'b1001)
      Times = Times + 1; 
    else
      Times = Times; 
  end
  else begin
    if(Out_cont == 4'b1000)
      Times = Times + 1; 
    else
      Times = Times; 
  end  
    
  //ACK  Adress  
  always@(posedge Scl) 
    if (Times == 0)
      wait(Out_cont == 4'b1000) begin
      #5 R_W = Sda;
      if (R_W == 1'b0) begin
      #1245 Enable_sda = 1'b1;
      #2500 Enable_sda = 1'b0;
      end
      else begin 
      #1745 Enable_sda = 1'b1;
      #2500 Enable_sda = 1'b0;    
      end
      end
  
  //Pointer + ACK Pointer
  always@(posedge Scl)
  if (R_W == 1'b0)begin
    if (Times == 1) begin
      wait(Out_cont == 4'b0111) 
        Pointer[1] = Sda;
      wait(Out_cont == 4'b1000) begin
      #5 Pointer[0] = Sda;
      #1250 Enable_sda = 1'b1;
      #2500 Enable_sda = 1'b0;
      end
    end
  end
      
  //ACK MSB WR
  always@(posedge Scl)
  if (R_W == 1'b0) begin  
    if(Times == 2 && R_W == 1'b0)
      wait(Out_cont == 4'b1000) begin
      #1250 Enable_sda = 1'b1;
      #2600 Enable_sda = 1'b0;
      end
  end
  
  //ACK LSB WR
  always@(posedge Scl)
  if(R_W == 1'b0) begin 
    if(Times == 3 && R_W == 1'b0 && Pointer[1] == 1'b1)
      wait(Out_cont == 4'b1000) begin
      #1250 Enable_sda = 1'b1;
      #2500 Enable_sda = 1'b0;
      end
  end
  
  //ACK MSB RD + ACK LSB RD
  always@(posedge Scl) 
  if (R_W == 1'b1)  begin
    if(Times == 1) 
      wait(Out_cont == 4'b1001) begin
      #1750 Enable_sda = Temp[15];
      #2500 Enable_sda = Temp[14];
      #2500 Enable_sda = Temp[13];
      #2500 Enable_sda = Temp[12];
      #2500 Enable_sda = Temp[11];
      #2500 Enable_sda = Temp[10];
      #2500 Enable_sda = Temp[9];
      #2500 Enable_sda = Temp[8];
      #2500 Enable_sda = 1'b0;
      end
    else if(Times == 2 && Pointer[1] == 1'b1) begin
      #1750 Enable_sda = Temp[7];
      #2500 Enable_sda = Temp[6];
      #2500 Enable_sda = Temp[5];
      #2500 Enable_sda = Temp[4];
      #2500 Enable_sda = Temp[3];
      #2500 Enable_sda = Temp[2];
      #2500 Enable_sda = Temp[1];
      #2500 Enable_sda = Temp[0];
      #2500 Enable_sda = 1'b0;
    end
  end
  
  
  
  
  
      
  
      
           
 
 
  
  
  
      
  
  
    
    
    

endmodule
