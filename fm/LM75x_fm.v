module LM75x_fm(inout Sda,
input Scl,
input Set_pointer);

  reg [7:0] Config = 8'b00000101;
  reg [15:0] Temp = 16'b1001100100110001;
  
  reg Enable_sda = 1'b0;
  bufif1(Sda,1'b0,Enable_sda);
  
  reg Stop,Start;
  always@(posedge Sda)
    Stop = Scl;
  always@(negedge Sda)
    Start = Scl;
      
  wire [3:0] Out_cont;    
  reg En_cont,Rst_cont;
  Contador_rst #(9) Contador(.En(En_cont),
  .Rst(Rst_cont),
  .Clk(Scl),
  .Out(Out_cont));

  reg R_W;
  reg [1:0] Pointer;    
  initial begin
  En_cont = 1'b0;
  R_W = 1'bx;
  end
  
  always@(posedge Stop) begin
    En_cont = 1'b0;
  end
  
  //ACK Adress
  always@(posedge Start) begin
    Rst_cont = 1'b0;
    R_W = 1'bx;
    #5 Rst_cont = 1'b1;
       En_cont = 1'b1;
    wait(Out_cont == 4'b1000);
     #5 R_W = Sda;
     #1245 Enable_sda = 1'b1;
     #2550 Enable_sda = 1'b0;   
           
  end
     
  //ACK Pointer    
  always@(negedge R_W) begin  
    wait(Out_cont == 4'b0111)
      #5 Pointer[1] = Sda;  
    wait(Out_cont == 4'b1000)
      #5 Pointer[0] = Sda;
      #1245 Enable_sda = 1'b1; //espera mig per�ode d'Scl per enviar l'ACK
      #2550 Enable_sda = 1'b0;  
  end
  
  //ACK Bytes escriptura
  always@(Pointer[0]) begin
    wait (Out_cont == 4'b1000)
    #23750 Enable_sda = 1'b1;
    #2995 Enable_sda = 1'b0; 
      if (Pointer[1] == 1'b1)
        wait(Out_cont == 4'b1000)         
          #1250 Enable_sda = 1'b1; 
          #2550 Enable_sda = 1'b0;  
  end
      
     
    
  
  
  
    
    
    

endmodule
