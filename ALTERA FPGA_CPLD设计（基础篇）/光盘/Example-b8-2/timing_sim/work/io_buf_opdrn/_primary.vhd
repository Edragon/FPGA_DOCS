library verilog;
use verilog.vl_types.all;
entity io_buf_opdrn is
    port(
        datain          : in     vl_logic;
        dataout         : out    vl_logic
    );
end io_buf_opdrn;
