library verilog;
use verilog.vl_types.all;
entity Shift_SRPL_slave is
    port(
        Clk             : in     vl_logic;
        Load            : in     vl_logic;
        \In\            : in     vl_logic;
        \Out\           : out    vl_logic_vector(7 downto 0)
    );
end Shift_SRPL_slave;
