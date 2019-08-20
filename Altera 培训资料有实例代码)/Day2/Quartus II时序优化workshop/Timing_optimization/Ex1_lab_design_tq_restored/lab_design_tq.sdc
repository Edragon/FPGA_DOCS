#**************************************************************
# Time Information
#**************************************************************
set_time_format -unit ns -decimal_places 3


#**************************************************************
# clocks
#**************************************************************
create_clock -name FCLK -period 7.500 -waveform { 0.000 3.750 } [get_ports {FCLK}]
create_clock -name SCLK -period 5.128 -waveform { 0.000 2.564 } [get_ports {SCLK}]
create_clock -name SPI3_RX_RFCLK -period 10.000 -waveform { 0.000 5.000 } [get_ports {SPI3_RX_RFCLK}]
create_clock -name SPI3_TX_TFCLK -period 10.000 -waveform { 0.000 5.000 } [get_ports {SPI3_TX_TFCLK}]

# Create generated clocks based on PLLs
derive_pll_clocks -use_tan_name


#**************************************************************
# Set Multicycle Path
# - Assignments to mask timing violations
# - do not edit assignments
#**************************************************************
set_multicycle_path -setup 2 -from {fft:iFFT|*} -to {fft:iFFT|*}
set_multicycle_path -setup 2 -from {spi3_rx:iSPI3_RX|*} -to {spi3_rx:iSPI3_RX|*}
set_multicycle_path -setup 2 -from {spi3_rx:iSPI3_RX|*} -to {fft:iFFT|*}
set_multicycle_path -setup 2 -from {spi3_tx:iSPI3_TX|*} -to {spi3_tx:iSPI3_TX|*}
set_multicycle_path -setup 2 -from {ASYNC_FIFO:iFIFO_FCLK_TO_SCLK|*} -to {ASYNC_FIFO:iFIFO_FCLK_TO_SCLK|*}
set_multicycle_path -setup 2 -from {ASYNC_FIFO:iFIFO_SCLK_TO_FCLK|*} -to {ASYNC_FIFO:iFIFO_SCLK_TO_FCLK|*}

set_multicycle_path -hold 1 -from {fft:iFFT|*} -to {fft:iFFT|*}
set_multicycle_path -hold 1 -from {spi3_rx:iSPI3_RX|*} -to {spi3_rx:iSPI3_RX|*}
set_multicycle_path -hold 1 -from {spi3_rx:iSPI3_RX|*} -to {fft:iFFT|*}
set_multicycle_path -hold 1 -from {spi3_tx:iSPI3_TX|*} -to {spi3_tx:iSPI3_TX|*}
set_multicycle_path -hold 1 -from {ASYNC_FIFO:iFIFO_FCLK_TO_SCLK|*} -to {ASYNC_FIFO:iFIFO_FCLK_TO_SCLK|*}
set_multicycle_path -hold 1 -from {ASYNC_FIFO:iFIFO_SCLK_TO_FCLK|*} -to {ASYNC_FIFO:iFIFO_SCLK_TO_FCLK|*}

#**************************************************************
# False Paths
#**************************************************************
set_clock_groups -exclusive -group {FCLK} -group {SCLK}
set_clock_groups -exclusive -group {SCLK} -group {SPI3_RX_RFCLK}
set_clock_groups -exclusive -group {SCLK} -group {SPI3_TX_TFCLK}

set_false_path -from [get_ports {RESET}] -to {reg_reset_fclk[0]}
set_false_path -from [get_ports {RESET}] -to {reg_reset_sclk[0]}
set_false_path -from [get_ports {RESET}] -to {reg_reset_rxclk[0]}
set_false_path -from [get_ports {RESET}] -to {reg_reset_txclk[0]}
set_false_path -from * -to {PACKET_ERROR}


#**************************************************************
# FIFO A Input Assigments
#**************************************************************
set_input_delay -add_delay -max 4.69 -clock {FCLK} [get_ports {FIFOA_AF_N}]
set_input_delay -add_delay -max 4.69 -clock {FCLK} [get_ports {FIFOA_FF_N}]
set_input_delay -add_delay -min 0.69 -clock {FCLK} [get_ports {FIFOA_AF_N}]
set_input_delay -add_delay -min 0.69 -clock {FCLK} [get_ports {FIFOA_FF_N}]


#**************************************************************
# FIFO A Output Assigments
#**************************************************************
set_output_delay -add_delay -max 1.34 -clock {FCLK} [get_ports {FIFOA_CS_N}]
set_output_delay -add_delay -max 1.34 -clock {FCLK} [get_ports {FIFOA_EN}]
set_output_delay -add_delay -max 1.34 -clock {FCLK} [get_ports {FIFOA_WR}]
set_output_delay -add_delay -max 1.34 -clock {FCLK} [get_ports {FIFOA_DATA*}]
set_output_delay -add_delay -max 0.84 -clock {FCLK} [get_ports {FIFOA_RST_N}]
set_output_delay -add_delay -min -1.66 -clock {FCLK} [get_ports {FIFOA_CS_N}]
set_output_delay -add_delay -min -1.66 -clock {FCLK} [get_ports {FIFOA_EN}]
set_output_delay -add_delay -min -1.66 -clock {FCLK} [get_ports {FIFOA_WR}]
set_output_delay -add_delay -min -1.66 -clock {FCLK} [get_ports {FIFOA_DATA*}]
set_output_delay -add_delay -min -2.66 -clock {FCLK} [get_ports {FIFOA_RST_N}]


#**************************************************************
# FIFO B Input Assigments
#**************************************************************
set_input_delay -add_delay -max 4.03 -clock {FCLK} [get_ports {FIFOB_AE_N}]
set_input_delay -add_delay -max 4.03 -clock {FCLK} [get_ports {FIFOB_EF_N}]
set_input_delay -add_delay -max 4.03 -clock {FCLK} [get_ports {FIFOB_DATA*}]
set_input_delay -add_delay -min 0.03 -clock {FCLK} [get_ports {FIFOB_AE_N}]
set_input_delay -add_delay -min 0.03 -clock {FCLK} [get_ports {FIFOB_EF_N}]
set_input_delay -add_delay -min 0.03 -clock {FCLK} [get_ports {FIFOB_DATA*}]


#**************************************************************
# FIFO B Output Assigments
#**************************************************************
set_output_delay -add_delay -max 0.68 -clock {FCLK} [get_ports {FIFOB_CS_N}]
set_output_delay -add_delay -max 0.68 -clock {FCLK} [get_ports {FIFOB_EN}]
set_output_delay -add_delay -max 0.68 -clock {FCLK} [get_ports {FIFOB_RD_N}]
set_output_delay -add_delay -max 0.18 -clock {FCLK} [get_ports {FIFOB_RST_N}]
set_output_delay -add_delay -min -2.32 -clock {FCLK} [get_ports {FIFOB_CS_N}]
set_output_delay -add_delay -min -2.32 -clock {FCLK} [get_ports {FIFOB_EN}]
set_output_delay -add_delay -min -2.32 -clock {FCLK} [get_ports {FIFOB_RD_N}]
set_output_delay -add_delay -min -3.32 -clock {FCLK} [get_ports {FIFOB_RST_N}]


#**************************************************************
# SPI3 RX Input Assigments
#**************************************************************
set_input_delay -add_delay -max 6.31 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RVAL}]
set_input_delay -add_delay -max 6.31 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RDAT*}]
set_input_delay -add_delay -max 6.31 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RSOP}]
set_input_delay -add_delay -max 6.31 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_REOP}]
set_input_delay -add_delay -max 6.31 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RERR}]
set_input_delay -add_delay -max 6.31 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RMOD*}]
set_input_delay -add_delay -min 1.81 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RVAL}]
set_input_delay -add_delay -min 1.81 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RDAT*}]
set_input_delay -add_delay -min 1.81 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RSOP}]
set_input_delay -add_delay -min 1.81 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_REOP}]
set_input_delay -add_delay -min 1.81 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RERR}]
set_input_delay -add_delay -min 1.81 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RMOD*}]


#**************************************************************
# SPI3 RX Output Assigments
#**************************************************************
set_output_delay -add_delay -max 2.17 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RENB}]
set_output_delay -add_delay -min -0.33 -clock {SPI3_RX_RFCLK} [get_ports {SPI3_RX_RENB}]


#**************************************************************
# SPI3 TX Input Assigments
#**************************************************************
set_input_delay -add_delay -max 6.31 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_DTPA}]
set_input_delay -add_delay -min 1.31 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_DTPA}]


#**************************************************************
# SPI3 TX Output Assigments
#**************************************************************
set_output_delay -add_delay -max 2.17 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TENB}]
set_output_delay -add_delay -max 2.17 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TDAT*}]
set_output_delay -add_delay -max 2.17 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TSOP}]
set_output_delay -add_delay -max 2.17 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TEOP}]
set_output_delay -add_delay -max 2.17 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TERR}]
set_output_delay -add_delay -max 2.17 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TMOD*}]
set_output_delay -add_delay -min -0.33 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TENB}]
set_output_delay -add_delay -min -0.33 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TDAT*}]
set_output_delay -add_delay -min -0.33 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TSOP}]
set_output_delay -add_delay -min -0.33 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TEOP}]
set_output_delay -add_delay -min -0.33 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TERR}]
set_output_delay -add_delay -min -0.33 -clock {SPI3_TX_TFCLK} [get_ports {SPI3_TX_TMOD*}]
