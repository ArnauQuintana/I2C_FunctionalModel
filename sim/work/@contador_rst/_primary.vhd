library verilog;
use verilog.vl_types.all;
entity Contador_rst is
    generic(
        M               : integer := 8
    );
    port(
        En              : in     vl_logic;
        Rst             : in     vl_logic;
        Clk             : in     vl_logic;
        \Out\           : out    vl_logic_vector(3 downto 0)
    );
end Contador_rst;
