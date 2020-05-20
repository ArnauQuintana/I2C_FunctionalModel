library verilog;
use verilog.vl_types.all;
entity I2C_cntr_fm is
    port(
        Adr             : out    vl_logic_vector(6 downto 0);
        Pointer         : out    vl_logic_vector(7 downto 0);
        Set_pointer     : out    vl_logic;
        Data_in         : out    vl_logic_vector(7 downto 0);
        Data_in2        : out    vl_logic_vector(7 downto 0);
        R_W             : out    vl_logic;
        Start           : out    vl_logic;
        Error           : in     vl_logic;
        Ready           : in     vl_logic
    );
end I2C_cntr_fm;
