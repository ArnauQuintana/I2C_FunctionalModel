`define SYSRST            tb_I2C.sys_rst
`define CLK50M            tb_I2C.Clk50
module test_I2C();
  
  tb_I2C tb_I2C();
  
  initial
  begin  
   `SYSRST.rstOn;               //Rst inicial
   `CLK50M.waitCycles(2);
   `SYSRST.rstOff;
       
   
   `CLK50M.waitCycles(1000);  //activar per fer el test d'un Rst asíncron en mig d'un procés
   `SYSRST.rstOn;               //juntament amb el bloc de codi assignat al módul 'I2C_cntr_fm'
   `CLK50M.waitCycles(3);
   `SYSRST.rstOff; 
     
  #250000 $finish();
  end
  
endmodule


