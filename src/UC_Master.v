module UC_Master(input Clk,
input Clk_scl,
input Rst,
input Start,
input R_W,
input Datain_sda,
input [7:0] Pointer,
input Set_pointer,
input Return,
output reg Repeat,
input [3:0] Out_cont_cycle,
input [3:0] Out_cont_data,
output reg En_cont_data,
output reg Load_shiftPLSR,
output reg Load_shiftSRPL,
output reg [1:0] Enable_sda,
output reg [2:0] SelectPLSR,
output reg [1:0] Enable_clk,
output reg Ready,
output reg Data_valid,
output reg Error);
  
  reg [4:0] state,next;
  
  parameter S0 = 5'b0000,  //IDLE
            S1 = 5'b0001,  //START
            S2 = 5'b0010,  //ADRESS
            S3 = 5'b0011,  //ACK Adress
            S4 = 5'b0100,  //MSB RD
            S5 = 5'b0101,  //ACK MSB RD
            S6 = 5'b0110,  //LSB RD
            S7 = 5'b0111,  //NACK LSB RD
            S8 = 5'b1000,  //POINTER
            S9 = 5'b1001,  //ACK POINTER
            S10 = 5'b1010, //MSB BYTE WR
            S11 = 5'b1011, //ACK MSB WR
            S12 = 5'b1100, //LSB WR
            S13 = 5'b1101, //ACK LSB WR
            S14 = 5'b1110, //STOP
            S15 = 5'b1111, //ERROR 
            S16 = 5'b10000; //REPEAT START 
 
  always@(posedge Clk or negedge Rst)
    if (!Rst) state = S0;
    else      state = next;
      
  always@(state or Out_cont_data or Start or Out_cont_cycle or Datain_sda or Clk_scl or R_W or Return or Pointer or Set_pointer) begin
  next = 4'bx;
  case(state)
    S0: if (Start) next = S1;
        else       next = S0;
    S1: if (Out_cont_cycle == 4'b0010) next = S2;
        else  next = S1;
    S2: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0001) next = S3;
        else  next = S2;
    S3: if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && R_W == 1'b0) next = S8;
        else if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && R_W == 1'b1) next = S4;
        else if (Clk_scl == 1'b1 && Datain_sda == 1'b1) next = S0;
        else next = S3; 
    S4: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0010 && Pointer[1:0] != 2'b01) next = S5;
        else if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0010 && Pointer[1:0] == 2'b01) next = S7;
        else  next = S4;
    S5: if (Out_cont_cycle == 4'b0010) next = S6;
        else next = S5;    
    S6: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0010) next = S7;
        else  next = S6;
    S7: if (Out_cont_cycle == 4'b0010) next = S14;
        else next = S7;   
    S8: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0001) next = S9;
        else  next = S8;
    S9: if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && Set_pointer == 1'b0) next = S10;
        else if (Clk_scl ==1'b1 && Datain_sda == 1'b0 && Set_pointer == 1'b1) next = S16; 
        else if (Clk_scl == 1'b1 && Datain_sda == 1'b1) next = S15;
        else next = S9; 
    S10: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0001) next = S11;
         else  next = S10;
    S11: if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && Pointer[1] == 1'b1) next = S12;
         else if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && Pointer[1] == 1'b0) next = S14;
         else if (Clk_scl == 1'b1 && Datain_sda == 1'b1) next = S15;
         else next = S11; 
    S12: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0001) next = S13;
         else  next = S12;
    S13: if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && Out_cont_cycle == 4'b0101) next = S14;
         else if (Clk_scl == 1'b1 && Datain_sda == 1'b1 && Out_cont_cycle == 4'b0101) next = S15;
         else next = S13; 
    S14: if (Out_cont_cycle == 4'b0101) next = S0;
         else  next = S14;
    S15: if (Out_cont_cycle == 4'b0101) next = S0;
         else  next = S15;
    S16: if (Out_cont_cycle == 4'b0001 && Return == 1'b1) next = S2;
         else next = S16;
  endcase
  end    

  always@(state or Out_cont_cycle or Out_cont_data or Clk_scl or Return) begin
  Enable_sda = 2'b00;
  Enable_clk =  2'b00;
  En_cont_data = 1'b0;
  SelectPLSR = 3'b000;
  Load_shiftPLSR = 1'b1;
  Load_shiftSRPL = 1'b0;
  Ready = 1'b0;
  Data_valid = 1'b0;  //informa al usuari quan la dada a la Data_out és vàlida
  Error = 1'b0;
  Repeat = 1'b0; //si = 1, indica que estem al estat per repetir Start
  case(state)
    S0: begin
    Ready = 1'b1;
    SelectPLSR = 3'b100; //carrego Save_adr a al ShiftSRPL
    end
    S1:begin
    Enable_sda = 2'b01; //provoco un negedge a Sda
    SelectPLSR = 3'b100;
      if (Out_cont_cycle == 4'b0010) 
       Load_shiftPLSR = 1'b0;   //carrego dada a la sortida del shift un cicle abans    
      else 
       Load_shiftPLSR = 1'b1;
    end
    S2:begin
    Enable_sda = 2'b10;
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
      if (Out_cont_cycle == 4'b0010)
        Load_shiftPLSR = 1'b0;  //carrego dada a la sortida del shift 
      else
        Load_shiftPLSR = 1'b1;  //als demés cicles la dada es manté estable a la sortida
    end
    S3:begin
    Enable_clk = 2'b10; //Scl segueix activat per rebre l'ACK
    end
    S4:begin
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
      if (Out_cont_cycle == 4'b0101 && Out_cont_data != 4'b0000)
        Load_shiftSRPL = 1'b1;  
      else
        Load_shiftSRPL = 1'b0;     
    end
    S5:begin
    Enable_clk = 2'b10;
    Enable_sda = 2'b01;
    Data_valid = 1'b1;
    end
    S6:begin
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
      if (Out_cont_cycle == 4'b0101 && Out_cont_data != 4'b0000)
        Load_shiftSRPL = 1'b1;  
      else
        Load_shiftSRPL = 1'b0;      
    end
    S7:begin
    Enable_clk = 2'b10;
    Data_valid = 1'b1;
    end
    S8: begin
    Enable_sda = 2'b10;
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
    SelectPLSR = 3'b001;
      if (Out_cont_cycle == 4'b0010)
        Load_shiftPLSR = 1'b0;  //carrego dada a la sortida del shift 
      else
        Load_shiftPLSR = 1'b1;  //als demés cicles la dada es manté estable a la sortida
    end
    S9:begin
    Enable_clk = 2'b10; //Scl segueix activat per rebre l'ACK
    end
    S10: begin
    Enable_sda = 2'b10;
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
    SelectPLSR = 3'b010;
      if (Out_cont_cycle == 4'b0010)
        Load_shiftPLSR = 1'b0;  
      else
        Load_shiftPLSR = 1'b1;  
    end
    S11:begin
    Enable_clk = 2'b10; 
    end
    S12:begin
    Enable_sda = 2'b10;
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
    SelectPLSR = 3'b011;
      if (Out_cont_cycle == 4'b0010)
        Load_shiftPLSR = 1'b0;  
      else
        Load_shiftPLSR = 1'b1;  
    end  
    S13:begin
    Enable_clk = 2'b10;
    end
    S14:begin
    if (Out_cont_cycle != 4'b0101)begin
      Enable_clk = 2'b10;
      Enable_sda = 2'b01;
    end
    else
      Enable_clk = 2'b00;
    end
    S15:begin
    Error = 1'b1;
    if (Out_cont_cycle != 4'b0101)begin
      Enable_clk = 2'b10;
      Enable_sda = 2'b01;
    end
    else
      Enable_clk = 2'b00;
    end
    S16: begin
    Enable_clk = 2'b10;
    Repeat = 1'b1;
    SelectPLSR = 3'b100;
    if ((Out_cont_cycle == 4'b0101 || Out_cont_cycle == 4'b0001) && Return == 1'b1)
      Enable_sda = 2'b01;
    else 
      Enable_sda = 2'b00;
    end
    
 endcase
 end
endmodule
  
  
