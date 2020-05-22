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
      R_W = 1'bx; //s'obliga a que hi hagi un canvi en R_W 
    #5 Rst_cont = 1'b1;
       En_cont = 1'b1;
    wait(Out_cont == 4'b1000);
     #5 R_W = Sda;
     #1245 Enable_sda = 1'b1;
     #2550 Enable_sda = 1'b0;   
           
  end
     
  //ACK Pointer    
  always@(R_W) begin  //en cas d'escriptura
  if (R_W == 1'b0)  
    wait(Out_cont == 4'b0111)
      #5 Pointer[1] = Sda;  
    wait(Out_cont == 4'b1000)
      #5 Pointer[0] = Sda;
      #1245 Enable_sda = 1'b1; 
      #2550 Enable_sda = 1'b0;  
  end
  
  //ACK Byte/s escriptura
  always@(Pointer[0]) begin
    wait (Out_cont == 4'b1000)
    #23750 Enable_sda = 1'b1;
    #2995 Enable_sda = 1'b0; 
      if (Pointer[1] == 1'b1)  //en cas de dirigir-se al registre de 2 bytes, s'enviat� un altre ACK
        wait(Out_cont == 4'b1000)         
          #1250 Enable_sda = 1'b1; 
          #2550 Enable_sda = 1'b0;  
  end
      
  //Enviament de bytes de lectura
  always@(R_W) begin //en cas de lectura
  if (R_W == 1'b1)
    if (Pointer[1] == 1'b1) begin  //en cas que el registre setejat sigui el de 2 bytes
      wait(Out_cont == 4'b1001)
        #1305 Enable_sda = Temp[15];
        #2500 Enable_sda = Temp[14];
        #2500 Enable_sda = Temp[13];
        #2500 Enable_sda = Temp[12];
        #2500 Enable_sda = Temp[11];
        #2500 Enable_sda = Temp[10];
        #2500 Enable_sda = Temp[9];
        #2500 Enable_sda = Temp[8];
        #2950 Enable_sda = 1'b0;
        #2500 Enable_sda = Temp[7];
        #2500 Enable_sda = Temp[6];
        #2500 Enable_sda = Temp[5];
        #2500 Enable_sda = Temp[4];
        #2500 Enable_sda = Temp[3];
        #2500 Enable_sda = Temp[2];
        #2500 Enable_sda = Temp[1];
        #2500 Enable_sda = Temp[0];
        #2950 Enable_sda = 1'b0;  
    end
    else begin   //en cas que el registre setejat sigui el d'un byte
      wait(Out_cont == 4'b1001)
        #1305 Enable_sda = Config[7];
        #2500 Enable_sda = Config[6];
        #2500 Enable_sda = Config[5];
        #2500 Enable_sda = Config[4];
        #2500 Enable_sda = Config[3];
        #2500 Enable_sda = Config[2];
        #2500 Enable_sda = Config[1];
        #2500 Enable_sda = Config[0];
        #2950 Enable_sda = 1'b0;
    end
  end
  
    
    
    

endmodule
