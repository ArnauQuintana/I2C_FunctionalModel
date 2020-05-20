module tb_I2C();
  
  wire Start,R_W;
  wire [7:0] Data_in,Data_in2,Pointer;
  wire [7:0] Data_out;
  wire [6:0] Adr;

  sys_clk50MHz_fm Clk50(.Clk(Clk_in));
  
  sys_rst_fm sys_rst(.Rst_n(Rst));
 
  Master Master(.Rst(Rst),
  .Start(Start),
  .Data_in(Data_in),
  .Data_in2(Data_in2),
  .Adr(Adr),
  .Pointer(Pointer),
  .Set_pointer(Set_pointer),
  .R_W(R_W),
  .Ready(Ready_master),
  .Error(Error_master),
  .Data_out(Data_out),
  .Scl(Scl),
  .Sda(Sda),
  .Clk_in(Clk_in));
  
  LM75x_fm LM75x_fm(.Sda(Sda),
  .Scl(Scl),
  .Set_pointer(Set_pointer));
  
  I2C_cntr_fm I2C_cntr_fm(
  .Adr(Adr),
  .Pointer(Pointer),
  .Set_pointer(Set_pointer),
  .Data_in(Data_in),
  .Data_in2(Data_in2),
  .R_W(R_W),
  .Start(Start),
  .Error(Error),
  .Ready(Ready));
    
  pullup(Sda);   
  pullup(Scl);
  

endmodule


