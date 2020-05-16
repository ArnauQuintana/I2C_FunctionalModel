library verilog;
use verilog.vl_types.all;
entity UC_LM75x_fm is
    generic(
        Adress          : integer := 77;
        S0              : integer := 0;
        S1              : integer := 1;
        S2              : integer := 2;
        S3              : integer := 3;
        S4              : integer := 4;
        S5              : integer := 5;
        S6              : integer := 6;
        S7              : integer := 7;
        S8              : integer := 8;
        S9              : integer := 9;
        S10             : integer := 10;
        S11             : integer := 11;
        S12             : integer := 12;
        S13             : integer := 13;
        S14             : integer := 14;
        S15             : integer := 15
    );
    port(
        Start           : in     vl_logic;
        Stop            : in     vl_logic;
        Clk             : in     vl_logic;
        Save_adr        : in     vl_logic_vector(7 downto 0);
        Save_pointer    : in     vl_logic_vector(7 downto 0);
        Error           : out    vl_logic;
        Enable_sda_ack  : out    vl_logic;
        En_cont_data    : out    vl_logic;
        Datain_sda      : in     vl_logic;
        Datain_scl      : in     vl_logic;
        Load_shiftSRPL_adr: out    vl_logic;
        Load_shiftSRPL_data: out    vl_logic;
        Load_shiftSRPL_pointer: out    vl_logic;
        Ready           : out    vl_logic;
        Rst             : in     vl_logic;
        Out_cont_cycle  : in     vl_logic_vector(3 downto 0);
        Out_cont_data   : in     vl_logic_vector(3 downto 0);
        Load_shiftPLSR  : out    vl_logic;
        Enable_data     : out    vl_logic
    );
end UC_LM75x_fm;
