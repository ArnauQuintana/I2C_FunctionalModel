module UC_LM75x_fm(input Start,
  input Stop,
  input Clk,
  input [7:0] Save_adr,
  input [7:0] Save_pointer,
  output reg Error,
  output reg Enable_sda_ack,
  output reg En_cont_data,
  input Datain_sda,
  input Datain_scl,
  output reg Load_shiftSRPL_adr,
  output reg Load_shiftSRPL_data,
  output reg Load_shiftSRPL_pointer,
  output reg Ready,
  input Rst,
  input [3:0] Out_cont_cycle,
  input [3:0] Out_cont_data,
  output reg Load_shiftPLSR,
  output reg Enable_data);
  
  reg [3:0] state,next;
  
  parameter Adress = 7'b1001101,
            S0 = 4'b0000,  //IDLE
            S1 = 4'b0001,  //Adress
            S2 = 4'b0010,  //ACK Adress
            S3 = 4'b0011,  
            S4 = 4'b0100, 
            S5 = 4'b0101,  
            S6 = 4'b0110,  
            S7 = 4'b0111,  //Pointer
            S8 = 4'b1000,  //ACK Pointer
            S9 = 4'b1001,  //Primer byte WR
            S10 = 4'b1010, //ACK primer byte
            S11 = 4'b1011,
            S12 = 4'b1100,
            S13 = 4'b1101,
            S14 = 4'b1110,
            S15 = 4'b1111; 
  
  always@(posedge Clk or negedge Rst)
    if (!Rst) state = S0;
    else      state = next;
      
  always@(state or Out_cont_cycle or Out_cont_data or Save_adr or Start or Stop or Datain_scl or Datain_sda) begin
  next = 4'bx;
  case(state)
    S0: if (Start) next = S1;
        else       next = S0;
    S1: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0010) next = S2;
        else      next = S1;
    S2: if (Out_cont_cycle == 4'b0010 && Save_adr[7:1] == Adress && Save_adr[0] == 1'b0) next = S7;
        else if (Out_cont_cycle == 4'b0010 && Save_adr[7:1] == Adress && Save_adr[0] == 1'b1) next = S3;
        else if (Out_cont_cycle == 4'b0010 && Save_adr[7:1] != Adress) next = S0;
        else  next = S2;
    S7: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0001) next = S8;
        else  next = S7;
    S8: if (Out_cont_cycle == 4'b0101 && Save_pointer[7:2] == 7'b0) next = S9;
        else  next = S8;
    S9: if (Start) next = S1;
        else if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0010) next = S10;
        else      next = S9;
    
  endcase
  end        
          
  always@(state or Out_cont_cycle or Out_cont_data or Datain_scl or Save_adr)begin
  En_cont_data = 1'b0;
  Enable_sda_ack = 1'b0;
  Ready = 1'b0;
  Load_shiftSRPL_adr = 1'b0;
  Load_shiftSRPL_data = 1'b0;
  Load_shiftSRPL_pointer = 1'b0;
  Enable_data = 1'b0;
  Load_shiftPLSR = 1'b1; 
  Error = 1'b0;
  case(state)
  S0:begin
  Ready = 1'b1;  //al estat IDLE, l'slave està preparat per rebre o enviar dades
  end
  S1:begin
  En_cont_data = 1'b1;
    if (Datain_scl && Out_cont_cycle == 4'b0101)
      Load_shiftSRPL_adr = 1'b1;   //al complir-se la condició, es concatena l'entrada del shift amb el que hi havia
    else
      Load_shiftSRPL_adr = 1'b0;   //si no es compleix, es manté el registre tal com està en el moment que es trobi
  end
  S2:begin
    if (Save_adr[7:1] == Adress) //si l'adreça coincideix, s'envia l'ACK
      Enable_sda_ack = 1'b1;
    else
      Enable_sda_ack = 1'b0;
  end
  S7:begin
  En_cont_data = 1'b1;
    if (Datain_scl && Out_cont_cycle == 4'b0101)
      Load_shiftSRPL_pointer = 1'b1;   //al complir-se la condició, es concatena l'entrada del shift amb el que hi havia
    else
      Load_shiftSRPL_pointer = 1'b0;   //si no es compleix, es manté el registre tal com està en el moment que es trobi
  end
  S8:begin
  if (Save_pointer[7:2] == 7'b0) //si els primers
      Enable_sda_ack = 1'b1;
    else
      Enable_sda_ack = 1'b0;
  end
  S9:begin
  end
   
   
  
  endcase
  end

endmodule

  