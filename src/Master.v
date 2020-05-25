module Master(input Rst,
input Start,
input [7:0] Data_in,
input [7:0] Data_in2,
input [6:0] Adr,
input [7:0] Pointer,
input Set_pointer,
input R_W,
output Ready,
output Error,
output reg [7:0] Data_out,
output Data_valid,
output Scl,
inout Sda,
input Clk_in);

  supply0 Gnd;
  supply1 Vcc;
  
  wire Clk;
  div_25 div25(.clk_in(Clk_in),
  .clk_out(Clk));
  
  wire Clk_scl;
  div_5 div5(.clk_in(Clk),
  .clk_out(Clk_scl));
 
	wire Datain_sda;
	buf buf1(Datain_sda,Sda);
		
	reg [7:0] Save_datain;
	always@(Data_in)
	  Save_datain = ~Data_in;
	  
	reg [7:0] Save_datain2;
	always@(Data_in2)
	 Save_datain2 = ~Data_in2;
	 
	reg [7:0] Save_adr;
	always@(Adr or R_W)
	  Save_adr = ~{Adr,R_W}; 
	  
	reg [7:0] Save_pointer;
	always@(Pointer)
	 Save_pointer = ~Pointer;
	
	wire Repeat;     
	reg Return = 1'b0;
	always@(posedge Clk_scl)
	 if (Repeat == 1'b1)
	   Return = 1'b1;
	 else
	   Return = 1'b0;	
	
	wire [3:0] Out_cont_data;
	wire En_cont_data;
	Contador_rst Contador_scl(.En(En_cont_data),  //conta els cicles del rellotge del Scl
	.Clk(Clk_scl),
	.Rst(Rst),
	.Out(Out_cont_data));
  
  wire [3:0] Out_cont_cycle;
  wire En_cont_cycle;
  assign En_cont_cycle = 1'b1;
  Contador #(5)Contador_clk(.En(En_cont_cycle),  //conta els cicles del rellotge del master
  .Clk(Clk),
  .Out(Out_cont_cycle));
  
  wire [7:0] In_shiftPLSR;
  wire Load_shiftPLSR,Out_shiftPLSR;
  wire [2:0] SelectPLSR;
  assign In_shiftPLSR = (SelectPLSR == 3'b000) ? Gnd : 
  (SelectPLSR == 3'b001) ? Save_pointer :
  (SelectPLSR == 3'b010) ? Save_datain : 
  (SelectPLSR == 3'b011) ? Save_datain2 :
  (Save_adr);

  Shift_PLSR_master Shift_PLSR_master(.In(In_shiftPLSR),
  .Load(Load_shiftPLSR),
  .Clk(Clk),
  .Rst(Rst),
  .Out(Out_shiftPLSR));
  
  wire [1:0] Enable_sda;
  wire Enable_bufsda;
  assign Enable_bufsda = (Enable_sda == 2'b00) ? Gnd : (Enable_sda == 2'b01 ? Vcc : Out_shiftPLSR); 
  bufif1 buf_sda(Sda,Gnd,Enable_bufsda);
  
  wire Enable_scl;
  wire [1:0] Enable_clk; 
  assign Enable_scl = (Enable_clk == 2'b00) ? Gnd : (Enable_clk == 2'b01 ? Vcc : ~Clk_scl);
  
  bufif1 buf_scl(Scl,Gnd,Enable_scl);
 
  wire [7:0] Out_shiftSRPL;
  wire Load_shiftSRPL;
  Shift_SRPL_master Shift_SRPL_master(.Clk(Clk),
  .Load(Load_shiftSRPL),
  .In(~Datain_sda),
  .Out(Out_shiftSRPL));
  
  always@(Out_shiftSRPL) 
    Data_out = Out_shiftSRPL;
        
  UC_Master UC_Master(.Clk(Clk),
  .Clk_scl(Clk_scl),
  .Rst(Rst),
  .Start(Start),
  .R_W(R_W),
  .Datain_sda(Datain_sda),
  .Pointer(Pointer),
  .Set_pointer(Set_pointer),
  .Repeat(Repeat),
  .Return(Return),
  .Out_cont_cycle(Out_cont_cycle),
  .Out_cont_data(Out_cont_data),
  .En_cont_data(En_cont_data),
  .Load_shiftPLSR(Load_shiftPLSR),
  .Load_shiftSRPL(Load_shiftSRPL),
  .Enable_sda(Enable_sda),
  .SelectPLSR(SelectPLSR),
  .Enable_clk(Enable_clk),
  .Ready(Ready),
  .Data_valid(Data_valid),
  .Error(Error));

endmodule