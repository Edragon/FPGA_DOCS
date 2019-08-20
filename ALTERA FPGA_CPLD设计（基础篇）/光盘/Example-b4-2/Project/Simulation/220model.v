//-------------------------------------------------------------------------
// This Verilog file was developed by Altera Corporation.  It may be
// freely copied and/or distributed at no cost.  Any persons using this
// file for any purpose do so at their own risk, and are responsible for
// the results of such use.  Altera Corporation does not guarantee that
// this file is complete, correct, or fit for any particular purpose.
// NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.  This notice must
// accompany any copy of this file.
//------------------------------------------------------------------------
//
// Quartus II 4.1 Build 208 06/29/2004
//
//------------------------------------------------------------------------
// LPM Synthesizable Models (Support string type generic)
// These models are based on LPM version 220 (EIA-IS103 October 1998).
//------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------
// Assumptions:
//
// 1. The default value for LPM_SVALUE, LPM_AVALUE, LPM_PVALUE, and
//    LPM_STRENGTH is string UNUSED.
//
//-----------------------------------------------------------------------------
// Verilog Language Issues:
//
// Two dimensional ports are not supported. Modules with two dimensional
// ports are implemented as one dimensional signal of (LPM_SIZE * LPM_WIDTH)
// bits wide.
//
//-----------------------------------------------------------------------------



//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  LPM_HINT_EVALUATION
//
// Description     :  Common function to grep the value of altera specific parameters
//                    within the lpm_hint parameter.
//
// Limitation      :  No error checking to check whether the content of the lpm_hint
//                    is valid or not.
//
// Results expected:  If the target parameter found, return the value of the parameter.
//                    Otherwise, return empty string.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module LPM_HINT_EVALUATION;

// FUNCTON DECLARATION

// This function will search through the string (given string) to look for a match for the
// a given parameter(compare_param_name). It will return the value for the given parameter.
function [8*200:1] GET_PARAMETER_VALUE;
    input [8*200:1] given_string;  // string to be searched
    input [8*50:1] compare_param_name; // parameter name to be looking for in the given_string.
    integer param_value_char_count; // to indicate current character count in the param_value
    integer param_name_char_count;  // to indicate current character count in the param_name
    integer white_space_count;

    reg extract_param_value; // if 1 mean extracting parameters value from given string
    reg extract_param_name;  // if 1 mean extracting parameters name from given string
    reg param_found; // to indicate whether compare_param_name have been found in the given_string
    reg include_white_space; // if 1, include white space in the parameter value

    reg [8*200:1] reg_string; // to store the value of the given string
    reg [8*50:1] param_name;  // to store parameter name
    reg [8*20:1] param_value; // to store parameter value
    reg [8:1] tmp; // to get the value of the current byte
begin
    reg_string = given_string;
    param_value_char_count = 0;
    param_name_char_count =0;
    extract_param_value = 1;
    extract_param_name = 0;
    param_found = 0;
    include_white_space = 0;
    white_space_count = 0;

    tmp = reg_string[8:1];

    // checking every bytes of the reg_string from right to left.
    while ((tmp != 0 ) && (param_found != 1))
    begin
        tmp = reg_string[8:1];

        //if tmp != ' ' or should include white space (trailing white space are ignored)
        if((tmp != 32) || (include_white_space == 1))
        begin
            if(tmp == 32)
            begin
                white_space_count = 1;
            end
            else if(tmp == 61)  // if tmp = '='
            begin
                extract_param_value = 0;
                extract_param_name =  1;  // subsequent bytes should be part of param_name
                include_white_space = 0;  // ignore the white space (if any) between param_name and '='
                white_space_count = 0;
                param_value = param_value >> (8 * (20 - param_value_char_count));
                param_value_char_count = 0;
            end
            else if (tmp == 44) // if tmp = ','
            begin
                extract_param_value = 1; // subsequent bytes should be part of param_value
                extract_param_name =  0;
                param_name = param_name >> (8 * (50 - param_name_char_count));
                param_name_char_count = 0;
                if(param_name == compare_param_name)
                    param_found = 1;  // the compare_param_name have been found in the reg_string
            end
            else
            begin
                if(extract_param_value == 1)
                begin
                    param_value_char_count = param_value_char_count + white_space_count + 1;
                    include_white_space = 1;
                    if(white_space_count > 0)
                    begin
                        param_value = {8'b100000, param_value[20*8:9]};
                        white_space_count = 0;
                    end
                    param_value = {tmp, param_value[20*8:9]};
                end
                else if(extract_param_name == 1)
                begin
                    param_name = {tmp, param_name[50*8:9]};
                    param_name_char_count = param_name_char_count + 1;
                end
            end
        end
        reg_string = reg_string >> 8;  // shift 1 byte to the right
    end

    // for the case whether param_name is the left most part of the reg_string
    if(extract_param_name == 1)
    begin
        param_name = param_name >> (8 * (50 - param_name_char_count));

        if(param_name == compare_param_name)
            param_found = 1;
    end

    if (param_found == 1)
        GET_PARAMETER_VALUE = param_value;   // return the value of the parameter been looking for
    else
        GET_PARAMETER_VALUE = "";  // return empty string if parameter not found

end
endfunction

endmodule // LPM_HINT_EVALUATION

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module LPM_DEVICE_FAMILIES;

function IS_FAMILY_APEX20K;
	input device;
	reg[8*20:1] device;
	reg is_apex20k;
begin
	if ((device == "APEX20K") || (device == "apex20k") || (device == "APEX 20K") || (device == "apex 20k") || (device == "RAPHAEL") || (device == "raphael"))
		is_apex20k = 1;
	else
		is_apex20k = 0;

	IS_FAMILY_APEX20K  = is_apex20k;
end
endfunction //IS_FAMILY_APEX20K

function IS_FAMILY_MAX7000B;
	input device;
	reg[8*20:1] device;
	reg is_max7000b;
begin
	if ((device == "MAX7000B") || (device == "max7000b") || (device == "MAX 7000B") || (device == "max 7000b"))
		is_max7000b = 1;
	else
		is_max7000b = 0;

	IS_FAMILY_MAX7000B  = is_max7000b;
end
endfunction //IS_FAMILY_MAX7000B

function IS_FAMILY_MAX7000AE;
	input device;
	reg[8*20:1] device;
	reg is_max7000ae;
begin
	if ((device == "MAX7000AE") || (device == "max7000ae") || (device == "MAX 7000AE") || (device == "max 7000ae"))
		is_max7000ae = 1;
	else
		is_max7000ae = 0;

	IS_FAMILY_MAX7000AE  = is_max7000ae;
end
endfunction //IS_FAMILY_MAX7000AE

function IS_FAMILY_MAX3000A;
	input device;
	reg[8*20:1] device;
	reg is_max3000a;
begin
	if ((device == "MAX3000A") || (device == "max3000a") || (device == "MAX 3000A") || (device == "max 3000a"))
		is_max3000a = 1;
	else
		is_max3000a = 0;

	IS_FAMILY_MAX3000A  = is_max3000a;
end
endfunction //IS_FAMILY_MAX3000A

function IS_FAMILY_MAX7000S;
	input device;
	reg[8*20:1] device;
	reg is_max7000s;
begin
	if ((device == "MAX7000S") || (device == "max7000s") || (device == "MAX 7000S") || (device == "max 7000s"))
		is_max7000s = 1;
	else
		is_max7000s = 0;

	IS_FAMILY_MAX7000S  = is_max7000s;
end
endfunction //IS_FAMILY_MAX7000S

function IS_FAMILY_MAX7000A;
	input device;
	reg[8*20:1] device;
	reg is_max7000a;
begin
	if ((device == "MAX7000A") || (device == "max7000a") || (device == "MAX 7000A") || (device == "max 7000a"))
		is_max7000a = 1;
	else
		is_max7000a = 0;

	IS_FAMILY_MAX7000A  = is_max7000a;
end
endfunction //IS_FAMILY_MAX7000A

function IS_FAMILY_STRATIX;
	input device;
	reg[8*20:1] device;
	reg is_stratix;
begin
	if ((device == "Stratix") || (device == "STRATIX") || (device == "stratix") || (device == "Yeager") || (device == "YEAGER") || (device == "yeager"))
		is_stratix = 1;
	else
		is_stratix = 0;

	IS_FAMILY_STRATIX  = is_stratix;
end
endfunction //IS_FAMILY_STRATIX

function IS_FAMILY_STRATIXGX;
	input device;
	reg[8*20:1] device;
	reg is_stratixgx;
begin
	if ((device == "Stratix GX") || (device == "STRATIX GX") || (device == "stratix gx") || (device == "Stratix-GX") || (device == "STRATIX-GX") || (device == "stratix-gx") || (device == "StratixGX") || (device == "STRATIXGX") || (device == "stratixgx") || (device == "Aurora") || (device == "AURORA") || (device == "aurora"))
		is_stratixgx = 1;
	else
		is_stratixgx = 0;

	IS_FAMILY_STRATIXGX  = is_stratixgx;
end
endfunction //IS_FAMILY_STRATIXGX

function IS_FAMILY_CYCLONE;
	input device;
	reg[8*20:1] device;
	reg is_cyclone;
begin
	if ((device == "Cyclone") || (device == "CYCLONE") || (device == "cyclone") || (device == "ACEX2K") || (device == "acex2k") || (device == "ACEX 2K") || (device == "acex 2k") || (device == "Tornado") || (device == "TORNADO") || (device == "tornado"))
		is_cyclone = 1;
	else
		is_cyclone = 0;

	IS_FAMILY_CYCLONE  = is_cyclone;
end
endfunction //IS_FAMILY_CYCLONE

function IS_VALID_FAMILY;
	input device;
	reg[8*20:1] device;
	reg is_valid;
begin
	if (((device == "ACEX1K") || (device == "acex1k") || (device == "ACEX 1K") || (device == "acex 1k"))
	|| ((device == "APEX20K") || (device == "apex20k") || (device == "APEX 20K") || (device == "apex 20k") || (device == "RAPHAEL") || (device == "raphael"))
	|| ((device == "APEX20KC") || (device == "apex20kc") || (device == "APEX 20KC") || (device == "apex 20kc"))
	|| ((device == "APEX20KE") || (device == "apex20ke") || (device == "APEX 20KE") || (device == "apex 20ke"))
	|| ((device == "APEX II") || (device == "apex ii") || (device == "APEXII") || (device == "apexii") || (device == "APEX 20KF") || (device == "apex 20kf") || (device == "APEX20KF") || (device == "apex20kf"))
	|| ((device == "EXCALIBUR_ARM") || (device == "excalibur_arm") || (device == "Excalibur ARM") || (device == "EXCALIBUR ARM") || (device == "excalibur arm") || (device == "ARM-BASED EXCALIBUR") || (device == "arm-based excalibur") || (device == "ARM_BASED_EXCALIBUR") || (device == "arm_based_excalibur"))
	|| ((device == "FLEX10KE") || (device == "flex10ke") || (device == "FLEX 10KE") || (device == "flex 10ke"))
	|| ((device == "FLEX10K") || (device == "flex10k") || (device == "FLEX 10K") || (device == "flex 10k"))
	|| ((device == "FLEX10KA") || (device == "flex10ka") || (device == "FLEX 10KA") || (device == "flex 10ka"))
	|| ((device == "FLEX6000") || (device == "flex6000") || (device == "FLEX 6000") || (device == "flex 6000") || (device == "FLEX6K") || (device == "flex6k"))
	|| ((device == "MAX7000B") || (device == "max7000b") || (device == "MAX 7000B") || (device == "max 7000b"))
	|| ((device == "MAX7000AE") || (device == "max7000ae") || (device == "MAX 7000AE") || (device == "max 7000ae"))
	|| ((device == "MAX3000A") || (device == "max3000a") || (device == "MAX 3000A") || (device == "max 3000a"))
	|| ((device == "MAX7000S") || (device == "max7000s") || (device == "MAX 7000S") || (device == "max 7000s"))
	|| ((device == "MAX7000A") || (device == "max7000a") || (device == "MAX 7000A") || (device == "max 7000a"))
	|| ((device == "Mercury") || (device == "MERCURY") || (device == "mercury") || (device == "DALI") || (device == "dali"))
	|| ((device == "Stratix") || (device == "STRATIX") || (device == "stratix") || (device == "Yeager") || (device == "YEAGER") || (device == "yeager"))
	|| ((device == "Stratix GX") || (device == "STRATIX GX") || (device == "stratix gx") || (device == "Stratix-GX") || (device == "STRATIX-GX") || (device == "stratix-gx") || (device == "StratixGX") || (device == "STRATIXGX") || (device == "stratixgx") || (device == "Aurora") || (device == "AURORA") || (device == "aurora"))
	|| ((device == "Cyclone") || (device == "CYCLONE") || (device == "cyclone") || (device == "ACEX2K") || (device == "acex2k") || (device == "ACEX 2K") || (device == "acex 2k") || (device == "Tornado") || (device == "TORNADO") || (device == "tornado"))
	|| ((device == "MAX II") || (device == "max ii") || (device == "MAXII") || (device == "maxii") || (device == "Tsunami") || (device == "TSUNAMI") || (device == "tsunami"))
	|| ((device == "HardCopy Stratix") || (device == "HARDCOPY STRATIX") || (device == "hardcopy stratix") || (device == "Stratix HC") || (device == "STRATIX HC") || (device == "stratix hc") || (device == "StratixHC") || (device == "STRATIXHC") || (device == "stratixhc") || (device == "HardcopyStratix") || (device == "HARDCOPYSTRATIX") || (device == "hardcopystratix"))
	|| ((device == "Stratix II") || (device == "STRATIX II") || (device == "stratix ii") || (device == "StratixII") || (device == "STRATIXII") || (device == "stratixii") || (device == "Armstrong") || (device == "ARMSTRONG") || (device == "armstrong"))
	|| ((device == "Cyclone II") || (device == "CYCLONE II") || (device == "cyclone ii") || (device == "Cycloneii") || (device == "CYCLONEII") || (device == "cycloneii") || (device == "Magellan") || (device == "MAGELLAN") || (device == "magellan")))
		is_valid = 1;
	else
		is_valid = 0;

	IS_VALID_FAMILY = is_valid;
end
endfunction // IS_VALID_FAMILY


endmodule // LPM_DEVICE_FAMILIES
//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_constant
//
// Description     :  Parameterized constant generator megafunction. lpm_constant 
//                    may be useful for convert a parameter into a constant.
//
// Limitation      :  n/a
//
// Results expected:  Value specified by the argument to LPM_CVALUE.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_constant ( 
    result // Value specified by the argument to LPM_CVALUE. (Required)
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;   // Width of the result[] port. (Required)
    parameter lpm_cvalue = 0;  // Constant value to be driven out on the 
                               // result[] port. (Required)
    parameter lpm_strength = "UNUSED";    
    parameter lpm_type = "lpm_constant";  
    parameter lpm_hint = "UNUSED";       

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $finish;
        end
    end

// CONTINOUS ASSIGNMENT
    assign result = lpm_cvalue;

endmodule // lpm_constant

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_inv
//
// Description     :  Parameterized inverter megafunction.
//
// Limitation      :  n/a
//
// Results expected: Inverted value of input data
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_inv ( 
    data,   // Data input to the lpm_inv. (Required)
    result  // inverted result. (Required)
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1; // Width of the data[] and result[] ports. (Required)
    parameter lpm_type = "lpm_inv";    
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION  
    input  [lpm_width-1:0] data;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;

// INTERNAL REGISTERS DECLARATION
    reg    [lpm_width-1:0] result;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0 (ERROR)");
            $finish;
        end
    end
    
// ALWAYS CONSTRUCT BLOCK
    always @(data)
        result = ~data;

endmodule // lpm_inv

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_and
//
// Description     :  Parameterized AND gate. This megafunction takes in data inputs
//                    for a number of AND gates.
//
// Limitation      :  n/a
//
// Results expected: Each result[] bit is the result of each AND gate.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_and (
    data,  // Data input to the AND gate. (Required)
    result // Result of the AND operators. (Required)
);

// GLOBAL PARAMETER DECLARATION
    // Width of the data[][] and result[] ports. Number of AND gates. (Required)
    parameter lpm_width = 1;
    // Number of inputs to each AND gate. Number of input buses. (Required)
    parameter lpm_size = 1;
    parameter lpm_type = "lpm_and";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [(lpm_size * lpm_width)-1:0] data;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg    [lpm_width-1:0] result;

// LOCAL INTEGER DECLARATION
    integer i;
    integer j;
    integer k;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $finish;
        end

        if (lpm_size <= 0)
        begin
            $display("Value of lpm_size parameter must be greater than 0(ERROR)");
            $finish;
        end
    end

// ALWAYS CONSTRUCT BLOCK
    always @(data)
    begin
        for (i=0; i<lpm_width; i=i+1)
        begin
            result[i] = data[i];
            for (j=1; j<lpm_size; j=j+1)
            begin
                k = (j * lpm_width) + i;
                result[i] = result[i] & data[k];
            end
        end
    end

endmodule // lpm_and

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_or
//
// Description     :  Parameterized OR gate megafunction. This megafunction takes in
//                    data inputs for a number of OR gates.
//
// Limitation      :  n/a
//
// Results expected:  Each result[] bit is the result of each OR gate.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_or (
    data,  // Data input to the OR gates. (Required)
    result // Result of OR operators. (Required)
);

// GLOBAL PARAMETER DECLARATION
    // Width of the data[] and result[] ports. Number of OR gates. (Required)
    parameter lpm_width = 1;
    // Number of inputs to each OR gate. Number of input buses. (Required)
    parameter lpm_size = 1;
    parameter lpm_type = "lpm_or";
    parameter lpm_hint  = "UNUSED";

// INPUT PORT DECLARATION
    input  [(lpm_size * lpm_width)-1:0] data;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg    [lpm_width-1:0] result;

// LOCAL INTEGER DECLARATION
    integer i;
    integer j;
    integer k;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0 (ERROR)");
            $finish;
        end

        if (lpm_size <= 0)
        begin
            $display("Value of lpm_size parameter must be greater than 0 (ERROR)");
            $finish;
        end
    end

// ALWAYS CONSTRUCT BLOCK
    always @(data)
    begin
        for (i=0; i<lpm_width; i=i+1)
        begin
            result[i] = data[i];
            for (j=1; j<lpm_size; j=j+1)
            begin
                k = (j * lpm_width) + i;
                result[i] = result[i] | data[k];
            end
        end
    end

endmodule // lpm_or

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_xor
//
// Description     :  Parameterized XOR gate megafunction. This megafunction takes in
//                    data inputs for a number of XOR gates.
//
// Limitation      :  n/a.
//
// Results expected:  Each result[] bit is the result of each XOR gates.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_xor (
    data,   // Data input to the XOR gates. (Required)
    result  // Result of XOR operators. (Required)
);

// GLOBAL PARAMETER DECLARATION
    // Width of the data[] and result[] ports. Number of XOR gates. (Required)
    parameter lpm_width = 1;
    // Number of inputs to each XOR gate. Number of input buses. (Required)
    parameter lpm_size = 1;
    parameter lpm_type = "lpm_xor";
    parameter lpm_hint  = "UNUSED";

// INPUT PORT DECLARATION
    input  [(lpm_size * lpm_width)-1:0] data;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg    [lpm_width-1:0] result;

// LOCAL INTEGER DECLARATION
    integer i;
    integer j;
    integer k;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0 (ERROR)");
            $finish;
        end

        if (lpm_size <= 0)
        begin
            $display("Value of lpm_size parameter must be greater than 0 (ERROR)");
            $finish;
        end
    end

// ALWAYS CONSTRUCT BLOCK
    always @(data)
    begin
        for (i=0; i<lpm_width; i=i+1)
        begin
            result[i] = data[i];
            for (j=1; j<lpm_size; j=j+1)
            begin
                k = (j * lpm_width) + i;
                result[i] = result[i] ^ data[k];
            end
        end
    end

endmodule // lpm_xor

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_bustri
//
// Description     :  Parameterized tri-state buffer. lpm_bustri is useful for 
//                    controlling both unidirectional and bidirectional I/O bus 
//                    controllers.
//
// Limitation      :  n/a
//
// Results expected:  Belows are the three configurations which are valid:
//
//                    1) Only the input ports data[LPM_WIDTH-1..0] and enabledt are
//                       present, and only the output ports tridata[LPM_WIDTH-1..0] 
//                       are present. 
//
//                        ----------------------------------------------------
//                       | Input           |  Output                          |
//                       |====================================================|
//                       | enabledt        |     tridata[LPM_WIDTH-1..0]      |
//                       |----------------------------------------------------|
//                       |    0            |     Z                            |
//                       |----------------------------------------------------|
//                       |    1            |     DATA[LPM_WIDTH-1..0]         |
//                        ----------------------------------------------------
//
//                    2) Only the input ports tridata[LPM_WIDTH-1..0] and enabletr
//                       are present, and only the output ports result[LPM_WIDTH-1..0]
//                       are present.
//
//                        ----------------------------------------------------
//                       | Input           |  Output                          |
//                       |====================================================|
//                       | enabletr        |     result[LPM_WIDTH-1..0]       |
//                       |----------------------------------------------------|
//                       |    0            |     Z                            |
//                       |----------------------------------------------------|
//                       |    1            |     tridata[LPM_WIDTH-1..0]      |
//                        ----------------------------------------------------
//
//                    3) All ports are present: input ports data[LPM_WIDTH-1..0],
//                       enabledt, and enabletr; output ports result[LPM_WIDTH-1..0];
//                       and bidirectional ports tridata[LPM_WIDTH-1..0].
//
//        ----------------------------------------------------------------------------
//       |         Input        |      Bidirectional       |         Output           |
//       |----------------------------------------------------------------------------|
//       | enabledt  | enabletr | tridata[LPM_WIDTH-1..0]  |  result[LPM_WIDTH-1..0]  |
//       |============================================================================|
//       |    0      |     0    |       Z (input)          |          Z               |
//       |----------------------------------------------------------------------------|
//       |    0      |     1    |       Z (input)          |  tridata[LPM_WIDTH-1..0] |
//       |----------------------------------------------------------------------------|
//       |    1      |     0    |     data[LPM_WIDTH-1..0] |          Z               |
//       |----------------------------------------------------------------------------|
//       |    1      |     1    |     data[LPM_WIDTH-1..0] |  data[LPM_WIDTH-1..0]    |
//       ----------------------------------------------------------------------------
//
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_bustri ( 
    tridata,    // Bidirectional bus signal. (Required)
    data,       // Data input to the tridata[] bus. (Required)
    enabletr,   // If high, enables tridata[] onto the result bus.
    enabledt,   // If high, enables data onto the tridata[] bus.
    result      // Output from the tridata[] bus.
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;
    parameter lpm_type = "lpm_bustri";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] data;
    input  enabletr;
    input  enabledt;
    
// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;
    
// INPUT/OUTPUT PORT DECLARATION
    inout  [lpm_width-1:0] tridata;

// INTERNAL REGISTERS DECLARATION
    reg  [lpm_width-1:0] result;

// INTERNAL TRI DECLARATION
    tri0  enabletr;
    tri0  enabledt;
    
    buf (i_enabledt, enabledt);
    buf (i_enabletr, enabletr);


// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $finish;
        end
    end
    
// ALWAYS CONSTRUCT BLOCK
    always @(data or tridata or i_enabletr or i_enabledt)
    begin
        if ((i_enabledt == 0) && (i_enabletr == 1))
        begin
            result = tridata;
        end
        else if ((i_enabledt == 1) && (i_enabletr == 0))
        begin
            result = 'bz;
        end
        else if ((i_enabledt == 1) && (i_enabletr == 1))
        begin
            result = data;
        end
        else
        begin
            result = 'bz;
        end
    end

// CONTINOUS ASSIGNMENT
    assign tridata = (i_enabledt == 1) ? data : {lpm_width{1'bz}};

endmodule // lpm_bustri

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_mux
//
// Description     :  Parameterized multiplexer megafunctions.
//
// Limitation      :  n/a
//
// Results expected:  Selected input port.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_mux ( 
    data,    // Data input. (Required)
    sel,     // Selects one of the input buses. (Required)
    clock,   // Clock for pipelined usage
    aclr,    // Asynchronous clear for pipelined usage.
    clken,   // Clock enable for pipelined usage.
    result   // Selected input port. (Required)
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;  // Width of the data[][] and result[] ports. (Required)
    parameter lpm_size = 2;   // Number of input buses to the multiplexer. (Required)
    parameter lpm_widths = 1; // Width of the sel[] input port. (Required)
    parameter lpm_pipeline = 0; // Specifies the number of Clock cycles of latency
                                // associated with the result[] output.
    parameter lpm_type = "lpm_mux";
    parameter lpm_hint  = "UNUSED";

// INPUT PORT DECLARATION
    input [(lpm_size * lpm_width)-1:0] data;
    input [lpm_widths-1:0] sel;
    input clock;
    input aclr;
    input clken;
    
// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg [lpm_width-1:0] tmp_result2 [lpm_pipeline:0];
    reg [lpm_width-1:0] tmp_result;

// LOCAL INTEGER DECLARATION
    integer i;

// INTERNAL TRI DECLARATION
    tri0 aclr;
    tri0 clock;
    tri1 clken;

    buf (i_aclr, aclr);
    buf (i_clock, clock);
    buf (i_clken, clken);

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0 (ERROR)");
            $finish;
        end

        if (lpm_size <= 1)
        begin
            $display("Value of lpm_size parameter must be greater than 1 (ERROR)");
            $finish;
        end

        if (lpm_widths <= 0)
        begin
            $display("Value of lpm_widths parameter must be greater than 0 (ERROR)");
            $finish;
        end
        
        if (lpm_pipeline < 0)
        begin
            $display("Value of lpm_pipeline parameter must NOT less than 0 (ERROR)");
            $finish;
        end

    end
    
    
// ALWAYS CONSTRUCT BLOCK
    always @(data or sel or i_aclr)
    begin
        if (i_aclr)
            for (i = 0; i <= lpm_pipeline; i = i + 1)
                tmp_result2[i] = 'b0;
        else
        begin
            tmp_result = 0;
            
            if (sel < lpm_size)
            begin
                for (i = 0; i < lpm_width; i = i + 1)
                    tmp_result[i] = data[(sel * lpm_width) + i];
            end
            else
                tmp_result = {lpm_width{1'bx}};

            tmp_result2[lpm_pipeline] = tmp_result;
        end
    end

    always @(posedge i_clock)
    begin
        if (!i_aclr && i_clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
                tmp_result2[i] <= tmp_result2[i+1];
    end

// CONTINOUS ASSIGNMENT
    assign result = tmp_result2[0];
    
endmodule // lpm_mux
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_decode
//
// Description     :  Parameterized decoder megafunction.
//
// Limitation      :  n/a
//
// Results expected:  Decoded output.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_decode (
    data,    // Data input. Treated as an unsigned binary encoded number. (Required)
    enable,  // Enable. All outputs low when not active.
    clock,   // Clock for pipelined usage.
    aclr,    // Asynchronous clear for pipelined usage.
    clken,   // Clock enable for pipelined usage.
    eq       // Decoded output. (Required)
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;                // Width of the data[] port, or the
                                            // input value to be decoded. (Required)
    parameter lpm_decodes = 1 << lpm_width; // Number of explicit decoder outputs. (Required)
    parameter lpm_pipeline = 0;             // Number of Clock cycles of latency 
    parameter lpm_type = "lpm_decode";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] data;
    input  enable;
    input  clock;
    input  aclr;
    input  clken;

// OUTPUT PORT DECLARATION
    output [lpm_decodes-1:0] eq;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg    [lpm_decodes-1:0] tmp_eq2 [lpm_pipeline:0];
    reg    [lpm_decodes-1:0] tmp_eq;

// LOCAL INTEGER DECLARATION
    integer i;

// INTERNAL TRI DECLARATION
    tri1   enable;
    tri0   clock;
    tri0   aclr;
    tri1   clken;
    
    buf (i_clock, clock);
    buf (i_clken, clken);
    buf (i_aclr, aclr);
    buf (i_enable, enable);

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0 (ERROR)");
            $finish;
        end
        if (lpm_decodes <= 0)
        begin
            $display("Value of lpm_decodes parameter must be greater than 0 (ERROR)");
            $finish;
        end
        if (lpm_decodes > (1 << lpm_width))
        begin
            $display("Value of lpm_decodes parameter must be less or equal to 2^lpm_width (ERROR)");
            $finish;
        end
        if (lpm_pipeline < 0)
        begin
            $display("Value of lpm_pipeline parameter must be greater or equal to 0 (ERROR)");
            $finish;
        end
    end

// ALWAYS CONSTRUCT BLOCK
    always @(data or i_enable or i_aclr)
    begin
        if (i_aclr)
            for (i = 0; i <= lpm_pipeline; i = i + 1)
                tmp_eq2[i] = 'b0;
        else
        begin
            tmp_eq = 0;
            if (i_enable)
                tmp_eq[data] = 1'b1;
            tmp_eq2[lpm_pipeline] = tmp_eq;
        end
    end
 
    always @(posedge i_clock)
    begin
        if (!i_aclr && clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
                tmp_eq2[i] <= tmp_eq2[i+1];
    end

    assign eq = tmp_eq2[0];

endmodule // lpm_decode
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_clshift
//
// Description     :  Parameterized combinatorial logic shifter or barrel shifter
//                    megafunction.
//
// Limitation      :  n/a
//
// Results expected:  Return the shifted data and underflow/overflow status bit.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_clshift (     
    data,        // Data to be shifted. (Required)
    distance,    // Number of positions to shift data[] in the direction specified
                 // by the direction port. (Required)
    direction,   // Direction of shift. Low = left (toward the MSB),
                 //                     high = right (toward the LSB). 
    result,      // Shifted data. (Required)
    underflow,   // Logical or arithmetic underflow.
    overflow     // Logical or arithmetic overflow.
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;  // Width of the data[] and result[] ports. Must be
                              // greater than 0 (Required)
    parameter lpm_widthdist = 1; // Width of the distance[] input port. (Required) 
    parameter lpm_shifttype = "LOGICAL"; // Type of shifting operation to be performed.
    parameter lpm_type = "lpm_clshift";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION   
    input  [lpm_width-1:0] data;
    input  [lpm_widthdist-1:0] distance;
    input  direction;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;
    output underflow;
    output overflow;

// INTERNAL REGISTERS DECLARATION
    reg    [lpm_width-1:0] ONES;
    reg    [lpm_width-1:0] result;
    reg    overflow, underflow;

// LOCAL INTEGER DECLARATION
    integer i;

// INTERNAL TRI DECLARATION
    tri0  direction;

    buf (i_direction, direction);

    
// FUNCTON DECLARATION
    // Perform logival shift operation
    function [lpm_width+1:0] LogicShift;
        input [lpm_width-1:0] data;
        input [lpm_widthdist-1:0] dist;
        input direction;
        reg   [lpm_width-1:0] tmp_buf;
        reg   overflow, underflow;
                
        begin
            tmp_buf = data;
            overflow = 1'b0;
            underflow = 1'b0;
            if ((direction) && (dist > 0)) // shift right
            begin
                tmp_buf = data >> dist;
                if ((data != 0) && ((dist >= lpm_width) || (tmp_buf == 0)))
                    underflow = 1'b1;
            end
            else if (dist > 0) // shift left
            begin
                tmp_buf = data << dist;
                if ((data != 0) && ((dist >= lpm_width)
                    || ((data >> (lpm_width-dist)) != 0)))
                    overflow = 1'b1;
            end
            LogicShift = {overflow,underflow,tmp_buf[lpm_width-1:0]};
        end
    endfunction // LogicShift

    // Perform Arithmetic shift operation
    function [lpm_width+1:0] ArithShift;
        input [lpm_width-1:0] data;
        input [lpm_widthdist-1:0] dist;
        input direction;
        reg   [lpm_width-1:0] tmp_buf;
        reg   overflow, underflow;
        integer i;
        
        begin
            tmp_buf = data;
            overflow = 1'b0;
            underflow = 1'b0;

            if (dist < lpm_width)
            begin           
                if (direction && (dist > 0))   // shift right
                begin
                    if (data[lpm_width-1] == 0) // positive number
                    begin
                        tmp_buf = data >> dist;
                        if ((data != 0) && ((dist >= lpm_width) || (tmp_buf == 0)))
                            underflow = 1'b1;
                    end
                    else // negative number
                    begin
                        tmp_buf = (data >> dist) | (ONES << (lpm_width - dist));
                        if ((data != ONES) && ((dist >= lpm_width-1) || (tmp_buf == ONES)))
                            underflow = 1'b1;
                    end
                end
                else if (dist > 0) // shift left
                begin
                    tmp_buf = data << dist;
                    
                    for (i=lpm_width-1; i >= lpm_width-dist; i=i-1)    
                    begin
                        if(data[i-1] != data[lpm_width-1])
                            overflow = 1'b1;    
                    end                      
                end
            end
            else
            begin
                if (direction)
                begin
                    for (i=0; i < lpm_width; i=i+1)
                        tmp_buf[i] = data[lpm_width-1]; 
                        
                    underflow = 1'b1;
                end
                else
                begin
                    tmp_buf = data << lpm_width;
                    
                    if (data != 0)
                    begin
                        overflow = 1'b1;
                    end
                end
            end
            ArithShift = {overflow,underflow,tmp_buf[lpm_width-1:0]};
        end
    endfunction // ArithShift

    // Perform rotate shift operation
    function [lpm_width+1:0] RotateShift;
        input [lpm_width-1:0] data;
        input [lpm_widthdist-1:0] dist;
        input direction;
        reg   [lpm_width-1:0] tmp_buf;
        
        begin
            tmp_buf = data;
            if ((direction) && (dist > 0)) // shift right
                tmp_buf = (data >> dist) | (data << (lpm_width - dist));
            else if (dist > 0) // shift left
                tmp_buf = (data << dist) | (data >> (lpm_width - dist));
            RotateShift = {2'bx, tmp_buf[lpm_width-1:0]};
        end
    endfunction // RotateShift

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_shifttype != "LOGICAL" &&
            lpm_shifttype != "ARITHMETIC" &&
            lpm_shifttype != "ROTATE" &&
            lpm_shifttype != "UNUSED")          // non-LPM 220 standard
            $display("Error!  LPM_SHIFTTYPE value must be \"LOGICAL\", \"ARITHMETIC\", or \"ROTATE\".");

        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $finish;
        end

        if (lpm_widthdist <= 0)
        begin
            $display("Value of lpm_widthdist parameter must be greater than 0(ERROR)");
            $finish;
        end

        for (i=0; i < lpm_width; i=i+1)
            ONES[i] = 1'b1;
    end

// ALWAYS CONSTRUCT BLOCK
    always @(data or i_direction or distance)
    begin
        if ((lpm_shifttype == "LOGICAL") || (lpm_shifttype == "UNUSED"))
            {overflow, underflow, result} = LogicShift(data, distance, i_direction);
        else if (lpm_shifttype == "ARITHMETIC")
            {overflow, underflow, result} = ArithShift(data, distance, i_direction);
        else if (lpm_shifttype == "ROTATE")
            {overflow, underflow, result} = RotateShift(data, distance, i_direction);
    end

endmodule // lpm_clshift

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_add_sub
//
// Description     :  Parameterized adder/subtractor megafunction.
//
// Limitation      :  n/a
//
// Results expected:  If performs as adder, the result will be dataa[]+datab[]+cin.
//                    If performs as subtractor, the result will be dataa[]-datab[]+cin-1.
//                    Also returns carry out bit and overflow status bit.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_add_sub (
    dataa,     // Augend/Minuend
    datab,     // Addend/Subtrahend
    cin,       // Carry-in to the low-order bit.
    add_sub,   // If the signal is high, the operation = dataa[]+datab[]+cin.
               // If the signal is low, the operation = dataa[]-datab[]+cin-1.

    clock,     // Clock for pipelined usage.
    aclr,      // Asynchronous clear for pipelined usage.
    clken,     // Clock enable for pipelined usage.
    result,    // dataa[]+datab[]+cin or dataa[]-datab[]+cin-1
    cout,      // Carry-out (borrow-in) of the MSB.
    overflow   // Result exceeds available precision.
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1; // Width of the dataa[],datab[], and result[] ports.
    parameter lpm_representation = "SIGNED"; // Type of addition performed
    parameter lpm_direction  = "UNUSED";  // Specify the operation of the lpm_add_sub function
    parameter lpm_pipeline = 0; // Number of Clock cycles of latency
    parameter lpm_type = "lpm_add_sub";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] dataa;
    input  [lpm_width-1:0] datab;
    input  cin;
    input  add_sub;
    input  clock;
    input  aclr;
    input  clken;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;
    output cout;
    output overflow;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg [lpm_width-1:0] tmp_result2 [lpm_pipeline:0];
    reg [lpm_pipeline:0] tmp_cout2;
    reg [lpm_pipeline:0] tmp_overflow2;
    reg [lpm_width-1:0] tmp_result;
    reg i_cin;

// LOCAL INTEGER DECLARATION
    integer borrow;
    integer i;

// INTERNAL TRI DECLARATION
    tri1 add_sub;
    tri0 aclr;
    tri0 clock;
    tri1 clken;

    buf (i_aclr, aclr);
    buf (i_clock, clock);
    buf (i_clken, clken);
    buf (i_add_sub, add_sub);

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        // check if lpm_width < 0
        if (lpm_width <= 0)
        begin
            $display("Error!  LPM_WIDTH must be greater than 0.\n");
            $finish;
        end
        if ((lpm_direction != "ADD") &&
            (lpm_direction != "SUB") &&
            (lpm_direction != "UNUSED") &&   // non-LPM 220 standard
            (lpm_direction != "DEFAULT"))    // non-LPM 220 standard
        begin
            $display("Error!  LPM_DIRECTION value must be \"ADD\" or \"SUB\".");
            $finish;
        end
        if ((lpm_representation != "SIGNED") &&
            (lpm_representation != "UNSIGNED"))
        begin
            $display("Error!  LPM_REPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");
            $finish;
        end
        if (lpm_pipeline < 0)
        begin
            $display("Error!  LPM_PIPELINE must be greater than or equal to 0.\n");
            $finish;
        end

        for (i = 0; i <= lpm_pipeline; i = i + 1)
        begin
            tmp_result2[i] = 'b0;
            tmp_cout2[i] = 1'b0;
            tmp_overflow2[i] = 1'b0;
        end
    end

// ALWAYS CONSTRUCT BLOCK
    always @(cin or dataa or datab or i_add_sub or i_aclr)
    begin
        if (i_aclr)
            for (i = 0; i <= lpm_pipeline; i = i + 1)
            begin
                tmp_result2[i] = 1'b0;
                tmp_cout2[i] = 1'b0;
                tmp_overflow2[i] = 1'b0;
            end
        else
        begin

            // cout is the same for both signed and unsign representation.
            if ((lpm_direction == "ADD") || ((i_add_sub == 1) &&
                ((lpm_direction == "UNUSED") || (lpm_direction == "DEFAULT")) ))
            begin
                i_cin = (cin === 1'bz) ? 0 : cin;
                {tmp_cout2[lpm_pipeline], tmp_result2[lpm_pipeline]} = dataa + datab + i_cin;
                tmp_overflow2[lpm_pipeline] = tmp_cout2[lpm_pipeline];
            end
            else if ((lpm_direction == "SUB") || ((i_add_sub == 0) &&
                    ((lpm_direction == "UNUSED") || (lpm_direction == "DEFAULT")) ))
            begin
                i_cin = (cin === 1'bz) ? 1 : cin;
                borrow = (~i_cin) ? 1 : 0;
                {tmp_overflow2[lpm_pipeline], tmp_result2[lpm_pipeline]} = dataa - datab - borrow;
                tmp_cout2[lpm_pipeline] = (dataa >= (datab+borrow))?1:0;
            end

            if (lpm_representation == "SIGNED")
            begin
                // perform the addtion or subtraction operation
                if ((lpm_direction == "ADD") || ((i_add_sub == 1) &&
                    ((lpm_direction == "UNUSED") || (lpm_direction == "DEFAULT")) ))
                begin
                    tmp_result = dataa + datab + i_cin;
                    tmp_overflow2[lpm_pipeline] = ((dataa[lpm_width-1] == datab[lpm_width-1]) &&
                                                   (dataa[lpm_width-1] != tmp_result[lpm_width-1])) ?
                                                  1 : 0;
                end
                else if ((lpm_direction == "SUB") || ((i_add_sub == 0) &&
                        ((lpm_direction == "UNUSED") || (lpm_direction == "DEFAULT")) ))
                begin
                    tmp_result = dataa - datab - borrow;
                    tmp_overflow2[lpm_pipeline] = ((dataa[lpm_width-1] != datab[lpm_width-1]) &&
                                                   (dataa[lpm_width-1] != tmp_result[lpm_width-1])) ?
                                                  1 : 0;
                end
                tmp_result2[lpm_pipeline] = tmp_result;
            end
        end
    end

    always @(posedge i_clock)
    begin
        if ((!i_aclr) && (i_clken == 1))
            for (i = 0; i < lpm_pipeline; i = i + 1)
            begin
                tmp_result2[i] <= tmp_result2[i+1];
                tmp_cout2[i] <= tmp_cout2[i+1];
                tmp_overflow2[i] <= tmp_overflow2[i+1];
            end
    end

// CONTINOUS ASSIGNMENT
    assign result = tmp_result2[0];
    assign cout = tmp_cout2[0];
    assign overflow = tmp_overflow2[0];

endmodule // lpm_add_sub
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_compare
//
// Description     :  Parameterized comparator megafunction. The comparator will
//                    compare between data[] and datab[] and return the status of
//                    comparation for the following operation.
//                    1) dataa[] < datab[].
//                    2) dataa[] == datab[].
//                    3) dataa[] > datab[].
//                    4) dataa[] >= datab[].
//                    5) dataa[] != datab[].
//                    6) dataa[] <= datab[].
//
// Limitation      :  n/a
//
// Results expected:  Return status bits of the comparision between dataa[] and
//                    datab[].
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_compare ( 
    dataa,   // Value to be compared to datab[]. (Required)
    datab,   // Value to be compared to dataa[]. (Required)
    clock,   // Clock for pipelined usage.
    aclr,    // Asynchronous clear for pipelined usage.
    clken,   // Clock enable for pipelined usage.
    
    // One of the following ports must be present.
    alb,     // High (1) if dataa[] < datab[].
    aeb,     // High (1) if dataa[] == datab[].
    agb,     // High (1) if dataa[] > datab[].
    aleb,    // High (1) if dataa[] <= datab[].
    aneb,    // High (1) if dataa[] != datab[].
    ageb     // High (1) if dataa[] >= datab[].
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;  // Width of the dataa[] and datab[] ports. (Required)
    parameter lpm_representation = "UNSIGNED"; // Type of comparison performed: 
                                               // "SIGNED", "UNSIGNED"
    parameter lpm_pipeline = 0; // Specifies the number of Clock cycles of latency
                                // associated with the alb, aeb, agb, ageb, aleb,
                                //  or aneb output.
    parameter lpm_type = "lpm_compare";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION   
    input  [lpm_width-1:0] dataa;
    input  [lpm_width-1:0] datab;
    input  clock;
    input  aclr;
    input  clken;
    
// OUTPUT PORT DECLARATION
    output alb;
    output aeb;
    output agb;
    output aleb;
    output aneb;
    output ageb;

// INTERNAL REGISTERS DECLARATION
    reg [lpm_pipeline:0] tmp_alb2;
    reg [lpm_pipeline:0] tmp_aeb2;
    reg [lpm_pipeline:0] tmp_agb2;
    reg [lpm_pipeline:0] tmp_aleb2;
    reg [lpm_pipeline:0] tmp_aneb2;
    reg [lpm_pipeline:0] tmp_ageb2;

// LOCAL INTEGER DECLARATION
    integer i;

// INTERNAL TRI DECLARATION
    tri0 aclr;
    tri0 clock;
    tri1 clken;

    buf (i_aclr, aclr);
    buf (i_clock, clock);
    buf (i_clken, clken);

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if ((lpm_representation != "SIGNED") &&
            (lpm_representation != "UNSIGNED"))
        begin
            $display("Error!  LPM_REPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");
            $finish;
        end    
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $finish;
        end
    end

// ALWAYS CONSTRUCT BLOCK
    // get the status of comparison 
    always @(dataa or datab or i_aclr)
    begin
        if (i_aclr) // reset all variables
            for (i = 0; i <= lpm_pipeline; i = i + 1)
            begin
                tmp_aeb2[i] = 'b0;
                tmp_agb2[i] = 'b0;
                tmp_alb2[i] = 'b0;
                tmp_aleb2[i] = 'b0;
                tmp_aneb2[i] = 'b0;
                tmp_ageb2[i] = 'b0;
            end
        else
        begin
            tmp_aeb2[lpm_pipeline] = (dataa == datab);
            tmp_aneb2[lpm_pipeline] = (dataa != datab);
    
            if ((lpm_representation == "SIGNED") &&
                (dataa[lpm_width-1] ^ datab[lpm_width-1]) == 1)
            begin
                // create latency
                tmp_alb2[lpm_pipeline] = (dataa > datab);
                tmp_agb2[lpm_pipeline] = (dataa < datab);
                tmp_aleb2[lpm_pipeline] = (dataa >= datab);
                tmp_ageb2[lpm_pipeline] = (dataa <= datab);
            end
            else
            begin
            // create latency   
                tmp_alb2[lpm_pipeline] = (dataa < datab);
                tmp_agb2[lpm_pipeline] = (dataa > datab);
                tmp_aleb2[lpm_pipeline] = (dataa <= datab);
                tmp_ageb2[lpm_pipeline] = (dataa >= datab);
            end
        end
    end

    // pipelining process
    always @(posedge i_clock)
    begin
        if ((!i_aclr) && (i_clken == 1))
            for (i = 0; i < lpm_pipeline; i = i + 1)
            begin
                tmp_alb2[i] <= tmp_alb2[i+1];
                tmp_aeb2[i] <= tmp_aeb2[i+1];
                tmp_agb2[i] <= tmp_agb2[i+1];
                tmp_aleb2[i] <= tmp_aleb2[i+1];
                tmp_aneb2[i] <= tmp_aneb2[i+1];
                tmp_ageb2[i] <= tmp_ageb2[i+1];
            end
    end

// CONTINOUS ASSIGNMENT
    assign alb = tmp_alb2[0];
    assign aeb = tmp_aeb2[0];
    assign agb = tmp_agb2[0];
    assign aleb = tmp_aleb2[0];
    assign aneb = tmp_aneb2[0];
    assign ageb = tmp_ageb2[0];

endmodule // lpm_compare

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_mult
//
// Description     :  Parameterized multiplier megafunction.
//
// Limitation      :  n/a
//
// Results expected:  dataa[] * datab[] + sum[].
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_mult ( 
    dataa,  // Multiplicand. (Required)
    datab,  // Multiplier. (Required)
    sum,    // Partial sum.
    aclr,   // Asynchronous clear for pipelined usage.
    clock,  // Clock for pipelined usage.
    clken,  // Clock enable for pipelined usage.
    result  // result = dataa[] * datab[] + sum. The product LSB is aligned with the sum LSB.
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_widtha = 1; // Width of the dataa[] port. (Required)
    parameter lpm_widthb = 1; // Width of the datab[] port. (Required)
    parameter lpm_widthp = 1; // Width of the result[] port. (Required)
    parameter lpm_widths = 1; // Width of the sum[] port. (Required)
    parameter lpm_representation  = "UNSIGNED"; // Type of multiplication performed
    parameter lpm_pipeline  = 0; // Number of clock cycles of latency 
    parameter lpm_type = "lpm_mult";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION    
    input  [lpm_widtha-1:0] dataa;
    input  [lpm_widthb-1:0] datab;
    input  [lpm_widths-1:0] sum;
    input  aclr;
    input  clock;
    input  clken;
    
// OUTPUT PORT DECLARATION    
    output [lpm_widthp-1:0] result;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg [lpm_widthp-1:0] resulttmp [lpm_pipeline:0];
    reg [lpm_widthp-1:0] i_prod;
    reg [lpm_widthp-1:0] t_p;
    reg [lpm_widths-1:0] i_prod_s;
    reg [lpm_widths-1:0] t_s;
    reg [lpm_widtha+lpm_widthb-1:0] i_prod_ab;
    reg [lpm_widtha-1:0] t_a;
    reg [lpm_widthb-1:0] t_b;
    reg sign_ab;
    reg sign_s;

// LOCAL INTEGER DECLARATION
    integer i;

// INTERNAL TRI DECLARATION
    tri0 aclr;
    tri0 clock;
    tri1 clken;

    buf (i_aclr, aclr);
    buf (i_clock, clock);
    buf (i_clken, clken);

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        // check if lpm_widtha > 0
        if (lpm_widtha <= 0)
        begin
            $display("Error!  lpm_widtha must be greater than 0.\n");
            $finish;
        end    
        // check if lpm_widthb > 0
        if (lpm_widthb <= 0)
        begin
            $display("Error!  lpm_widthb must be greater than 0.\n");
            $finish;
        end
        // check if lpm_widthp > 0
        if (lpm_widthp <= 0)
        begin
            $display("Error!  lpm_widthp must be greater than 0.\n");
            $finish;
        end
        // check if lpm_widthp > 0
        if (lpm_widths <= 0)
        begin
            $display("Error!  lpm_widths must be greater than 0.\n");
            $finish;
        end
        // check for valid lpm_rep value
        if ((lpm_representation != "SIGNED") && (lpm_representation != "UNSIGNED"))
        begin
            $display("Error!  lpm_representation value must be \"SIGNED\" or \"UNSIGNED\".", $time);
            $finish;
        end
    end

// ALWAYS CONSTRUCT BLOCK
    always @(dataa or datab or sum or i_aclr)
    begin
        if (i_aclr) // clear the pipeline for result to 0
            for (i = 0; i <= lpm_pipeline; i = i + 1)
                resulttmp[i] = 'b0;
        else
        begin
            t_a = dataa;
            t_b = datab;
            t_s = sum;
            sign_ab = 0;
            sign_s = 0;

            // if inputs are sign number    
            if (lpm_representation == "SIGNED")
            begin
                sign_ab = dataa[lpm_widtha-1] ^ datab[lpm_widthb-1];
                sign_s = sum[lpm_widths-1];

                // if negative number, represent them as 2 compliment number.
                if (dataa[lpm_widtha-1] == 1)
                    t_a = (~dataa) + 1;
                if (datab[lpm_widthb-1] == 1)
                    t_b = (~datab) + 1;
                if (sum[lpm_widths-1] == 1)
                    t_s = (~sum) + 1;
            end
    
            // if sum port is not used
            if (sum === {lpm_widths{1'bz}})
            begin
                t_s = 0;
                sign_s = 0;
            end

            if (sign_ab == sign_s)
            begin
                i_prod = (t_a * t_b) + t_s;
                i_prod_s = (t_a * t_b) + t_s;
                i_prod_ab = (t_a * t_b) + t_s;
            end
            else
            begin
                i_prod = (t_a * t_b) - t_s;
                i_prod_s = (t_a * t_b) - t_s;
                i_prod_ab = (t_a * t_b) - t_s;
            end

            // if dataa[] * datab[] produces negative number, compliment the result
            if (sign_ab)
            begin
                i_prod = (~i_prod) + 1;
                i_prod_s = (~i_prod_s) + 1;
                i_prod_ab = (~i_prod_ab) + 1;
            end

            if ((lpm_widthp < lpm_widths) || (lpm_widthp < lpm_widtha+lpm_widthb))
                for (i = 0; i < lpm_widthp; i = i + 1)
                    i_prod[lpm_widthp-1-i] = (lpm_widths > lpm_widtha+lpm_widthb)
                                             ? i_prod_s[lpm_widths-1-i]
                                             : i_prod_ab[lpm_widtha+lpm_widthb-1-i];
                                             
            // pipelining the result
            resulttmp[lpm_pipeline] = i_prod;
        end
    end

    always @(posedge i_clock)
    begin
        if (!i_aclr && i_clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
                resulttmp[i] <= resulttmp[i+1];
    end

// CONTINOUS ASSIGNMENT
    assign result = resulttmp[0];

endmodule // lpm_mult
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_divide
//
// Description     :  Parameterized divider megafunction. This function performs a
//                    divide operation such that denom * quotient + remain = numer
//                    The function allows for all combinations of signed(two's 
//                    complement) and unsigned inputs. If any of the inputs is 
//                    signed, the output is signed. Otherwise the output is unsigned.
//                    The function also allows the remainder to be specified as
//                    always positive (in which case remain >= 0); otherwise remain
//                    is zero or the same sign as the numerator
//                    (this parameter is ignored in the case of purely unsigned
//                    division). Finally the function is also pipelinable.
//
// Limitation      :  n/a
//
// Results expected:  Return quotient and remainder. 
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_divide ( 
    numer,  // The numerator (Required)
    denom,  // The denominator (Required)
    clock,  // Clock input for pipelined usage
    aclr,   // Asynchronous clear signal
    clken,  // Clock enable for pipelined usage.
    quotient, // Quotient (Required)
    remain    // Remainder (Required)
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_widthn = 1;  // Width of the numer[] and quotient[] port. (Required)
    parameter lpm_widthd = 1;  // Width of the denom[] and remain[] port. (Required)
    parameter lpm_nrepresentation = "UNSIGNED";  // The representation of numer
    parameter lpm_drepresentation = "UNSIGNED";  // The representation of denom
    parameter lpm_pipeline = 0; // Number of Clock cycles of latency
    parameter lpm_type = "lpm_divide";
    parameter lpm_hint = "LPM_REMAINDERPOSITIVE=TRUE";

// INPUT PORT DECLARATION
    input  [lpm_widthn-1:0] numer;
    input  [lpm_widthd-1:0] denom;
    input  clock;
    input  aclr;
    input  clken;

// OUTPUT PORT DECLARATION
    output [lpm_widthn-1:0] quotient;
    output [lpm_widthd-1:0] remain;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg [lpm_widthn-1:0] tmp_quotient [lpm_pipeline:0];
    reg [lpm_widthd-1:0] tmp_remain [lpm_pipeline:0];
    reg [lpm_widthn-1:0] ZEROS;
    reg [lpm_widthd-1:0] RZEROS;
    reg [lpm_widthn-1:0] not_numer, int_numer;
    reg [lpm_widthd-1:0] not_denom, int_denom;
    reg [lpm_widthn-1:0] t_numer, t_q;
    reg [lpm_widthd-1:0] t_denom, t_r;
    reg sign_q, sign_r, sign_n, sign_d;
    reg [8*5:1] lpm_remainderpositive;


// LOCAL INTEGER DECLARATION
    integer i;
    integer rsig;

// INTERNAL TRI DECLARATION
    tri0 aclr;
    tri0 clock;
    tri1 clken;

    buf (i_aclr, aclr);
    buf (i_clock, clock);
    buf (i_clken, clken);

// COMPONENT INSTANTIATIONS
    LPM_HINT_EVALUATION eva();


// INITIAL CONSTRUCT BLOCK
    initial
    begin
        // check if lpm_widthn > 0
        if (lpm_widthn <= 0)
        begin
            $display("Error!  LPM_WIDTHN must be greater than 0.\n");
            $finish;
        end
        // check if lpm_widthd > 0
        if (lpm_widthd <= 0)
        begin
            $display("Error!  LPM_WIDTHD must be greater than 0.\n");
            $finish;
        end
        // check for valid lpm_nrepresentation value
        if ((lpm_nrepresentation != "SIGNED") && (lpm_nrepresentation != "UNSIGNED"))
        begin
            $display("Error!  LPM_NREPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");
            $finish;
        end
        // check for valid lpm_drepresentation value
        if ((lpm_drepresentation != "SIGNED") && (lpm_drepresentation != "UNSIGNED"))
        begin
            $display("Error!  LPM_DREPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");
            $finish;
        end
        // check for valid lpm_remainderpositive value
        lpm_remainderpositive = eva.GET_PARAMETER_VALUE(lpm_hint, "LPM_REMAINDERPOSITIVE");
        if ((lpm_remainderpositive == "TRUE") && 
            (lpm_remainderpositive == "FALSE"))
        begin
            $display("Error!  LPM_REMAINDERPOSITIVE value must be \"TRUE\" or \"FALSE\".");
            $finish;
        end
     
        for (i=0; i < lpm_widthn; i=i+1)
            ZEROS[i] = 1'b0;
    
        for (i=0; i < lpm_widthd; i=i+1)
            RZEROS[i] = 1'b0;
    end

// ALWAYS CONSTRUCT BLOCK
    always @(numer or denom or i_aclr)
    begin
        if (i_aclr)
        begin
            for (i = 0; i <= lpm_pipeline; i = i + 1)
                tmp_quotient[i] = ZEROS;
            tmp_remain[i] = RZEROS;
        end
        else
        begin
            sign_q = 0;
            sign_r = 0;
            sign_n = 0;
            sign_d = 0;
            t_numer = numer; 
            t_denom = denom;

            if (lpm_nrepresentation == "SIGNED")
                if (numer[lpm_widthn-1] == 1)
                begin
                    t_numer = ~numer + 1;  // numer is negative number
                    sign_n = 1;
                end
                
            if (lpm_drepresentation == "SIGNED")
                if (denom[lpm_widthd-1] == 1)
                begin
                    t_denom = ~t_denom + 1; // denom is negative numbrt
                    sign_d = 1;
                end
    
            t_q = t_numer / t_denom; // get quotient
            t_r = t_numer % t_denom; // get remainder
            sign_q = sign_n ^ sign_d;
            sign_r = (t_r != 0) ? sign_n : 0;    
            
            // Pipeline the result
            tmp_quotient[lpm_pipeline] = (sign_q == 1) ? (~t_q + 1) : t_q;
            tmp_remain[lpm_pipeline]   = (sign_r == 1) ? (~t_r + 1) : t_r;

            // Recalculate the quotient and remainder if remainder is negative number
            // and LPM_REMAINDERPOSITIVE=TRUE.
            if ((sign_r) && (lpm_remainderpositive == "TRUE"))
            begin
                tmp_quotient[lpm_pipeline] = tmp_quotient[lpm_pipeline] + 
                                         ((sign_d == 1) ? 1 : -1 );
                tmp_remain[lpm_pipeline] = tmp_remain[lpm_pipeline] + t_denom;
            end 
        end
    end

    always @(posedge i_clock)
    begin
        if (!i_aclr && i_clken)
            for (i = 0; i < lpm_pipeline; i = i + 1)
            begin
                tmp_quotient[i] <= tmp_quotient[i+1];
                tmp_remain[i] <= tmp_remain[i+1];
            end
    end

// CONTINOUS ASSIGNMENT
    assign quotient = tmp_quotient[0];
    assign remain = tmp_remain[0];

endmodule // lpm_divide
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_abs
//
// Description     :  Parameterized absolute value megafunction. This megafunction
//                    requires the input data to be signed number. 
//
// Limitation      :  n/a
//
// Results expected:  Return absolute value of data and the overflow status
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_abs ( 
    data,     // Signed number (Required)    
    result,   // Absolute value of data[].
    overflow  // High if data = -2 ^ (LPM_WIDTH-1).
);

// GLOBAL PARAMETER DECLARATION    
    parameter lpm_width = 1; // Width of the data[] and result[] ports.(Required)
    parameter lpm_type = "lpm_abs";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION 
    input  [lpm_width-1:0] data;

// OUTPUT PORT DECLARATION    
    output [lpm_width-1:0] result;   
    output overflow;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg [lpm_width-1:0] result;
    reg [lpm_width-1:0] not_r;
    reg overflow;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $finish;
        end
    end

// ALWAYS CONSTRUCT BLOCK
    always @(data)
    begin
        overflow = 0;
        result = data;
        not_r = ~data;

        if (data[lpm_width-1] == 1)
        begin
            result = (not_r) + 1;
            overflow = (result == (1<<(lpm_width-1)));
        end
    end

endmodule // lpm_abs

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_counter
//
// Description     :  Parameterized counter megafunction. The lpm_counter
//                    megafunction is a binary counter that features an up, 
//                    down, or up/down counter with optional synchronous or
//                    asynchronous clear, set, and load ports.
//
// Limitation      :  n/a
//
// Results expected:  Data output from the counter and carry-out of the MSB.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_counter ( 
    clock,   // Positive-edge-triggered clock. (Required)
    clk_en,  // Clock enable input. Enables all synchronous activities.
    cnt_en,  // Count enable input. Disables the count when low (0) without 
             // affecting sload, sset, or sclr.
    updown,  // Controls the direction of the count. High (1) = count up. 
             //                                      Low (0) = count down.
    aclr,    // Asynchronous clear input.
    aset,    // Asynchronous set input.
    aload,   // Asynchronous load input. Asynchronously loads the counter with
             // the value on the data input.
    sclr,    // Synchronous clear input. Clears the counter on the next active 
             // clock edge.
    sset,    // Synchronous set input. Sets the counter on the next active clock edge.
    sload,   // Synchronous load input. Loads the counter with data[] on the next
             // active clock edge.
    data,    // Parallel data input to the counter.
    cin,     // Carry-in to the low-order bit.
    q,       // Data output from the counter.
    cout,    // Carry-out of the MSB.
    eq       // Counter decode output. Active high when the counter reaches the specified
             // count value.
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;  //The number of bits in the count, or the width of the q[]
                              // and data[] ports, if they are used. (Required)
    parameter lpm_direction = "UNUSED";  // Direction of the count.
    parameter lpm_modulus = 0;           // The maximum count, plus one.
    parameter lpm_avalue = "UNUSED";     // Constant value that is loaded when aset is high.
    parameter lpm_svalue = "UNUSED";     // Constant value that is loaded on the rising edge
                                         // of clock when sset is high.
    parameter lpm_pvalue = "UNUSED";
    parameter lpm_type = "lpm_counter";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  clock; 
    input  clk_en;
    input  cnt_en;
    input  updown;
    input  aclr;
    input  aset;
    input  aload;
    input  sclr;
    input  sset;
    input  sload;
    input  [lpm_width-1:0] data;
    input  cin;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] q;
    output cout;
    output [15:0] eq;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg  [lpm_width-1:0] tmp_count;
    reg  prev_clock;
    reg  tmp_updown;
    reg  [lpm_width-1:0] ONES;
    reg  [lpm_width:0] tmp_modulus;
    reg  [lpm_width:0] MAX_MODULUS;

// LOCAL INTEGER DECLARATION
    integer i;

// INTERNAL TRI DECLARATION

    tri1 clk_en;
    tri1 cnt_en;
    tri0 aclr;
    tri0 aset;
    tri0 aload;
    tri0 sclr;
    tri0 sset;
    tri0 sload;
    tri1 cin;
    tri1 updown_z;

    buf (i_clk_en, clk_en);
    buf (i_cnt_en, cnt_en);
    buf (i_aclr, aclr);
    buf (i_aset, aset);
    buf (i_aload, aload);
    buf (i_sclr, sclr);
    buf (i_sset, sset);
    buf (i_sload, sload);
    buf (i_cin, cin);
    buf (i_updown, updown_z);

// FUNCTON DECLARATION
    // Convert string to integer
    function integer str_to_int;
        input [8*16:1] s; 

        reg [8*16:1] reg_s;
        reg [8:1] digit;
        reg [8:1] tmp;
        integer m, ivalue;
        
        begin
            ivalue = 0;
            reg_s = s;
            for (m=1; m<=16; m=m+1)
            begin 
                tmp = reg_s[128:121];
                digit = tmp & 8'b00001111;
                reg_s = reg_s << 8; 
                ivalue = ivalue * 10 + digit; 
            end
            str_to_int = ivalue;
        end
    endfunction

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        MAX_MODULUS = 1 << lpm_width;

        // check if lpm_width < 0
        if (lpm_width <= 0)
        begin
            $display("Error!  LPM_WIDTH must be greater than 0.\n");
            $finish;
        end

        // check if lpm_modulus < 0
        if (lpm_modulus < 0)
        begin
            $display("Error!  LPM_MODULUS must be greater or equal to 0.\n");
            $finish;
        end
        // check if lpm_modulus > 1<<lpm_width
        if (lpm_modulus > MAX_MODULUS)
        begin
            $display("Error!  LPM_MODULUS must be less than or equal to 1<<LPM_WIDTH.\n");
            $finish;
        end 
        // check if lpm_direction valid
        if ((lpm_direction != "UNUSED") && (lpm_direction != "DEFAULT") &&
             (lpm_direction != "UP") && (lpm_direction != "DOWN"))
        begin
            $display("Error!  LPM_DIRECTION must be \"UP\" or \"DOWN\" if used.\n");
            $finish;
        end

        for (i=0; i < lpm_width; i=i+1)
            ONES[i] = 1'b1;

        tmp_modulus = (lpm_width == 0) ? MAX_MODULUS : lpm_modulus;
        tmp_count = (lpm_pvalue == "UNUSED") ? 0 : str_to_int(lpm_pvalue);
        prev_clock = 1'b0;
        tmp_updown = 0;
    end

    // NCSIM will only assigns 1'bZ to unconnected port at time 0fs + 1
    initial #0
    begin
       // // check if lpm_direction valid
       if ((lpm_direction != "UNUSED") && (lpm_direction != "DEFAULT") && (updown !== 1'bz))
       begin
            $display("Error!  LPM_DIRECTION and UPDOWN cannot be used at the same time.\n");
            $finish;
       end
    end

// ALWAYS CONSTRUCT BLOCK
    always @(i_aclr or i_aset or i_aload or data or clock or i_updown)
    begin

        tmp_updown <= ((((lpm_direction == "UNUSED") || (lpm_direction == "DEFAULT")) && (i_updown == 1)) ||
                       (lpm_direction == "UP"))
                     ? 1 : 0;
                     
        if (i_aclr)
            tmp_count <= 0;
        else if (i_aset)
            tmp_count <= (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                                 : str_to_int(lpm_avalue);
        else if (i_aload)
            tmp_count <= data;
        else if ((clock === 1) && (prev_clock !== 1) && ($time > 0))
        begin
            if (i_clk_en)
            begin
                if (i_sclr)
                    tmp_count <= 0;
                else if (i_sset)
                    tmp_count <= (lpm_svalue == "UNUSED") ? {lpm_width{1'b1}}
                                                         : str_to_int(lpm_svalue);
                else if (i_sload)
                    tmp_count <= data;
                else if (i_cnt_en && i_cin)
                begin
                    if ((((lpm_direction == "UNUSED") || (lpm_direction == "DEFAULT")) && (i_updown == 1)) ||
                       (lpm_direction == "UP"))
                        tmp_count <= (tmp_count == tmp_modulus-1) ? 0
                                                                 : tmp_count+1;
                    else
                        tmp_count <= (tmp_count == 0) ? tmp_modulus-1
                                                     : tmp_count-1;
                end
            end
        end

        prev_clock <= clock;
    end


// CONTINOUS ASSIGNMENT
    assign q = tmp_count;
    assign cout = (i_cin && (((tmp_updown==0) && (tmp_count==0)) ||
                             ((tmp_updown==1) && ((tmp_count==tmp_modulus-1) ||
                                                (tmp_count==ONES))) ))
                    ? 1 : 0;
    assign updown_z = updown;
    assign eq = {16{1'b0}};
                    
endmodule // lpm_counter
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_latch
//
// Description     :  Parameterized latch megafunction.
//
// Limitation      :  n/a
//
// Results expected:  Data output from the latch.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_latch (
    data,  // Data input to the latch.
    gate,  // Latch enable input. High = flow-through, low = latch. (Required)
    aclr,  // Asynchronous clear input.
    aset,  // Asynchronous set input.
    aconst,
    q      // Data output from the latch.
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;         // Width of the data[] and q[] ports. (Required)
    parameter lpm_avalue = "UNUSED"; // Constant value that is loaded when aset is high.
    parameter lpm_pvalue = "UNUSED";
    parameter lpm_type = "lpm_latch";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] data;
    input  gate;
    input  aclr;
    input  aset;
    input aconst;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] q;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg [lpm_width-1:0] q;

// INTERNAL TRI DECLARATION
    tri0 [lpm_width-1:0] data;
    tri0 aclr;
    tri0 aset;
    tri0 aconst;

    buf (i_aclr, aclr);
    buf (i_aset, aset);

// FUNCTON DECLARATION
    // convert string to integer
    function integer str_to_int;
        input [8*16:1] s;

        reg [8*16:1] reg_s;
        reg [8:1] digit;
        reg [8:1] tmp;
        integer m, ivalue;

        begin
            ivalue = 0;
            reg_s = s;
            for (m=1; m<=16; m= m+1)
            begin
                tmp = reg_s[128:121];
                digit = tmp & 8'b00001111;
                reg_s = reg_s << 8;
                ivalue = ivalue * 10 + digit;
            end
            str_to_int = ivalue;
        end
    endfunction


// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0 (ERROR)");
            $finish;
        end

        if (lpm_pvalue != "UNUSED")
            q = str_to_int(lpm_pvalue);
    end

// ALWAYS CONSTRUCT BLOCK
    always @(data or gate or i_aclr or i_aset)
    begin
        if (i_aclr)
            q = 'b0;
        else if (i_aset)
            q = (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                         : str_to_int(lpm_avalue);
        else if (gate)
            q = data;
    end

endmodule // lpm_latch

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_ff
//
// Description     :  Parameterized flipflop megafunction. The lpm_ff function
//                    contains features that are not available in the DFF, DFFE,
//                    DFFEA, TFF, and TFFE primitives, such as synchronous or
//                    asynchronous set, clear, and load inputs.

//
// Limitation      :  n/a
//
// Results expected:  Data output from D or T flipflops. 
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_ff (
    data,     // T-type flipflop: Toggle enable
              // D-type flipflop: Data input
                           
    clock,    // Positive-edge-triggered clock. (Required)
    enable,   // Clock enable input.
    aclr,     // Asynchronous clear input.
    aset,     // Asynchronous set input.
    
    aload,    // Asynchronous load input. Asynchronously loads the flipflop with
              // the value on the data input.
              
    sclr,     // Synchronous clear input.
    sset,     // Synchronous set input.
    
    sload,    // Synchronous load input. Loads the flipflop with the value on the
              // data input on the next active clock edge.
              
    q         // Data output from D or T flipflops. (Required)
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width  = 1; // Width of the data[] and q[] ports. (Required)
    parameter lpm_avalue = "UNUSED"; // Constant value that is loaded when aset is high.
    parameter lpm_svalue = "UNUSED"; // Constant value that is loaded on the rising edge
                                     // of clock when sset is high.
    parameter lpm_pvalue = "UNUSED";
    parameter lpm_fftype = "DFF";    // Type of flipflop
    parameter lpm_type = "lpm_ff";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] data;
    input  clock;
    input  enable;
    input  aclr;
    input  aset;
    input  aload;
    input  sclr;
    input  sset;
    input  sload ;
    
// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] q;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg  [lpm_width-1:0] tmp_q;
    reg  prev_clock;
    
// LOCAL INTEGER DECLARATION
    integer i;

// INTERNAL TRI DECLARATION
    tri1 enable;
    tri0 sload;
    tri0 sclr;
    tri0 sset;
    tri0 aload;
    tri0 aclr;
    tri0 aset;
      
    buf (i_enable, enable);
    buf (i_sload, sload);
    buf (i_sclr, sclr);
    buf (i_sset, sset);
    buf (i_aload, aload);
    buf (i_aclr, aclr);
    buf (i_aset, aset);

// FUNCTON DECLARATION
    function integer str_to_int;
        input [8*16:1] s; 
        
        reg [8*16:1] reg_s;
        reg [8:1] digit;
        reg [8:1] tmp;
        integer m, ivalue; 
        
        begin
            ivalue = 0;
            reg_s = s;
            for (m=1; m<=16; m= m+1) 
            begin 
                tmp = reg_s[128:121];
                digit = tmp & 8'b00001111;
                reg_s = reg_s << 8; 
                ivalue = (ivalue * 10) + digit; 
            end
            str_to_int = ivalue;
        end
    endfunction

// INITIAL CONSTRUCT BLOCK
    initial
    begin
    
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $finish;
        end
        
        if ((lpm_fftype != "DFF") &&
            (lpm_fftype != "TFF") &&
            (lpm_fftype != "UNUSED"))          // non-LPM 220 standard
        begin
            $display("Error!  LPM_FFTYPE value must be \"DFF\" or \"TFF\".");
            $finish;
        end

        tmp_q = (lpm_pvalue == "UNUSED") ? 0 : str_to_int(lpm_pvalue);
    end

// ALWAYS CONSTRUCT BLOCK
    always @(i_aclr or i_aset or i_aload or data or clock)
    begin // Asynchronous process
        if (i_aclr)
            tmp_q <= (i_aset) ? 'bx : 0;
        else if (i_aset)
            tmp_q <= (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                             : str_to_int(lpm_avalue);
        else if (i_aload)
            tmp_q <= data;
        else if ((clock === 1) && (prev_clock !== 1) && ($time > 0))
        begin // Synchronous process
            if (i_enable)
            begin
                if (i_sclr)
                    tmp_q <= 0;
                else if (i_sset)
                    tmp_q <= (lpm_svalue == "UNUSED") ? {lpm_width{1'b1}}
                                                     : str_to_int(lpm_svalue);
                else if (i_sload)  // Load data
                    tmp_q <= data;
                else
                begin
                    if (lpm_fftype == "TFF") // toggle
                    begin
                        for (i = 0; i < lpm_width; i=i+1)
                            if (data[i] == 1'b1) 
                                tmp_q[i] <= ~tmp_q[i];
                    end
                    else    // DFF, load data
                        tmp_q <= data;
                end
            end
        end
        prev_clock <= clock;
    end

// CONTINOUS ASSIGNMENT
    assign q = tmp_q;
    
endmodule // lpm_ff
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_shiftreg
//
// Description     :  Parameterized shift register megafunction.
//
// Limitation      :  n/a
//
// Results expected:  Data output from the shift register and the Serial shift data output.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_shiftreg (
    data,     // Data input to the shift register.
    clock,    // Positive-edge-triggered clock. (Required)
    enable,   // Clock enable input
    shiftin,  // Serial shift data input.
    load,     // Synchronous parallel load. High (1): load operation;
              //                            low (0): shift operation.
    aclr,     // Asynchronous clear input.
    aset,     // Asynchronous set input.
    sclr,     // Synchronous clear input.
    sset,     // Synchronous set input.
    q,        // Data output from the shift register.
    shiftout  // Serial shift data output.
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width  = 1;  // Width of the data[] and q ports. (Required)
    parameter lpm_direction = "LEFT";  // Values are "LEFT", "RIGHT", and "UNUSED".
    parameter lpm_avalue = "UNUSED"; // Constant value that is loaded when aset is high.
    parameter lpm_svalue = "UNUSED"; // Constant value that is loaded on the rising edge
                                     // of clock when sset is high.
    parameter lpm_pvalue = "UNUSED";
    parameter lpm_type = "lpm_shiftreg";
    parameter lpm_hint  = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] data;
    input  clock;
    input  enable;
    input  shiftin;
    input  load;
    input  aclr;
    input  aset;
    input  sclr;
    input  sset;


// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] q;
    output shiftout;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg  [lpm_width-1:0] tmp_q;
    reg  abit;

// LOCAL INTEGER DECLARATION
    integer i;

// INTERNAL WIRE DECLARATION
    wire tmp_shiftout;

// INTERNAL TRI DECLARATION
    tri1 enable;
    tri1 shiftin;
    tri0 load;
    tri0 aclr;
    tri0 aset;
    tri0 sclr;
    tri0 sset;

    buf (i_enable, enable);
    buf (i_shiftin, shiftin);
    buf (i_load, load);
    buf (i_aclr, aclr);
    buf (i_aset, aset);
    buf (i_sclr, sclr);
    buf (i_sset, sset);

// FUNCTON DECLARATION
    // Convert string to integer
    function integer str_to_int;
        input [8*16:1] s;

        reg [8*16:1] reg_s;
        reg [8:1] digit;
        reg [8:1] tmp;
        integer m, ivalue;

        begin
            ivalue = 0;
            reg_s = s;
            for (m=1; m<=16; m= m+1)
            begin
                tmp = reg_s[128:121];
                digit = tmp & 8'b00001111;
                reg_s = reg_s << 8;
                ivalue = ivalue * 10 + digit;
            end
            str_to_int = ivalue;
        end
    endfunction


// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0 (ERROR)");
            $finish;
        end

        if ((lpm_direction != "LEFT") &&
            (lpm_direction != "RIGHT") &&
            (lpm_direction != "UNUSED"))          // non-LPM 220 standard
        begin
            $display("Error!  LPM_DIRECTION value must be \"LEFT\" or \"RIGHT\".");
            $finish;
        end

        tmp_q = (lpm_pvalue == "UNUSED") ? 0 : str_to_int(lpm_pvalue);
    end

// ALWAYS CONSTRUCT BLOCK
    always @(i_aclr or i_aset)
    begin
        if (i_aclr)
            tmp_q <= (i_aset) ? 'bx : 0;
        else if (i_aset)
            tmp_q <= (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                             : str_to_int(lpm_avalue);
    end

    always @(posedge clock)
    begin
        if (i_aclr)
            tmp_q <= (i_aset) ? 'bx : 0;
        else if (i_aset)
            tmp_q <= (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                             : str_to_int(lpm_avalue);
        else
        begin
            if (i_enable)
            begin
                if (i_sclr)
                    tmp_q <= 0;
                else if (i_sset)
                    tmp_q <= (lpm_svalue == "UNUSED") ? {lpm_width{1'b1}}
                                                     : str_to_int(lpm_svalue);
                else if (i_load)
                    tmp_q <= data;
                else if (!i_load)
                begin
                    if ((lpm_direction == "LEFT") || (lpm_direction == "UNUSED"))
                        {abit,tmp_q} <= {tmp_q,i_shiftin};
                    else if (lpm_direction == "RIGHT")
                        {tmp_q,abit} <= {i_shiftin,tmp_q};
                end
            end
        end
    end

// CONTINOUS ASSIGNMENT
    assign tmp_shiftout = (lpm_direction == "RIGHT") ? tmp_q[0]
                                                     : tmp_q[lpm_width-1];
    assign q = tmp_q;
    assign shiftout = tmp_shiftout;

endmodule // lpm_shiftreg
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_ram_dq
//
// Description     :  Parameterized RAM with separate input and output ports megafunction.
//                    lpm_ram_dq implement asynchronous memory or memory with synchronous
//                    inputs and/or outputs.
//
// Limitation      :  n/a
//
// Results expected:  Data output from the memory.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_ram_dq (
    data,      // Data input to the memory. (Required)
    address,   // Address input to the memory. (Required)
    inclock,   // Synchronizes memory loading.
    outclock,  // Synchronizes q outputs from memory.
    we,        // Write enable input. Enables write operations to the memory when high. (Required)
    q          // Data output from the memory. (Required)
);

// GLOBAL PARAMETER DECLARATION
  parameter lpm_width = 1;  // Width of data[] and q[] ports. (Required)
  parameter lpm_widthad = 1; // Width of the address port. (Required)
  parameter lpm_numwords = 1 << lpm_widthad; // Number of words stored in memory.
  parameter lpm_indata = "REGISTERED";  // Controls whether the data port is registered.
  parameter lpm_address_control = "REGISTERED"; // Controls whether the address and we ports are registered.
  parameter lpm_outdata = "REGISTERED"; // Controls whether the q ports are registered.
  parameter lpm_file = "UNUSED"; // Name of the file containing RAM initialization data.
  parameter use_eab = "ON"; // Specified whether to use the EAB or not.
  parameter intended_device_family = "APEX20KE";
  parameter lpm_type = "lpm_ram_dq";
  parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
  input  [lpm_width-1:0] data;
  input  [lpm_widthad-1:0] address;
  input  inclock;
  input  outclock;
  input  we;
  
// OUTPUT PORT DECLARATION
  output [lpm_width-1:0] q;


// INTERNAL REGISTER/SIGNAL DECLARATION
  reg  [lpm_width-1:0] mem_data [lpm_numwords-1:0];
  reg  [lpm_width-1:0] tmp_q;
  reg  [lpm_width-1:0] pdata;
  reg  [lpm_width-1:0] in_data;
  reg  [lpm_widthad-1:0] paddress;
  reg  pwe;
  reg  [lpm_width-1:0]  ZEROS, ONES, UNKNOWN;
  reg  [8*256:1] ram_initf;
  
// LOCAL INTEGER DECLARATION
  integer i;

// INTERNAL TRI DECLARATION
  tri0 inclock;
  tri0 outclock;

  buf (i_inclock, inclock);
  buf (i_outclock, outclock);
 
// COMPONENT INSTANTIATIONS
    LPM_DEVICE_FAMILIES dev ();

// FUNCTON DECLARATION
    // Check the validity of the address.
    function ValidAddress;
        input [lpm_widthad-1:0] paddress;

        begin
            ValidAddress = 1'b0;
            if (^paddress ==='bx)
                            $display("%t:Error!  Invalid address.\n", $time);
            else if (paddress >= lpm_numwords)
                            $display("%t:Error!  Address out of bound on RAM.\n", $time);
            else
                ValidAddress = 1'b1;
        end
  endfunction

// INITIAL CONSTRUCT BLOCK                
    initial
    begin

        // Initialize the internal data register.
        pdata = 0;
        paddress = 0;
        pwe = 0;

        if (lpm_width <= 0)
        begin
            $display("Error!  LPM_WIDTH parameter must be greater than 0.");
            $finish;
        end

        if (lpm_widthad <= 0)
        begin
            $display("Error!  LPM_WIDTHAD parameter must be greater than 0.");
            $finish;
        end
        
        // check for number of words out of bound
        if ((lpm_numwords > (1 << lpm_widthad)) ||
            (lpm_numwords <= (1 << (lpm_widthad-1))))
        begin
            $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHAD.");
            $finish;
        end
     
        if ((lpm_address_control != "REGISTERED") && (lpm_address_control != "UNREGISTERED"))
        begin
            $display("Error!  LPM_ADDRESS_CONTROL must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end
        
        if ((lpm_indata != "REGISTERED") && (lpm_indata != "UNREGISTERED"))
        begin
            $display("Error!  LPM_INDATA must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end
        
        if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED"))
        begin
            $display("Error!  LPM_OUTDATA must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end

        if (dev.IS_VALID_FAMILY(intended_device_family) == 0)
        begin
            $display ("Error! Unknown INTENDED_DEVICE_FAMILY=%s.", intended_device_family);
            $finish;
        end

        for (i=0; i < lpm_width; i=i+1)
        begin
            ZEROS[i] = 1'b0;
            ONES[i] = 1'b1;
            UNKNOWN[i] = 1'bX;
        end 
        
        for (i = 0; i < lpm_numwords; i=i+1)
            mem_data[i] = ZEROS;

        // load data to the RAM
        if (lpm_file != "UNUSED")
        begin
`ifdef NO_PLI
            $readmemh(lpm_file, mem_data);
`else
            $convert_hex2ver(lpm_file, lpm_width, ram_initf);
            $readmemh(ram_initf, mem_data);
`endif
        end 
        
        tmp_q = ZEROS;
    end

// ALWAYS CONSTRUCT BLOCK       
    always @(posedge i_inclock)
    begin
        if (lpm_address_control == "REGISTERED")
        begin
            if ((we) && (use_eab != "ON") &&  
                (lpm_hint != "USE_EAB=ON")) 
            begin
                if (lpm_indata == "REGISTERED")
                    mem_data[address] <= data;
                else
                    mem_data[address] <= pdata;
            end
            paddress <= address;
            pwe <= we;
        end
        if (lpm_indata == "REGISTERED")
            pdata <= data;
    end

    always @(data)
    begin
        if (lpm_indata == "UNREGISTERED")
            pdata <= data;
    end
    
    always @(address)
    begin
        if (lpm_address_control == "UNREGISTERED")
            paddress <= address;
    end
    
    always @(we)
    begin
        if (lpm_address_control == "UNREGISTERED")
            pwe <= we;
    end
    
    always @(pdata or paddress or pwe)
    begin :UNREGISTERED_INCLOCK
        if (ValidAddress(paddress))
        begin
            if ((lpm_address_control == "UNREGISTERED") && (pwe))
                mem_data[paddress] <= pdata;
            end
        else
        begin
            if (lpm_outdata == "UNREGISTERED")
                tmp_q <= UNKNOWN;
        end
    end

    always @(posedge i_outclock)
    begin
        if (lpm_outdata == "REGISTERED")
        begin
            if (ValidAddress(paddress))
                tmp_q <= mem_data[paddress];
            else
                tmp_q <= UNKNOWN;
        end
    end

    always @(negedge i_inclock or pdata)
    begin
        if ((lpm_address_control == "REGISTERED") && (pwe))
            if ((use_eab == "ON") || (lpm_hint == "USE_EAB=ON")) 
            begin
                if (i_inclock == 0) 
                    mem_data[paddress] = pdata;
            end
    end

// CONTINOUS ASSIGNMENT
    assign q = (lpm_outdata == "UNREGISTERED") ? mem_data[paddress] : tmp_q;

endmodule // lpm_ram_dq
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_ram_dp
//
// Description     :  Parameterized dual-port RAM megafunction.
//
// Limitation      :  n/a
//
// Results expected:  Data output from the memory.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_ram_dp (
    data,      // Data input to the memory. (Required)
    rdaddress, // Read address input to the memory. (Required)
    wraddress, // Write address input to the memory. (Required)
    rdclock,   // Positive-edge-triggered clock for read operation.
    rdclken,   // Clock enable for rdclock.
    wrclock,   // Positive-edge-triggered clock for write operation.
    wrclken,   // Clock enable for wrclock.
    rden,      // Read enable input. Disables reading when low (0). 
    wren,      // Write enable input. (Required)
    q          // Data output from the memory. (Required)
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;   // Width of the data[] and q[] ports. (Required)
    parameter lpm_widthad = 1; // Width of the rdaddress[] and wraddress[] ports. (Required)
    parameter lpm_numwords = 1 << lpm_widthad; // Number of words stored in memory.
    parameter lpm_indata = "REGISTERED"; // Determines the clock used by the data port.
    parameter lpm_rdaddress_control  = "REGISTERED"; // Determines the clock used by the rdaddress and rden ports.
    parameter lpm_wraddress_control  = "REGISTERED"; // Determines the clock used by the wraddress and wren ports. 
    parameter lpm_outdata = "REGISTERED"; // Determines the clock used by the q[] port. 
    parameter lpm_file = "UNUSED"; // Name of the file containing RAM initialization data.
    parameter use_eab = "ON"; // Specified whether to use the EAB or not.
    parameter rden_used = "TRUE"; // Specified whether to use the rden port or not.
    parameter intended_device_family = "APEX20KE";
    parameter lpm_type = "lpm_ram_dp";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] data;
    input  [lpm_widthad-1:0] rdaddress;
    input  [lpm_widthad-1:0] wraddress;
    input  rdclock;
    input  rdclken;
    input  wrclock;
    input  wrclken;
    input  rden;
    input  wren;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] q;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg [lpm_width-1:0] mem_data [(1<<lpm_widthad)-1:0];
    reg [lpm_width-1:0] i_data_reg, i_data_tmp, i_q_reg, i_q_tmp;
    reg [lpm_width-1:0] ZEROS, ONES, UNKNOWN;
    reg [lpm_widthad-1:0] i_wraddress_reg, i_wraddress_tmp;
    reg [lpm_widthad-1:0] i_rdaddress_reg, i_rdaddress_tmp;
    reg [lpm_widthad-1:0] ZEROS_AD;
    reg i_wren_reg, i_wren_tmp, i_rden_reg, i_rden_tmp;
    reg [8*256:1] ram_initf;
    reg mem_updated;
    
// LOCAL INTEGER DECLARATION
    integer i, i_numwords;

// INTERNAL TRI DECLARATION
    tri0 wrclock;
    tri1 wrclken;
    tri0 rdclock;
    tri1 rdclken;
    tri0 wren;
    tri1 rden;
               
    buf (i_inclock, wrclock);
    buf (i_inclocken, wrclken);
    buf (i_outclock, rdclock);
    buf (i_outclocken, rdclken);
    buf (i_wren, wren);
    buf (i_rden, rden);

// COMPONENT INSTANTIATIONS
    LPM_DEVICE_FAMILIES dev ();
    
// FUNCTON DECLARATION
    function ValidAddress;
        input [lpm_widthad-1:0] paddress;
    
        begin
            ValidAddress = 1'b0;
            if (^paddress === 'bx)
                $display("%t:Error!  Invalid address.\n", $time);
            else if (paddress >= lpm_numwords)
                $display("%t:Error!  Address out of bound on RAM.\n", $time);
            else
                ValidAddress = 1'b1;
        end
    endfunction

// INITIAL CONSTRUCT BLOCK        
    initial
    begin
        // Check for invalid parameters
        if (lpm_width < 1)
        begin
            $display("Error! lpm_width parameter must be greater than 0.");
            $finish;
        end
        if (lpm_widthad < 1)
        begin
            $display("Error! lpm_widthad parameter must be greater than 0.");
            $finish;
        end
        if ((lpm_indata != "REGISTERED") && (lpm_indata != "UNREGISTERED"))
        begin
            $display("Error! lpm_indata must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end
        if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED"))
        begin
            $display("Error! lpm_outdata must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end
        if ((lpm_wraddress_control != "REGISTERED") && (lpm_wraddress_control != "UNREGISTERED"))
        begin
            $display("Error! lpm_wraddress_control must be \"REGISTERED\" or \"UNREGISTERED\".");
        end
        if ((lpm_rdaddress_control != "REGISTERED") && (lpm_rdaddress_control != "UNREGISTERED"))
        begin
            $display("Error! lpm_rdaddress_control must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end

        if (dev.IS_VALID_FAMILY(intended_device_family) == 0)
        begin
            $display ("Error! Unknown INTENDED_DEVICE_FAMILY=%s.", intended_device_family);
            $finish;
        end
             
        // Initialize constants
        for (i=0; i<lpm_width; i=i+1)
        begin
            ZEROS[i] = 1'b0;
            ONES[i] = 1'b1;
            UNKNOWN[i] = 1'bx;
        end
        
        for (i=0; i<lpm_widthad; i=i+1)
            ZEROS_AD[i] = 1'b0;
                
        // Initialize mem_data
        i_numwords = (lpm_numwords) ? lpm_numwords : 1<<lpm_widthad;
        
        if (lpm_file == "UNUSED")
            for (i=0; i<i_numwords; i=i+1)
                mem_data[i] = ZEROS;
        else
        begin
`ifdef NO_PLI
            $readmemh(lpm_file, mem_data);
`else
            $convert_hex2ver(lpm_file, lpm_width, ram_initf);
            $readmemh(ram_initf, mem_data);
`endif
        end

        mem_updated = 0;

        // Initialize registers
        i_data_reg <= ZEROS;
        i_wraddress_reg <= ZEROS_AD;
        i_rdaddress_reg <= ZEROS_AD;
        i_wren_reg <= 0;
        if (rden_used == "TRUE")
            i_rden_reg <= 0;
        else
            i_rden_reg <= 1;

        // Initialize output
        i_q_reg = ZEROS;
        if ((use_eab == "ON") || (lpm_hint == "USE_EAB=ON"))
        begin
            if (dev.IS_FAMILY_APEX20K(intended_device_family))
                i_q_tmp = ZEROS;
            else
                i_q_tmp = ONES;
        end
        else 
            i_q_tmp = ZEROS;
    end


// ALWAYS CONSTRUCT BLOCK

    always @(posedge i_inclock)
    begin
        if (lpm_indata == "REGISTERED")
            if ((i_inclocken == 1) && ($time > 0))
                i_data_reg <= data;

        if (lpm_wraddress_control == "REGISTERED")
            if ((i_inclocken == 1) && ($time > 0))
            begin
                i_wraddress_reg <= wraddress;
                i_wren_reg <= i_wren;
            end

    end

    always @(posedge i_outclock)
    begin
        if (lpm_outdata == "REGISTERED")
            if ((i_outclocken == 1) && ($time > 0))
            begin
                i_q_reg <= i_q_tmp;
            end

        if (lpm_rdaddress_control == "REGISTERED")
            if ((i_outclocken == 1) && ($time > 0))
            begin
                i_rdaddress_reg <= rdaddress;
                i_rden_reg <= i_rden;
            end
    end


    //=========
    // Memory
    //=========

    always @(i_data_tmp or i_wren_tmp or i_wraddress_tmp or negedge i_inclock)
    begin
        if (i_wren_tmp == 1)
            if (ValidAddress(i_wraddress_tmp))
            begin
                if (((use_eab == "ON") || (lpm_hint == "USE_EAB=ON")) &&
                     (lpm_wraddress_control == "REGISTERED"))
                begin
                    if (i_inclock == 0)
                    begin
                        mem_data[i_wraddress_tmp] <= i_data_tmp;
                        mem_updated <= ~mem_updated;
                    end
                end
                else
                begin
                        mem_data[i_wraddress_tmp] <= i_data_tmp;
                        mem_updated <= ~mem_updated;
                end
            end
    end

    always @(i_rden_tmp or i_rdaddress_tmp or mem_updated)
    begin
        if (i_rden_tmp == 1)
            i_q_tmp = (ValidAddress(i_rdaddress_tmp))
                        ? mem_data[i_rdaddress_tmp]
                        : UNKNOWN;
        else if (dev.IS_FAMILY_APEX20K(intended_device_family) &&
                ((use_eab == "ON")  || (lpm_hint == "USE_EAB=ON")))
            i_q_tmp = 0;

    end


    //=======
    // Sync
    //=======

    always @(wraddress or i_wraddress_reg)
            i_wraddress_tmp = (lpm_wraddress_control == "REGISTERED")
                            ? i_wraddress_reg
                            : wraddress;
    always @(rdaddress or i_rdaddress_reg)
        i_rdaddress_tmp = (lpm_rdaddress_control == "REGISTERED")
                            ? i_rdaddress_reg
                            : rdaddress;
    always @(i_wren or i_wren_reg)
        i_wren_tmp = (lpm_wraddress_control == "REGISTERED")
                       ? i_wren_reg
                       : i_wren;
    always @(i_rden or i_rden_reg)
        i_rden_tmp = (lpm_rdaddress_control == "REGISTERED")
                       ? i_rden_reg
                       : i_rden;
    always @(data or i_data_reg)
        i_data_tmp = (lpm_indata == "REGISTERED")
                       ? i_data_reg
                       : data;

// CONTINOUS ASSIGNMENT
    assign q = (lpm_outdata == "REGISTERED") ? i_q_reg : i_q_tmp;

endmodule // lpm_ram_dp
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     : lpm_ram_io
//
// Description     : Parameterized RAM with a single I/O port megafunction
//
// Limitation      : This megafunction is provided only for backward
//                   compatibility in Cyclone, Stratix, and Stratix GX designs;
//                   instead, Altera recommends using the altsyncram
//                   megafunction
//
// Results expected: Output of RAM content at bi-directional DIO.
//
//END_MODULE_NAME--------------------------------------------------------------
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_ram_io ( dio, inclock, outclock, we, memenab, outenab, address );

// PARAMETER DECLARATION
    parameter lpm_type = "lpm_ram_io";
    parameter lpm_width = 1;
    parameter lpm_widthad = 1;
    parameter lpm_numwords = 1<< lpm_widthad;
    parameter lpm_indata = "REGISTERED";
    parameter lpm_address_control = "REGISTERED";
    parameter lpm_outdata = "REGISTERED";
    parameter lpm_file = "UNUSED";
    parameter lpm_hint = "UNUSED";
    parameter use_eab = "ON";
    parameter intended_device_family = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_widthad-1:0] address;
    input  inclock, outclock, we;
    input  memenab;
    input  outenab;
    
// INPUT/OUTPUT PORT DECLARATION
    inout  [lpm_width-1:0] dio;


// INTERNAL REGISTERS DECLARATION
    reg  [lpm_width-1:0] mem_data [lpm_numwords-1:0];
    reg  [lpm_width-1:0] tmp_io;
    reg  [lpm_width-1:0] tmp_q;
    reg  [lpm_width-1:0] pdio;
    reg  [lpm_widthad-1:0] paddress;
    reg  pwe;
    reg  [lpm_width-1:0] ZEROS, ONES, UNKNOWN, HiZ;
    reg  [8*256:1] ram_initf;
    
// LOCAL INTEGER DECLARATION
    integer i;

// INTERNAL TRI DECLARATION
    tri0 inclock;
    tri0 outclock;
    tri1 memenab;
    tri1 outenab;

// INTERNAL BUF DECLARATION
    buf (i_inclock, inclock);
    buf (i_outclock, outclock);
    buf (i_memenab, memenab);
    buf (i_outenab, outenab);


// FUNCTON DECLARATION
    function ValidAddress;
        input [lpm_widthad-1:0] paddress;

        begin
            ValidAddress = 1'b0;
            if (^paddress ==='bx)
            begin
                $display("%t:Error:  Invalid address.", $time);
                $finish;
            end    
            else if (paddress >= lpm_numwords)
            begin
                $display("%t:Error:  Address out of bound on RAM.", $time);
                $finish;
            end    
            else
                ValidAddress = 1'b1;
        end
    endfunction

    
// INITIAL CONSTRUCT BLOCK
    initial
    begin

        if (lpm_width <= 0)
        begin
            $display("Error!  LPM_WIDTH parameter must be greater than 0.");
            $finish;
        end

        if (lpm_widthad <= 0)
        begin
            $display("Error!  LPM_WIDTHAD parameter must be greater than 0.");
            $finish;
        end

        // check for number of words out of bound
        if ((lpm_numwords > (1 << lpm_widthad))
            ||(lpm_numwords <= (1 << (lpm_widthad-1))))
        begin
            $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHAD.");
            $finish;
        end

        if ((lpm_indata != "REGISTERED") && (lpm_indata != "UNREGISTERED"))
        begin
            $display("Error!  LPM_INDATA must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end

        if ((lpm_address_control != "REGISTERED") && (lpm_address_control != "UNREGISTERED"))
        begin
            $display("Error!  LPM_ADDRESS_CONTROL must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end

        if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED"))
        begin
            $display("Error!  LPM_OUTDATA must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end

        for (i=0; i < lpm_width; i=i+1)
        begin
            ZEROS[i] = 1'b0;
            ONES[i] = 1'b1;
            UNKNOWN[i] = 1'bX;
            HiZ[i] = 1'bZ;
        end

        for (i = 0; i < lpm_numwords; i=i+1)
            mem_data[i] = ZEROS;

        // Initialize input/output
        pwe <= 0;
        pdio <= 0;
        paddress <= 0;
        tmp_io = 0;
        tmp_q <= ZEROS;

        // load data to the RAM
        if (lpm_file != "UNUSED")
        begin
            `ifdef NO_PLI
                $readmemh(lpm_file, mem_data);
            `else
                $convert_hex2ver(lpm_file, lpm_width, ram_initf);
                $readmemh(ram_initf, mem_data);
            `endif
        end
    end


// ALWAYS CONSTRUCT BLOCK
    always @(dio)
    begin
        if (lpm_indata == "UNREGISTERED")
            pdio <=  dio;
    end

    always @(address)
    begin
        if (lpm_address_control == "UNREGISTERED")
            paddress <=  address;
    end


    always @(we)
    begin
        if (lpm_address_control == "UNREGISTERED")
            pwe <=  we;
    end

    always @(posedge i_inclock)
    begin
        if (lpm_indata == "REGISTERED")
            pdio <=  dio;

        if (lpm_address_control == "REGISTERED")
        begin
            paddress <=  address;
            pwe <=  we;
        end
    end

    always @(pdio or paddress or pwe or i_memenab)
    begin :block_a
        if (ValidAddress(paddress))
        begin
            if (lpm_address_control == "UNREGISTERED")
                if (pwe && i_memenab)
                    mem_data[paddress] <= pdio;

            if (lpm_outdata == "UNREGISTERED")
                tmp_q <= mem_data[paddress];
        end
        else
        begin
            if (lpm_outdata == "UNREGISTERED")
                tmp_q <= UNKNOWN;
        end
    end

    always @(negedge i_inclock or pdio)
    begin
        if (lpm_address_control == "REGISTERED")
            if ((use_eab == "ON") || (lpm_hint == "USE_EAB=ON"))
                if (pwe && i_memenab && (i_inclock == 0))
                    mem_data[paddress] = pdio;
    end

    always @(posedge i_inclock)
    begin
        if (lpm_address_control == "REGISTERED")
            if ((use_eab == "OFF") && pwe && i_memenab)
                mem_data[paddress] <= pdio;
    end

    always @(posedge i_outclock)
    begin
        if (lpm_outdata == "REGISTERED")
            tmp_q <= mem_data[paddress];
    end

    always @(i_memenab or i_outenab or tmp_q)
    begin
        if (i_memenab && i_outenab)
            tmp_io = tmp_q;
        else if (!i_memenab || (i_memenab && !i_outenab))
            tmp_io = HiZ;
    end

    
// CONTINOUS ASSIGNMENT
    assign dio = tmp_io;

endmodule // lpm_ram_io

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_rom
//
// Description     :  Parameterized ROM megafunction. This megafunction is provided
//                    only for backward compatibility in Cyclone, Stratix, and
//                    Stratix GX designs; instead, Altera recommends using the
//                    altsyncram megafunction.
//
// Limitation      :  This option is available for all Altera devices supported by
//                    the Quartus II software except MAX 3000 and MAX 7000 devices. 
//
// Results expected:  Output of memory.
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_rom (
    address,    // Address input to the memory. (Required)
    inclock,    // Clock for input registers.
    outclock,   // Clock for output registers.
    memenab,    // Memory enable input.
    q           // Output of memory.  (Required)
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;    // Width of the q[] port. (Required)
    parameter lpm_widthad = 1;  // Width of the address[] port. (Required)
    parameter lpm_numwords = 0; // Number of words stored in memory. 
    parameter lpm_address_control = "REGISTERED"; // Indicates whether the address port is registered.
    parameter lpm_outdata = "REGISTERED"; // Indicates whether the q and eq ports are registered.
    parameter lpm_file = ""; // Name of the memory file containing ROM initialization data 
    parameter intended_device_family = "APEX20KE";
    parameter lpm_type = "lpm_rom";
    parameter lpm_hint = "UNUSED";
    
// LOCAL PARAMETER DECLARATION
    parameter NUM_WORDS = (lpm_numwords == 0) ? (1 << lpm_widthad) : lpm_numwords;

// INPUT PORT DECLARATION
    input  [lpm_widthad-1:0] address;
    input  inclock;
    input  outclock;
    input  memenab;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] q;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg  [lpm_width-1:0] mem_data [0:NUM_WORDS-1];
    reg  [lpm_widthad-1:0] paddress;
    reg  [lpm_width-1:0] tmp_q;
    reg  [lpm_width-1:0] tmp_q_reg;
    reg  [lpm_width-1:0] ZEROS, UNKNOWN, HiZ;
    reg  [8*256:1] rom_initf;

// LOCAL INTEGER DECLARATION
    integer i;

// INTERNAL TRI DECLARATION
    tri0 inclock;
    tri0 outclock;
    tri1 memenab;

    buf (i_inclock, inclock);
    buf (i_outclock, outclock);
    buf (i_memenab, memenab);

// COMPONENT INSTANTIATIONS
    LPM_DEVICE_FAMILIES dev ();
    
// FUNCTON DECLARATION
    // Check the validity of the address.
    function ValidAddress;
        input [lpm_widthad-1:0] address;
        begin
            ValidAddress = 1'b0;
            if (^address =='bx)
            begin
                $display("%d:Error:  Invalid address.", $time);
                $finish;
            end
            else if (address >= NUM_WORDS)
            begin
                $display("%d:Error:  Address out of bound on ROM.", $time);
                $finish;
            end
            else
                ValidAddress = 1'b1;
        end
    endfunction


// INITIAL CONSTRUCT BLOCK        
    initial     
    begin
        // Initialize output
        tmp_q <= 0;
        tmp_q_reg <= 0;
        paddress <= 0;
 
        if (lpm_width <= 0)
        begin
            $display("Error!  LPM_WIDTH parameter must be greater than 0.");
            $finish;
        end
        
        if (lpm_widthad <= 0)
        begin
            $display("Error!  LPM_WIDTHAD parameter must be greater than 0.");
            $finish;
        end
         
        // check for number of words out of bound
        if ((NUM_WORDS > (1 << lpm_widthad)) ||
            (NUM_WORDS <= (1 << (lpm_widthad-1))))
        begin
            $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHAD.");
            $finish;
        end
        
        if ((lpm_address_control != "REGISTERED") && 
            (lpm_address_control != "UNREGISTERED"))
        begin
            $display("Error!  LPM_ADDRESS_CONTROL must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end

        if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED"))
        begin
            $display("Error!  LPM_OUTDATA must be \"REGISTERED\" or \"UNREGISTERED\".");
            $finish;
        end
       
        if (dev.IS_VALID_FAMILY(intended_device_family) == 0)
        begin
            $display ("Error! Unknown INTENDED_DEVICE_FAMILY=%s.", intended_device_family);
            $finish;
        end
        if (dev.IS_FAMILY_MAX7000A(intended_device_family) == 1 || dev.IS_FAMILY_MAX7000B(intended_device_family) == 1 || dev.IS_FAMILY_MAX7000AE(intended_device_family) == 1 || dev.IS_FAMILY_MAX7000S(intended_device_family) == 1 || dev.IS_FAMILY_MAX3000A(intended_device_family) == 1)
        begin
            $display ("Error! LPM_ROM megafunction does not support %s devices.", intended_device_family);
            $finish;
        end 
        
        for (i=0; i < lpm_width; i=i+1)
        begin
            ZEROS[i] = 1'b0;
            UNKNOWN[i] = 1'bX;
            HiZ[i] = 1'bZ;
        end 
            
        for (i = 0; i < NUM_WORDS; i=i+1)
            mem_data[i] = ZEROS;

        // load data to the ROM
        if ((lpm_file == "") || (lpm_file == "UNUSED"))
            $display("Warning:  LPM_ROM must have data file for initialization.\n");
        else
        begin
`ifdef NO_PLI
            $readmemh(lpm_file, mem_data);
`else
            $convert_hex2ver(lpm_file, lpm_width, rom_initf);
            $readmemh(rom_initf, mem_data);
`endif
        end
    end

    always @(posedge i_inclock)
    begin
        if (lpm_address_control == "REGISTERED")
            paddress <=  address; // address port is registered
    end
 
    always @(address)
    begin
        if (lpm_address_control == "UNREGISTERED")
            paddress <=  address;  // address port is not registered
    end
                   
    always @(paddress)
    begin 
        if (ValidAddress(paddress))
        begin
            if (lpm_outdata == "UNREGISTERED")
                // Load the output register with the contents of the memory location
                // pointed to by address[]. 
                tmp_q_reg <=  mem_data[paddress]; 
        end
        else
        begin
            if (lpm_outdata == "UNREGISTERED")
                tmp_q_reg <= UNKNOWN;
        end
    end

    always @(posedge i_outclock)
    begin
        if (lpm_outdata == "REGISTERED")
        begin
            if (ValidAddress(paddress))
                tmp_q_reg <=  mem_data[paddress];
            else
                tmp_q_reg <= UNKNOWN;
        end
    end
 
    always @(i_memenab or tmp_q_reg)
    begin
        // outputs the contents of the output register if memenab port is high
        tmp_q <= (i_memenab) ? tmp_q_reg : HiZ;
    end

// CONTINOUS ASSIGNMENT
    assign q = tmp_q;

endmodule // lpm_rom
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_fifo
//
// Description     :
//
// Limitation      :
//
// Results expected:
//
//END_MODULE_NAME--------------------------------------------------------------

module lpm_fifo ( data, clock, wrreq, rdreq, aclr, sclr, q, usedw, full, empty );

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;
    parameter lpm_widthu = 1;
    parameter lpm_numwords = 2;
    parameter lpm_showahead = "OFF";
    parameter lpm_type = "lpm_fifo";
    parameter lpm_hint = "INTENDED_DEVICE_FAMILY=APEX20KE";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] data;
    input  clock;
    input  wrreq;
    input  rdreq;
    input  aclr;
    input  sclr;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] q;
    output [lpm_widthu-1:0] usedw;
    output full;
    output empty;

// INTERNAL REGISTERS DECLARATION
    reg [lpm_width-1:0] mem_data [(1<<lpm_widthu):0];
    reg [lpm_width-1:0] tmp_data;
    reg [lpm_widthu-1:0] count_id;
    reg [lpm_widthu-1:0] read_id;
    reg [lpm_widthu-1:0] write_id;
    reg write_flag;
    reg full_flag;
    reg empty_flag;
    reg [lpm_width-1:0] tmp_q;

    reg [8*5:1] overflow_checking;
    reg [8*5:1] underflow_checking;
    reg [8*20:1] allow_rwcycle_when_full;
    reg [8*20:1] intended_device_family;

// INTERNAL WIRE DECLARATION
    wire valid_rreq;
    wire valid_wreq;

// INTERNAL TRI DECLARATION
    tri0 aclr;

// LOCAL INTEGER DECLARATION
    integer i;

// COMPONENT INSTANTIATIONS
    LPM_DEVICE_FAMILIES dev ();
    LPM_HINT_EVALUATION eva();

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display ("Error! LPM_WIDTH must be greater than 0.");
            $stop;
        end
        if (lpm_numwords <= 1)
        begin
            $display ("Error! LPM_NUMWORDS must be greater than or equal to 2.");
            $stop;
        end
        if ((lpm_widthu !=1) && (lpm_numwords > (1 << lpm_widthu)))
        begin
            $display ("Error! LPM_NUMWORDS must equal to the ceiling of log2(LPM_WIDTHU).");
            $stop;
        end
        if (lpm_numwords <= (1 << (lpm_widthu - 1)))
        begin
            $display ("Error! LPM_WIDTHU is too big for the specified LPM_NUMWORDS.");
            $stop;
        end

        overflow_checking = eva.GET_PARAMETER_VALUE(lpm_hint, "OVERFLOW_CHECKING");
        if(overflow_checking == "")
            overflow_checking = "ON";
        else if ((overflow_checking != "ON") && (overflow_checking != "OFF"))
        begin
            $display ("Error! OVERFLOW_CHECKING must equal to either 'ON' or 'OFF'");
            $stop;
        end

        underflow_checking = eva.GET_PARAMETER_VALUE(lpm_hint, "UNDERFLOW_CHECKING");
        if(underflow_checking == "")
            underflow_checking = "ON";
        else if ((underflow_checking != "ON") && (underflow_checking != "OFF"))
        begin
            $display ("Error! UNDERFLOW_CHECKING must equal to either 'ON' or 'OFF'");
            $stop;
        end

        allow_rwcycle_when_full = eva.GET_PARAMETER_VALUE(lpm_hint, "ALLOW_RWCYCLE_WHEN_FULL");
        if (allow_rwcycle_when_full == "")
            allow_rwcycle_when_full = "OFF";
        else if ((allow_rwcycle_when_full != "ON") && (allow_rwcycle_when_full != "OFF"))
        begin
            $display ("Error! ALLOW_RWCYCLE_WHEN_FULL must equal to either 'ON' or 'OFF'");
            $stop;
        end

        intended_device_family = eva.GET_PARAMETER_VALUE(lpm_hint, "INTENDED_DEVICE_FAMILY");
        if (intended_device_family == "")
            intended_device_family = "APEX20KE";
        else if (dev.IS_VALID_FAMILY(intended_device_family) == 0)
        begin
            $display ("Error! Unknown INTENDED_DEVICE_FAMILY=%s.", intended_device_family);
            $stop;
        end

        for (i = 0; i < (1<<lpm_widthu); i = i + 1)
        begin
            if (dev.IS_FAMILY_STRATIX(intended_device_family) ||
            dev.IS_FAMILY_STRATIXGX(intended_device_family) ||
            dev.IS_FAMILY_CYCLONE(intended_device_family))
                mem_data[i] <= {lpm_width{1'bx}};
            else
                mem_data[i] <= {lpm_width{1'b0}};
        end

        tmp_data <= 0;
        if (dev.IS_FAMILY_STRATIX(intended_device_family) ||
            dev.IS_FAMILY_STRATIXGX(intended_device_family) ||
            dev.IS_FAMILY_CYCLONE(intended_device_family))
            tmp_q <= {lpm_width{1'bx}};
        else
            tmp_q <= {lpm_width{1'b0}};
        write_flag <= 1'b0;
        count_id <= 0;
        read_id <= 0;
        write_id <= 0;
        full_flag <= 1'b0;
        empty_flag <= 1'b1;        
    end

// ALWAYS CONSTRUCT BLOCK
    always @(posedge clock or posedge aclr)
    begin
        if (aclr)
        begin
            if (!(dev.IS_FAMILY_STRATIX(intended_device_family) ||
                dev.IS_FAMILY_STRATIXGX(intended_device_family) ||
                dev.IS_FAMILY_CYCLONE(intended_device_family)))
            begin
                if (lpm_showahead == "ON")
                    tmp_q <= mem_data[0];
                else
                    tmp_q <= {lpm_width{1'b0}};
            end

            read_id <= 0;
            count_id <= 0;
            full_flag <= 1'b0;
            empty_flag <= 1'b1;

            if (valid_wreq && (dev.IS_FAMILY_STRATIX(intended_device_family) ||
            dev.IS_FAMILY_STRATIXGX(intended_device_family) ||
            dev.IS_FAMILY_CYCLONE(intended_device_family)))
            begin
                tmp_data <= data;
                write_flag <= 1'b1;
            end
            else
                write_id <= 0;
        end
        else if (sclr)
        begin
            if ((lpm_showahead == "ON") || (dev.IS_FAMILY_STRATIX(intended_device_family) ||
            dev.IS_FAMILY_STRATIXGX(intended_device_family) ||
            dev.IS_FAMILY_CYCLONE(intended_device_family)))
                tmp_q <= mem_data[0];
            else
                tmp_q <= mem_data[read_id];
            read_id <= 0;
            count_id <= 0;
            full_flag <= 1'b0;
            empty_flag <= 1'b1;

            if (valid_wreq)
            begin
                tmp_data <= data;
                write_flag <= 1'b1;
            end
            else
                write_id <= 0;
        end
        else
        begin
            // Both WRITE and READ operations
            if (valid_wreq && valid_rreq)
            begin
                tmp_data <= data;
                write_flag <= 1'b1;
                empty_flag <= 1'b0;
                if (allow_rwcycle_when_full == "OFF")
                begin
                    full_flag <= 1'b0;
                end

                if (read_id >= ((1 << lpm_widthu) - 1))
                begin
                    if (lpm_showahead == "ON")
                        tmp_q <= mem_data[0];
                    else
                        tmp_q <= mem_data[read_id];
                    read_id <= 0;
                end
                else
                begin
                    if (lpm_showahead == "ON")
                        tmp_q <= mem_data[read_id + 1];
                    else
                        tmp_q <= mem_data[read_id];
                    read_id <= read_id + 1;
                end
            end
            // WRITE operation only
            else if (valid_wreq)
            begin
                tmp_data <= data;
                empty_flag <= 1'b0;
                write_flag <= 1'b1;

                if (count_id >= (1 << lpm_widthu) - 1)
                    count_id <= 0;
                else
                    count_id <= count_id + 1;

                if ((count_id == lpm_numwords - 1) && (empty_flag == 1'b0))
                    full_flag <= 1'b1;

                if (lpm_showahead == "ON")
                    tmp_q <= mem_data[read_id];
            end
            // READ operation only
            else if (valid_rreq)
            begin
                full_flag <= 1'b0;

                if (count_id <= 0)
                    count_id <= ((1 << lpm_widthu) - 1);
                else
                    count_id <= count_id - 1;

                if ((count_id == 1) && (full_flag == 1'b0))
                    empty_flag <= 1'b1;

                if (read_id >= ((1<<lpm_widthu) - 1))
                begin
                    if (lpm_showahead == "ON")
                        tmp_q <= mem_data[0];
                    else
                        tmp_q <= mem_data[read_id];
                    read_id <= 0;
                end
                else
                begin
                    if (lpm_showahead == "ON")
                        tmp_q <= mem_data[read_id + 1];
                    else
                        tmp_q <= mem_data[read_id];
                    read_id <= read_id + 1;
                end
            end // if Both WRITE and READ operations

        end // if aclr
    end // @(posedge clock)

    always @(negedge clock)
    begin
        if (write_flag)
        begin
            write_flag <= 1'b0;
            mem_data[write_id] <= tmp_data;

            if (sclr || aclr || (write_id >= ((1 << lpm_widthu) - 1)))
                write_id <= 0;
            else
                write_id <= write_id + 1;
        end

        if ((lpm_showahead == "ON") && ($time > 0))
            tmp_q <= ((write_flag == 1'b1) && (write_id == read_id)) ?
                      tmp_data : mem_data[read_id];

    end // @(negedge clock)

// CONTINOUS ASSIGNMENT
    assign valid_rreq = (underflow_checking == "OFF") ? rdreq : rdreq && ~empty_flag;
    assign valid_wreq = (overflow_checking == "OFF") ? wrreq : 
                        (allow_rwcycle_when_full == "ON") ? wrreq && (!full_flag || rdreq) :
                        wrreq && !full_flag;
    assign q = tmp_q;
    assign full = full_flag;
    assign empty = empty_flag;
    assign usedw = count_id;

endmodule // lpm_fifo
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_fifo_dc_dffpipe
//
// Description     :  Dual Clocks FIFO
//
// Limitation      :
//
// Results expected:
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_fifo_dc_dffpipe (d, clock, aclr,
                       q);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_delay = 1;
    parameter lpm_width = 64;

// INPUT PORT DECLARATION
    input [lpm_width-1:0] d;
    input clock;
    input aclr;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] q;

// INTERNAL REGISTERS DECLARATION
    reg [lpm_width-1:0] dffpipe [lpm_delay:0];
    reg [lpm_width-1:0] q;

// LOCAL INTEGER DECLARATION
    integer delay, i;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        delay <= lpm_delay - 1;
        for (i = 0; i < lpm_delay; i = i + 1)
            dffpipe[i] <= 0;
        q <= 0;
    end

// ALWAYS CONSTRUCT BLOCK
    always @(posedge aclr or posedge clock)
    begin
        if (aclr)
        begin
            for (i = 0; i < lpm_delay; i = i + 1)
                dffpipe[i] <= 0;
            q <= 0;
        end
        else if (clock)
        begin
            if ((lpm_delay > 0) && ($time > 0))
            begin
                if (delay > 0)
                begin
                    for (i = delay; i > 0; i = i - 1)
                        dffpipe[i] <= dffpipe[i - 1];
                    q <= dffpipe[delay - 1];
                end
                else
                    q <= d;

                dffpipe[0] <= d;
            end
        end
    end // @(posedge aclr or posedge clock)

    always @(d)
    begin
        if (lpm_delay == 0)
            if (aclr)
                q <= 0;
            else
                q <= d;
    end // @(d)

endmodule // lpm_fifo_dc_dffpipe
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_fifo_dc_fefifo
//
// Description     :  Dual Clock FIFO
//
// Limitation      :
//
// Results expected:
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_fifo_dc_fefifo (usedw_in, wreq, rreq, clock, aclr,
                      empty, full);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_widthad = 1;
    parameter lpm_numwords = 1;
    parameter underflow_checking = "ON";
    parameter overflow_checking = "ON";
    parameter lpm_mode = "READ";
    parameter lpm_hint = "";

// INPUT PORT DECLARATION
    input [lpm_widthad-1:0] usedw_in;
    input wreq, rreq;
    input clock;
    input aclr;

// OUTPUT PORT DECLARATION
    output empty, full;

// INTERNAL REGISTERS DECLARATION
    reg [1:0] sm_empty;
    reg lrreq;
    reg i_empty, i_full;
    reg [8*5:1] i_overflow_checking;
    reg [8*5:1] i_underflow_checking;

// LOCAL INTEGER DECLARATION
    integer almostfull;

// COMPONENT INSTANTIATIONS
    LPM_HINT_EVALUATION eva();

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if ((lpm_mode != "READ") && (lpm_mode != "WRITE"))
        begin
            $display ("Error! LPM_MODE must be READ or WRITE.");
            $stop;
        end

        i_overflow_checking = eva.GET_PARAMETER_VALUE(lpm_hint, "OVERFLOW_CHECKING");
        if (i_overflow_checking == "")
        begin
            if ((overflow_checking != "ON") && (overflow_checking != "OFF"))
            begin
                $display ("Error! OVERFLOW_CHECKING must equal to either 'ON' or 'OFF'");
                $stop;
            end
            else
                i_overflow_checking = overflow_checking;
        end
        else if ((i_overflow_checking != "ON") && (i_overflow_checking != "OFF"))
        begin
            $display ("Error! OVERFLOW_CHECKING must equal to either 'ON' or 'OFF'");
            $stop;
        end

        i_underflow_checking = eva.GET_PARAMETER_VALUE(lpm_hint, "UNDERFLOW_CHECKING");
        if(i_underflow_checking == "")
        begin
            if ((underflow_checking != "ON") && (underflow_checking != "OFF"))
            begin
                $display ("Error! UNDERFLOW_CHECKING must equal to either 'ON' or 'OFF'");
                $stop;
            end
            else
                i_underflow_checking = underflow_checking;
        end
        else if ((i_underflow_checking != "ON") && (i_underflow_checking != "OFF"))
        begin
            $display ("Error! UNDERFLOW_CHECKING must equal to either 'ON' or 'OFF'");
            $stop;
        end

        sm_empty <= 2'b00;
        i_empty <= 1'b1;
        i_full <= 1'b0;
        lrreq <= 1'b0;

        if (lpm_numwords >= 3)
            almostfull <= lpm_numwords - 3;
        else
            almostfull <= 0;
    end

// ALWAYS CONSTRUCT BLOCK
    always @(posedge aclr)
    begin
        sm_empty <= 2'b00;
        i_empty <= 1'b1;
        i_full <= 1'b0;
        lrreq <= 1'b0;
    end // @(posedge aclr)

    always @(posedge clock)
    begin
        if (i_underflow_checking == "OFF")
            lrreq <= rreq;
        else
           lrreq <= rreq && ~i_empty;


        if (~aclr && ($time > 0))
        begin
            if (lpm_mode == "READ")
            begin
               casex (sm_empty)
                    // state_empty
                    2'b00:
                        if (usedw_in != 0)
                            sm_empty <= 2'b01;
                    // state_non_empty
                    2'b01:
                        if (rreq && (((usedw_in == 1) && !lrreq) || ((usedw_in == 2) && lrreq)))
                            sm_empty <= 2'b10;
                    // state_emptywait
                    2'b10:
                        if (usedw_in > 1)
                            sm_empty <= 2'b01;
                        else
                            sm_empty <= 2'b00;
                    default:
                        $display ("Error! Invalid sm_empty state in read mode.");
                endcase
            end // if (lpm_mode == "READ")
            else if (lpm_mode == "WRITE")
            begin
                casex (sm_empty)
                    // state_empty
                    2'b00:
                        if (wreq)
                            sm_empty <= 2'b01;
                    // state_one
                    2'b01:
                        if (!wreq)
                            sm_empty <= 2'b11;
                    // state_non_empty
                    2'b11:
                        if (wreq)
                            sm_empty <= 2'b01;
                        else if (usedw_in == 0)
                            sm_empty <= 2'b00;
                    default:
                        $display ("Error! Invalid sm_empty state in write mode.");
                endcase
            end // if (lpm_mode == "WRITE")

            if (~aclr && (usedw_in >= almostfull) && ($time > 0))
                i_full <= 1'b1;
            else
                i_full <= 1'b0;
        end // if (~aclr && $time > 0)
    end // @(posedge clock)

    always @(sm_empty)
    begin
        if (~aclr)
            i_empty <= !sm_empty[0];
    end
    // @(sm_empty)

// CONTINOUS ASSIGNMENT
    assign empty = i_empty;
    assign full = i_full;
endmodule // lpm_fifo_dc_fefifo
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_fifo_dc_async
//
// Description     :  Asynchronous Dual Clocks FIFO
//
// Limitation      :
//
// Results expected:
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_fifo_dc_async (data, rdclk, wrclk, aclr, rdreq, wrreq,
                     rdfull, wrfull, rdempty, wrempty, rdusedw, wrusedw, q);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;
    parameter lpm_widthu = 1;
    parameter lpm_numwords = 2;
    parameter delay_rdusedw = 1;
    parameter delay_wrusedw = 1;
    parameter rdsync_delaypipe = 3;
    parameter wrsync_delaypipe = 3;
    parameter lpm_showahead = "OFF";
    parameter underflow_checking = "ON";
    parameter overflow_checking = "ON";
    parameter lpm_hint = "INTENDED_DEVICE_FAMILY=APEX20KE";

// INPUT PORT DECLARATION
    input [lpm_width-1:0] data;
    input rdclk;
    input wrclk;
    input aclr;
    input wrreq;
    input rdreq;

// OUTPUT PORT DECLARATION
    output rdfull;
    output wrfull;
    output rdempty;
    output wrempty;
    output [lpm_widthu-1:0] rdusedw;
    output [lpm_widthu-1:0] wrusedw;
    output [lpm_width-1:0] q;

// INTERNAL REGISTERS DECLARATION
    reg [lpm_width-1:0] mem_data [(1<<lpm_widthu)-1:0];
    reg [lpm_width-1:0] i_data_tmp;
    reg [lpm_widthu-1:0] i_rdptr;
    reg [lpm_widthu-1:0] i_wrptr;
    reg [lpm_widthu-1:0] i_wrptr_tmp;
    reg i_rdenclock;
    reg i_wren_tmp;
    reg [lpm_widthu-1:0] i_wr_udwn;
    reg [lpm_widthu-1:0] i_rd_udwn;
    reg i_showahead_flag;
    reg [lpm_widthu:0] i_rdusedw;
    reg [lpm_widthu-1:0] i_wrusedw;
    reg [lpm_width-1:0] i_q_tmp;

    reg [8*5:1] i_overflow_checking;
    reg [8*5:1] i_underflow_checking;
    reg [8*10:1] use_eab;
    reg [8*20:1] intended_device_family;

// INTERNAL WIRE DECLARATION
    wire w_rden;
    wire w_wren;
    wire w_rdempty;
    wire w_wrempty;
    wire w_rdfull;
    wire w_wrfull;
    wire [lpm_widthu-1:0] w_rdptrrg;
    wire [lpm_widthu-1:0] w_wrdelaycycle;
    wire [lpm_widthu-1:0] w_ws_nbrp;
    wire [lpm_widthu-1:0] w_rs_nbwp;
    wire [lpm_widthu-1:0] w_ws_dbrp;
    wire [lpm_widthu-1:0] w_rs_dbwp;
    wire [lpm_widthu-1:0] w_rd_dbuw;
    wire [lpm_widthu-1:0] w_wr_dbuw;
    wire [lpm_widthu-1:0] w_rdusedw;
    wire [lpm_widthu-1:0] w_wrusedw;

// INTERNAL TRI DECLARATION
    tri0 aclr;

// LOCAL INTEGER DECLARATION
    integer i;

// COMPONENT INSTANTIATIONS
    LPM_DEVICE_FAMILIES dev ();
    LPM_HINT_EVALUATION eva();

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if((lpm_showahead != "ON") && (lpm_showahead != "OFF"))
        begin
            $display ("Error! lpm_showahead must be ON or OFF.");
            $stop;
        end

        i_overflow_checking = eva.GET_PARAMETER_VALUE(lpm_hint, "OVERFLOW_CHECKING");
        if (i_overflow_checking == "")
        begin
            if ((overflow_checking != "ON") && (overflow_checking != "OFF"))
            begin
                $display ("Error! OVERFLOW_CHECKING must equal to either 'ON' or 'OFF'");
                $stop;
            end
            else
                i_overflow_checking = overflow_checking;
        end
        else if ((i_overflow_checking != "ON") && (i_overflow_checking != "OFF"))
        begin
            $display ("Error! OVERFLOW_CHECKING must equal to either 'ON' or 'OFF'");
            $stop;
        end

        i_underflow_checking = eva.GET_PARAMETER_VALUE(lpm_hint, "UNDERFLOW_CHECKING");
        if(i_underflow_checking == "")
        begin
            if ((underflow_checking != "ON") && (underflow_checking != "OFF"))
            begin
                $display ("Error! UNDERFLOW_CHECKING must equal to either 'ON' or 'OFF'");
                $stop;
            end
            else
                i_underflow_checking = underflow_checking;
        end
        else if ((i_underflow_checking != "ON") && (i_underflow_checking != "OFF"))
        begin
            $display ("Error! UNDERFLOW_CHECKING must equal to either 'ON' or 'OFF'");
            $stop;
        end

        use_eab = eva.GET_PARAMETER_VALUE(lpm_hint, "USE_EAB");
        if(use_eab == "")
            use_eab = "ON";
        else if ((use_eab != "ON") && (use_eab != "OFF"))
        begin
            $display ("Error! USE_EAB must equal to either 'ON' or 'OFF'");
            $stop;
        end

        intended_device_family = eva.GET_PARAMETER_VALUE(lpm_hint, "INTENDED_DEVICE_FAMILY");
        if (intended_device_family == "")
            intended_device_family = "APEX20KE";
        else if (dev.IS_VALID_FAMILY(intended_device_family) == 0)
        begin
            $display ("Error! Unknown INTENDED_DEVICE_FAMILY=%s.", intended_device_family);
            $stop;
        end

        for (i = 0; i < (1 << lpm_widthu); i = i + 1)
            mem_data[i] <= 0;
        i_data_tmp <= 0;
        i_rdptr <= 0;
        i_wrptr <= 0;
        i_wrptr_tmp <= 0;
        i_wren_tmp <= 0;
        i_wr_udwn <= 0;
        i_rd_udwn <= 0;

        i_rdusedw <= 0;
        i_wrusedw <= 0;
        i_q_tmp <= 0;
    end

// COMPONENT INSTANTIATIONS
    // Delays & DFF Pipes
    lpm_fifo_dc_dffpipe DP_RDPTR_D (
        .d (i_rdptr),
        .clock (i_rdenclock),
        .aclr (aclr),
        .q (w_rdptrrg));
    lpm_fifo_dc_dffpipe DP_WRPTR_D (
        .d (i_wrptr),
        .clock (wrclk),
        .aclr (aclr),
        .q (w_wrdelaycycle));
    defparam
        DP_RDPTR_D.lpm_delay = 0,
        DP_RDPTR_D.lpm_width = lpm_widthu,
        DP_WRPTR_D.lpm_delay = 1,
        DP_WRPTR_D.lpm_width = lpm_widthu;

    lpm_fifo_dc_dffpipe DP_WS_NBRP (
        .d (w_rdptrrg),
        .clock (wrclk),
        .aclr (aclr),
        .q (w_ws_nbrp));
    lpm_fifo_dc_dffpipe DP_RS_NBWP (
        .d (w_wrdelaycycle),
        .clock (rdclk),
        .aclr (aclr),
        .q (w_rs_nbwp));
    lpm_fifo_dc_dffpipe DP_WS_DBRP (
        .d (w_ws_nbrp),
        .clock (wrclk),
        .aclr (aclr),
        .q (w_ws_dbrp));
    lpm_fifo_dc_dffpipe DP_RS_DBWP (
        .d (w_rs_nbwp),
        .clock (rdclk),
        .aclr (aclr),
        .q (w_rs_dbwp));
    defparam
        DP_WS_NBRP.lpm_delay = wrsync_delaypipe,
        DP_WS_NBRP.lpm_width = lpm_widthu,
        DP_RS_NBWP.lpm_delay = rdsync_delaypipe,
        DP_RS_NBWP.lpm_width = lpm_widthu,
        DP_WS_DBRP.lpm_delay = 1,              // gray_delaypipe
        DP_WS_DBRP.lpm_width = lpm_widthu,
        DP_RS_DBWP.lpm_delay = 1,              // gray_delaypipe
        DP_RS_DBWP.lpm_width = lpm_widthu;

    lpm_fifo_dc_dffpipe DP_WRUSEDW (
        .d (i_wr_udwn),
        .clock (wrclk),
        .aclr (aclr),
        .q (w_wrusedw));
    lpm_fifo_dc_dffpipe DP_RDUSEDW (
        .d (i_rd_udwn),
        .clock (rdclk),
        .aclr (aclr),
        .q (w_rdusedw));
    lpm_fifo_dc_dffpipe DP_WR_DBUW (
        .d (i_wr_udwn),
        .clock (wrclk),
        .aclr (aclr),
        .q (w_wr_dbuw));
    lpm_fifo_dc_dffpipe DP_RD_DBUW (
        .d (i_rd_udwn),
        .clock (rdclk),
        .aclr (aclr),
        .q (w_rd_dbuw));
    defparam
        DP_WRUSEDW.lpm_delay = delay_wrusedw,
        DP_WRUSEDW.lpm_width = lpm_widthu,
        DP_RDUSEDW.lpm_delay = delay_rdusedw,
        DP_RDUSEDW.lpm_width = lpm_widthu,
        DP_WR_DBUW.lpm_delay = 1,              // wrusedw_delaypipe
        DP_WR_DBUW.lpm_width = lpm_widthu,
        DP_RD_DBUW.lpm_delay = 1,              // rdusedw_delaypipe
        DP_RD_DBUW.lpm_width = lpm_widthu;

    // Empty/Full
    lpm_fifo_dc_fefifo WR_FE (
        .usedw_in (w_wr_dbuw),
        .wreq (wrreq),
        .rreq (rdreq),
        .clock (wrclk),
        .aclr (aclr),
        .empty (w_wrempty),
        .full (w_wrfull));
    lpm_fifo_dc_fefifo RD_FE (
        .usedw_in (w_rd_dbuw),
        .rreq (rdreq),
        .wreq(wrreq),
        .clock (rdclk),
        .aclr (aclr),
        .empty (w_rdempty),
        .full (w_rdfull));
    defparam
        WR_FE.lpm_widthad = lpm_widthu,
        WR_FE.lpm_numwords = lpm_numwords,
        WR_FE.underflow_checking = underflow_checking,
        WR_FE.overflow_checking = overflow_checking,
        WR_FE.lpm_mode = "WRITE",
        WR_FE.lpm_hint = lpm_hint,
        RD_FE.lpm_widthad = lpm_widthu,
        RD_FE.lpm_numwords = lpm_numwords,
        RD_FE.underflow_checking = underflow_checking,
        RD_FE.overflow_checking = overflow_checking,
        RD_FE.lpm_mode = "READ",
        RD_FE.lpm_hint = lpm_hint;

// ALWAYS CONSTRUCT BLOCK
    always @(posedge aclr)
    begin
        i_rdptr <= 0;
        i_wrptr <= 0;
        if (!(dev.IS_FAMILY_STRATIX(intended_device_family) ||
        dev.IS_FAMILY_STRATIXGX(intended_device_family) ||
        dev.IS_FAMILY_CYCLONE(intended_device_family)) ||
        (use_eab == "OFF"))
        if (lpm_showahead == "ON")
            i_q_tmp <= mem_data[0];
        else
            i_q_tmp <= 0;
    end // @(posedge aclr)

    // FIFOram
    always @(wrclk)
    begin
        if (aclr && (!(dev.IS_FAMILY_STRATIX(intended_device_family) ||
        dev.IS_FAMILY_STRATIXGX(intended_device_family) ||
        dev.IS_FAMILY_CYCLONE(intended_device_family)) ||
        (use_eab == "OFF")))
        begin
            i_data_tmp <= 0;
            i_wrptr_tmp <= 0;
            i_wren_tmp <= 0;
        end
        else if (wrclk && ($time > 0))
        begin
            i_data_tmp <= data;
            i_wrptr_tmp <= i_wrptr;
            i_wren_tmp <= w_wren;

            if (w_wren)
            begin
                if (~aclr && ((i_wrptr < (1<<lpm_widthu)-1) || (i_overflow_checking == "OFF")))
                    i_wrptr <= i_wrptr + 1;
                else
                    i_wrptr <= 0;

                if (use_eab == "OFF")
                begin
                    mem_data[i_wrptr] <= data;

                    if (lpm_showahead == "ON")
                        i_showahead_flag <= 1'b1;
                end
            end
        end

        if ((~wrclk && (use_eab == "ON")) && ($time > 0))
        begin
            if (i_wren_tmp)
            begin
                mem_data[i_wrptr_tmp] <= i_data_tmp;
            end

            if (lpm_showahead == "ON")
                    i_showahead_flag <= 1'b1;
        end
    end // @(wrclk)

    always @(rdclk)
    begin
        if (aclr && (!(dev.IS_FAMILY_STRATIX(intended_device_family) ||
        dev.IS_FAMILY_STRATIXGX(intended_device_family) ||
        dev.IS_FAMILY_CYCLONE(intended_device_family)) ||
        (use_eab == "OFF")))
        begin
            if (lpm_showahead == "ON")
                i_q_tmp <= mem_data[0];
            else
                i_q_tmp <= 0;
        end
        else if (rdclk && w_rden && ($time > 0))
        begin
            if (~aclr && ((i_rdptr < (1<<lpm_widthu)-1) || (i_underflow_checking == "OFF")))
                i_rdptr <= i_rdptr + 1;
            else
                i_rdptr <= 0;

            if (lpm_showahead == "ON")
                i_showahead_flag <= 1'b1;
            else
                i_q_tmp <= mem_data[i_rdptr];
        end
    end // @(rdclk)

    always @(posedge i_showahead_flag)
    begin
        i_q_tmp <= mem_data[i_rdptr];
        i_showahead_flag <= 1'b0;
    end // @(posedge i_showahead_flag)

    // Delays & DFF Pipes
    always @(negedge rdclk)
    begin
        i_rdenclock <= 0;
    end // @(negedge rdclk)

    always @(posedge rdclk)
    begin
        if (w_rden)
            i_rdenclock <= 1;
    end // @(posedge rdclk)

    always @(i_wrptr or w_ws_dbrp)
    begin
        i_wr_udwn <= i_wrptr - w_ws_dbrp;
    end // @(i_wrptr or w_ws_dbrp)

    always @(i_rdptr or w_rs_dbwp)
    begin
        i_rd_udwn <= w_rs_dbwp - i_rdptr;
    end // @(i_rdptr or w_rs_dbwp)

// CONTINOUS ASSIGNMENT
    assign w_rden = (i_underflow_checking == "OFF") ? rdreq : rdreq && !w_rdempty;
    assign w_wren = (i_overflow_checking == "OFF")  ? wrreq : wrreq && !w_wrfull;
    assign q = i_q_tmp;
    assign wrfull = w_wrfull;
    assign rdfull = w_rdfull;
    assign wrempty = w_wrempty;
    assign rdempty = w_rdempty;
    assign wrusedw = w_wrusedw;
    assign rdusedw = w_rdusedw;

endmodule // lpm_fifo_dc_async
// END OF MODULE


//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_fifo_dc
//
// Description     :
//
// Limitation      :
//
// Results expected:
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_fifo_dc (data, rdclock, wrclock, aclr, rdreq, wrreq,
                     rdfull, wrfull, rdempty, wrempty, rdusedw, wrusedw, q);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;
    parameter lpm_widthu = 1;
    parameter lpm_numwords = 2;
    parameter lpm_showahead = "OFF";
    parameter underflow_checking = "ON";
    parameter overflow_checking = "ON";
    parameter lpm_hint = "INTENDED_DEVICE_FAMILY=APEX20KE";
    parameter lpm_type = "lpm_fifo_dc";

// LOCAL PARAMETER DECLARATION
    parameter delay_rdusedw = 1;
    parameter delay_wrusedw = 1;
    parameter rdsync_delaypipe = 3;
    parameter wrsync_delaypipe = 3;

// INPUT PORT DECLARATION
    input [lpm_width-1:0] data;
    input rdclock;
    input wrclock;
    input aclr;
    input rdreq;
    input wrreq;

// OUTPUT PORT DECLARATION
    output rdfull;
    output wrfull;
    output rdempty;
    output wrempty;
    output [lpm_widthu-1:0] rdusedw;
    output [lpm_widthu-1:0] wrusedw;
    output [lpm_width-1:0] q;

// internal reg
    wire w_rdfull_s;
    wire w_wrfull_s;
    wire w_rdempty_s;
    wire w_wrempty_s;
    wire w_rdfull_a;
    wire w_wrfull_a;
    wire w_rdempty_a;
    wire w_wrempty_a;
    wire [lpm_widthu-1:0] w_rdusedw_s;
    wire [lpm_widthu-1:0] w_wrusedw_s;
    wire [lpm_widthu-1:0] w_rdusedw_a;
    wire [lpm_widthu-1:0] w_wrusedw_a;
    wire [lpm_width-1:0] w_q_s;
    wire [lpm_width-1:0] w_q_a;

// INTERNAL TRI DECLARATION
    tri0 aclr;
    buf (i_aclr, aclr);

// COMPONENT INSTANTIATIONS
    lpm_fifo_dc_async ASYNC (
        .data (data),
        .rdclk (rdclock),
        .wrclk (wrclock),
        .aclr (i_aclr),
        .rdreq (rdreq),
        .wrreq (wrreq),
        .rdfull (w_rdfull_a),
        .wrfull (w_wrfull_a),
        .rdempty (w_rdempty_a),
        .wrempty (w_wrempty_a),
        .rdusedw (w_rdusedw_a),
        .wrusedw (w_wrusedw_a),
        .q (w_q_a) );
    defparam
        ASYNC.lpm_width = lpm_width,
        ASYNC.lpm_widthu = lpm_widthu,
        ASYNC.lpm_numwords = lpm_numwords,
        ASYNC.delay_rdusedw = delay_rdusedw,
        ASYNC.delay_wrusedw = delay_wrusedw,
        ASYNC.rdsync_delaypipe = rdsync_delaypipe,
        ASYNC.wrsync_delaypipe = wrsync_delaypipe,
        ASYNC.lpm_showahead = lpm_showahead,
        ASYNC.underflow_checking = underflow_checking,
        ASYNC.overflow_checking = overflow_checking,
        ASYNC.lpm_hint = lpm_hint;

// CONTINOUS ASSIGNMENT
    assign rdfull =  w_rdfull_a;
    assign wrfull =  w_wrfull_a;
    assign rdempty = w_rdempty_a;
    assign wrempty = w_wrempty_a;
    assign rdusedw = w_rdusedw_a;
    assign wrusedw = w_wrusedw_a;
    assign q = w_q_a;
endmodule // lpm_fifo_dc
// END OF MODULE

//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_inpad
//
// Description     :  
//
// Limitation      :  n/a
//
// Results expected:  
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_inpad (
    pad,
    result
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;
    parameter lpm_type = "lpm_inpad";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] pad;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg    [lpm_width-1:0] result;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $finish;
        end
    end
    
// ALWAYS CONSTRUCT BLOCK
    always @(pad)
    begin
        result = pad;
    end

endmodule // lpm_inpad
// END OF MODULE


//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_outpad
//
// Description     :  
//
// Limitation      :  n/a
//
// Results expected:  
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_outpad (
    data,
    pad
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;
    parameter lpm_type = "lpm_outpad";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] data;

// OUTPUT PORT DECLARATION   
    output [lpm_width-1:0] pad;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg    [lpm_width-1:0] pad;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $finish;
        end
    end
    
// ALWAYS CONSTRUCT BLOCK
    always @(data)
    begin
        pad = data;
    end

endmodule // lpm_outpad
// END OF MODULE


//START_MODULE_NAME------------------------------------------------------------
//
// Module Name     :  lpm_bipad
//
// Description     :  
//
// Limitation      :  n/a
//
// Results expected:  
//
//END_MODULE_NAME--------------------------------------------------------------

// BEGINNING OF MODULE
`timescale 1 ps / 1 ps

// MODULE DECLARATION
module lpm_bipad (
    data,
    enable,
    result,
    pad
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;
    parameter lpm_type = "lpm_bipad";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] data;
    input  enable;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;

// INPUT/OUTPUT PORT DECLARATION
    inout  [lpm_width-1:0] pad;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg    [lpm_width-1:0] result;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $finish;
        end
    end
    
// ALWAYS CONSTRUCT BLOCK
    always @(data or pad or enable)
    begin
        if (enable == 1)
        begin
            result = 'bz;
        end
        else if (enable == 0)
        begin
            result = pad;
        end
    end

// CONTINOUS ASSIGNMENT
    assign pad = (enable == 1) ? data : {lpm_width{1'bz}};

endmodule // lpm_bipad
// END OF MODULE

