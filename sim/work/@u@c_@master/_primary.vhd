library verilog;
use verilog.vl_types.all;
entity UC_Master is
    generic(
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
        S15             : integer := 15;
        S16             : integer := 16
    );
    port(
        Clk             : in     vl_logic;
        Clk_scl         : in     vl_logic;
        Rst             : in     vl_logic;
        Start           : in     vl_logic;
        R_W             : in     vl_logic;
        Datain_sda      : in     vl_logic;
        Pointer         : in     vl_logic_vector(7 downto 0);
        Set_pointer     : in     vl_logic;
        \Return\        : in     vl_logic;
        Repeat          : out    vl_logic;
        Out_cont_cycle  : in     vl_logic_vector(3 downto 0);
        Out_cont_data   : in     vl_logic_vector(3 downto 0);
        En_cont_data    : out    vl_logic;
        Load_shiftPLSR  : out    vl_logic;
        Load_shiftSRPL  : out    vl_logic;
        Enable_sda      : out    vl_logic_vector(1 downto 0);
        SelectPLSR      : out    vl_logic_vector(2 downto 0);
        Enable_clk      : out    vl_logic_vector(1 downto 0);
        Ready           : out    vl_logic;
        Error           : out    vl_logic
    );
end UC_Master;
