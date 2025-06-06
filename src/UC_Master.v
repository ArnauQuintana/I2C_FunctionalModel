module UC_Master(input Clk,
input Clk_scl,
input Rst,
input Start,
input RW,
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
  
  parameter IDLE = 5'b00000,  
            START = 5'b00001,  
            ADRESS = 5'b00010,  
            ACK_ADRESS = 5'b00011,  
            MSB_RD = 5'b00100, 
            ACK_MSB_RD = 5'b00101,  
            LSB_RD = 5'b00110, 
            NACK_LSB_RD = 5'b00111, 
            POINTER = 5'b01000,  
            ACK_POINTER = 5'b01001,  
            MSB_WR = 5'b01010, 
            ACK_MSB_WR = 5'b01011, 
            LSB_WR = 5'b01100, 
            ACK_LSB_WR = 5'b01101, 
            STOP = 5'b01110, 
            ERROR = 5'b01111, 
            REPEAT = 5'b10000; 
 
  always@(posedge Clk or negedge Rst)
    if (!Rst) state = IDLE;
    else      state = next;
      
  always@(state or Out_cont_data or Start or Out_cont_cycle or Datain_sda or Clk_scl or RW or Return or Pointer or Set_pointer) begin
  next = 4'bx;
  case(state)
    IDLE: if (Start) next = START;
          else       next = IDLE;
    START: if (Out_cont_cycle == 4'b0001) next = ADRESS;
           else next = START;
    ADRESS: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0101) next = ACK_ADRESS;
        else  next = ADRESS;
    ACK_ADRESS: if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && RW == 1'b0) next = POINTER;
        else if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && RW == 1'b1) next = MSB_RD;
        else if (Clk_scl == 1'b1 && Datain_sda == 1'b1) next = IDLE;
        else next = ACK_ADRESS; 
    MSB_RD: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0001 && Pointer[1:0] != 2'b01) next = ACK_MSB_RD;
        else if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0001 && Pointer[1:0] == 2'b01) next = NACK_LSB_RD;
        else  next = MSB_RD;
    ACK_MSB_RD: if (Out_cont_cycle == 4'b0001) next = LSB_RD;
        else next = ACK_MSB_RD;    
    LSB_RD: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0001) next = NACK_LSB_RD;
        else  next = LSB_RD;
    NACK_LSB_RD: if (Out_cont_cycle == 4'b0001) next = STOP;
        else next = NACK_LSB_RD;   
    POINTER: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0101) next = ACK_POINTER;
        else  next = POINTER;
    ACK_POINTER: if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && Set_pointer == 1'b0) next = MSB_WR;
        else if (Clk_scl ==1'b1 && Datain_sda == 1'b0 && Set_pointer == 1'b1) next = REPEAT; 
        else if (Clk_scl == 1'b1 && Datain_sda == 1'b1) next = ERROR;
        else next = ACK_POINTER; 
    MSB_WR: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0101) next = ACK_MSB_WR;
         else  next = MSB_WR;
    ACK_MSB_WR: if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && Pointer[1] == 1'b1) next = LSB_WR;
         else if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && Pointer[1] == 1'b0) next = STOP;
         else if (Clk_scl == 1'b1 && Datain_sda == 1'b1) next = ERROR;
         else next = ACK_MSB_WR; 
    LSB_WR: if (Out_cont_data == 4'b1000 && Out_cont_cycle == 4'b0101) next = ACK_LSB_WR;
         else  next = LSB_WR;
    ACK_LSB_WR: if (Clk_scl == 1'b1 && Datain_sda == 1'b0 && Out_cont_cycle == 4'b0011) next = STOP;
         else if (Clk_scl == 1'b1 && Datain_sda == 1'b1 && Out_cont_cycle == 4'b0011) next = ERROR;
         else next = ACK_LSB_WR; 
    STOP: if (Out_cont_cycle == 4'b0011) next = IDLE;
         else  next = STOP;
    ERROR: if (Out_cont_cycle == 4'b0101) next = IDLE;
         else  next = ERROR;
    REPEAT: if (Out_cont_cycle == 4'b0001 && Return == 1'b1) next = ADRESS;
         else next = REPEAT;
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
  Data_valid = 1'b0;          //informa al usuari quan la dada a la Data_out �s v�lida
  Error = 1'b0;
  Repeat = 1'b0;              //si = 1, indica que estem al estat per repetir Start
  case(state)
    IDLE: begin
    Ready = 1'b1;
    SelectPLSR = 3'b100; //carrego Save_adr a al ShiftSRPL
    end
    START:begin
    Enable_sda = 2'b01;       //provoco un negedge a Sda
    SelectPLSR = 3'b100;      //selecciono el registre del qual carregar les dades al shift register         
    if (Out_cont_cycle == 4'b0001)
      Load_shiftPLSR = 1'b0;
    else
      Load_shiftPLSR = 1'b1;   
    end
    ADRESS:begin
    Enable_sda = 2'b10;
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
      if (Out_cont_cycle == 4'b0001)
        Load_shiftPLSR = 1'b0;  //carrego dada a la sortida del shift 
      else
        Load_shiftPLSR = 1'b1;  //als dem�s cicles la dada es mant� estable a la sortida
    end
    ACK_ADRESS:begin
    Enable_clk = 2'b10;         //Scl segueix activat per rebre l'ACK
    end
    MSB_RD:begin
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
      if (Out_cont_cycle == 4'b0100 && Out_cont_data != 4'b0000)
        Load_shiftSRPL = 1'b1;  
      else
        Load_shiftSRPL = 1'b0;     
    end
    ACK_MSB_RD:begin
    Enable_clk = 2'b10;
    Enable_sda = 2'b01;       //provo un 0 a Sda activant el tri-state
    Data_valid = 1'b1;        //les dades a la sortida seran v�lides
    end
    LSB_RD:begin
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
      if (Out_cont_cycle == 4'b0100 && Out_cont_data != 4'b0000)
        Load_shiftSRPL = 1'b1;  
      else
        Load_shiftSRPL = 1'b0;      
    end
    NACK_LSB_RD:begin
    Enable_clk = 2'b10;
    Data_valid = 1'b1;
    end
    POINTER: begin
    Enable_sda = 2'b10;
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
    SelectPLSR = 3'b001; 
      if (Out_cont_cycle == 4'b0001)
        Load_shiftPLSR = 1'b0;  //carrego dada a la sortida del shift 
      else
        Load_shiftPLSR = 1'b1;  //als dem�s cicles la dada es mant� estable a la sortida
    end
    ACK_POINTER:begin
    Enable_clk = 2'b10;         //Scl segueix activat per rebre l'ACK
    end
    MSB_WR: begin
    Enable_sda = 2'b10;
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
    SelectPLSR = 3'b010;  
      if (Out_cont_cycle == 4'b0001)
        Load_shiftPLSR = 1'b0;  
      else
        Load_shiftPLSR = 1'b1;  
    end
    ACK_MSB_WR:begin
    Enable_clk = 2'b10; 
    end
    LSB_WR:begin
    Enable_sda = 2'b10;
    Enable_clk = 2'b10;
    En_cont_data = 1'b1;
    SelectPLSR = 3'b011;
      if (Out_cont_cycle == 4'b0001)
        Load_shiftPLSR = 1'b0;  
      else
        Load_shiftPLSR = 1'b1;  
    end  
    ACK_LSB_WR:begin
    Enable_clk = 2'b10;
    end
    STOP:begin
    if (Out_cont_cycle != 4'b0011)begin
      Enable_clk = 2'b10;
      Enable_sda = 2'b01;
    end
    else
      Enable_clk = 2'b00;
    end
    ERROR:begin
    Error = 1'b1;
    if (Out_cont_cycle != 4'b0010)begin
      Enable_clk = 2'b10;
      Enable_sda = 2'b01;
    end
    else
      Enable_clk = 2'b00;
    end
    REPEAT: begin
    Enable_clk = 2'b10;
    Repeat = 1'b1;
    SelectPLSR = 3'b100;
    if (Out_cont_cycle == 4'b0101 && Return == 1'b1) begin
      Enable_sda = 2'b01;
      Load_shiftPLSR = 1'b0;  //carrego l'adre�a al shift register
    end
    else if (Out_cont_cycle == 4'b0100 && Return == 1'b1) begin
      Enable_sda = 2'b01;
      Load_shiftPLSR = 1'b1;
    end
    else begin 
      Enable_sda = 2'b00;
      Load_shiftPLSR = 1'b1;
    end
    end
    
 endcase
 end
endmodule