library verilog;
use verilog.vl_types.all;
entity Master is
    port(
        Rst             : in     vl_logic;
        Start           : in     vl_logic;
        Data_in         : in     vl_logic_vector(7 downto 0);
        Data_in2        : in     vl_logic_vector(7 downto 0);
        Adr             : in     vl_logic_vector(6 downto 0);
        Pointer         : in     vl_logic_vector(7 downto 0);
        Set_pointer     : in     vl_logic;
        R_W             : in     vl_logic;
        Ready           : out    vl_logic;
        Error           : out    vl_logic;
        Data_out        : out    vl_logic_vector(7 downto 0);
        Data_valid      : out    vl_logic;
        Scl             : out    vl_logic;
        Sda             : inout  vl_logic;
        Clk_in          : in     vl_logic
    );
end Master;
