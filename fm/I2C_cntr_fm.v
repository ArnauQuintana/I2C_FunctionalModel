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
  Set_pointer = 1'b0;
  Pointer = 8'b000000010;
  Data_in = 8'b10011001;
  Data_in2 = 8'b00110001;
  Adr = 7'b1001101;
  R_W = 1'b0;
  #100 Start = 1'b1;
  
  end
endmodule
