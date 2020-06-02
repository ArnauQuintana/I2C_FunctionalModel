library verilog;
use verilog.vl_types.all;
entity LM75x_fm is
    port(
        Sda             : inout  vl_logic;
        Scl             : in     vl_logic;
        Rst             : in     vl_logic
    );
end LM75x_fm;
