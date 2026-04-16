set_global_assignment -entity "pll_74mhz" -library "lib_pll_74mhz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_74mhz" -library "lib_pll_74mhz" -name IP_TOOL_VERSION "24.1"
set_global_assignment -entity "pll_74mhz" -library "lib_pll_74mhz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_74mhz" -name SPD_FILE [file join $::quartus(sip_path) "pll_74mhz.spd"]

set_global_assignment -library "lib_pll_74mhz" -name MISC_FILE [file join $::quartus(sip_path) "pll_74mhz_sim/pll_74mhz.vho"]
