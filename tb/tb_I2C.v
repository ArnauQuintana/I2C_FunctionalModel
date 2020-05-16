module tb_I2C();
  
  reg Start,R_W;
  reg [7:0] Data_in,Data_in2,Pointer;
  wire [7:0] Data_out;
  reg [6:0] Adr;

  supply0 Gnd;
  supply1 Vcc;
  
  sys_clk50MHz_fm Clk50(.Clk(Clk_in));
  
  sys_rst_fm sys_rst(.Rst_n(Rst));
 
  Master Master(.Rst(Rst),
  .Start(Start),
  .Data_in(Data_in),
  .Data_in2(Data_in2),
  .Adr(Adr),
  .Pointer(Pointer),
  .R_W(R_W),
  .Ready(Ready_master),
  .Error(Error_master),
  .Data_out(Data_out),
  .Scl(Scl),
  .Sda(Sda),
  .Clk_in(Clk_in));
  
  reg A0,A1,A2;
  LM75x_fm LM75x_fm(.Sda(Sda),
  .Scl(Scl));
  
  pullup(Sda);   //podem assignar pins a la placa que fagin aquesta funci�
  pullup(Scl);
  
  initial
  begin 

  
 
  Pointer = 8'b0000001;
  Data_in = 8'b11001101;
  Data_in2 = 8'b00110010;
  Adr = 7'b1001101;
  R_W = 1'b0;
  #100 Start = 1'b1;
  
  #110000 $finish();
  end

endmodule


