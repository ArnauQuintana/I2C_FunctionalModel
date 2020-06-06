module I2C_cntr_fm(
output reg [6:0] Adr,
output reg [7:0] Pointer,
output reg Set_pointer,
output reg [7:0] Data_in,
output reg [7:0] Data_in2,
output reg R_W,
output reg Start,
input Error,
input Ready);

initial begin
  // Escriptura de dos bytes i lectura de dos bytes setejant el Pointer
  
  /*
  Set_pointer = 1'b0;        //Per escriure no necessitem el Set_pointer   
  Pointer = 8'b00000010;     //Direcció del registre d'un byte
  Data_in = 8'b10011001;     //Primer byte de dades a escriure
  Data_in2 = 8'b00110001;    //Segon byte de dades a escriure
  Adr = 7'b1001101;          //Adreça del Slave
  R_W = 1'b0;                //Indiquem que volem escriure
  #300 Start = 1'b1;         //Iniciem un procés
  #1000 Start = 1'b0;        //Desactivem Start
  #95000 R_W = 1'b0;         //Un cop acabada l'escriptura s'indica que es vol tornar a escriure per setejar el Pointer
  #5000  Set_pointer = 1'b1; //S'indica que es setejarà el Pointer
  #300 Start = 1'b1;         //S'inicia un procés
  #1000 Start = 1'b0;        //Es desactiva Start
  R_W = 1'b1;                //S'indica que quan es faci un repeat start es voldrà llegir
  */
  
  // Escriptura d'un byte i lectura d'un byte setejant el Pointer
  
  /*
  Set_pointer = 1'b0;       //Per escriure no necessitem el Set_pointer
  Pointer = 8'b00000001;    //Direcció del registre d'un byte
  Data_in = 8'b10011001;    //Dades a escriure
  Adr = 7'b1001101;         //Adreça del Slave
  R_W = 1'b0;               //Indiquem que es vol escriure
  #300 Start = 1'b1;        //Indiquem un Start a la màquina
  #1000 Start = 1'b0;       //Quan Ready = 0, desactivem Start
  #72000 R_W = 1'b0;        //Un cop s'ha acabat l'escriptura i Ready = 0, canviem a lectura
  #5000 Set_pointer = 1'b1; //Ara es vol setejar el registre al que dirigir-nos
  #300 Start = 1'b1;        //Iniciem un altre procés
  #1000 Start = 1'b0;       //Desactivem Start
  R_W = 1'b1;               //Indiquem que un cop setejat el Pointer i es faci un repeat start, es voldrà llegir
  */
  
  //Rst asíncron
  
  
  Set_pointer = 1'b0;    //Per escriure no necessitem el Set_pointer
  Pointer = 8'b00000001; //Direcció del registre d'un byte
  Data_in = 8'b10011001; //Dades a escriure
  Adr = 7'b1001101;      //Adreça del Slave
  R_W = 1'b0;            //Indiquem que es vol escriure
  #300 Start = 1'b1;     //Indiquem un Start a la màquina
  #1000 Start = 1'b0;    //Quan Ready = 0, desactivem Start
  #20000 Start = 1'b1;   //Després del Rst fet al módul 'test_I2C' tornem a iniciar un procés 
  #1000 Start = 1'b0;
  
  end
  
endmodule
