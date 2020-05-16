library verilog;
use verilog.vl_types.all;
entity Shift_PLSR_slave is
    port(
        \In\            : in     vl_logic_vector(7 downto 0);
        Load            : in     vl_logic;
        Clk             : in     vl_logic;
        \Out\           : out    vl_logic
    );
end Shift_PLSR_slave;
