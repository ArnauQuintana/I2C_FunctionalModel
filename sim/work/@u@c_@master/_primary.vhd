library verilog;
use verilog.vl_types.all;
entity UC_Master is
    generic(
        IDLE            : integer := 0;
        \START\         : integer := 1;
        ADRESS          : integer := 2;
        ACK_ADRESS      : integer := 3;
        MSB_RD          : integer := 4;
        ACK_MSB_RD      : integer := 5;
        LSB_RD          : integer := 6;
        NACK_LSB_RD     : integer := 7;
        \POINTER\       : integer := 8;
        ACK_POINTER     : integer := 9;
        MSB_WR          : integer := 10;
        ACK_MSB_WR      : integer := 11;
        LSB_WR          : integer := 12;
        ACK_LSB_WR      : integer := 13;
        STOP            : integer := 14;
        \ERROR\         : integer := 15;
        \REPEAT\        : integer := 16
    );
    port(
        Clk             : in     vl_logic;
        Clk_scl         : in     vl_logic;
        Rst             : in     vl_logic;
        \Start\         : in     vl_logic;
        R_W             : in     vl_logic;
        Datain_sda      : in     vl_logic;
        \Pointer\       : in     vl_logic_vector(7 downto 0);
        Set_pointer     : in     vl_logic;
        \Return\        : in     vl_logic;
        \Repeat\        : out    vl_logic;
        Out_cont_cycle  : in     vl_logic_vector(3 downto 0);
        Out_cont_data   : in     vl_logic_vector(3 downto 0);
        En_cont_data    : out    vl_logic;
        Load_shiftPLSR  : out    vl_logic;
        Load_shiftSRPL  : out    vl_logic;
        Enable_sda      : out    vl_logic_vector(1 downto 0);
        SelectPLSR      : out    vl_logic_vector(2 downto 0);
        Enable_clk      : out    vl_logic_vector(1 downto 0);
        Ready           : out    vl_logic;
        Data_valid      : out    vl_logic;
        \Error\         : out    vl_logic
    );
end UC_Master;
