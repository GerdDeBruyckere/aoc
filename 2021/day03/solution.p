/* ********************************************************
Advent of code - day 3
******************************************************** */ 
block-level on error undo, throw.

using System.Convert from assembly.


/* ************************  Function Prototypes ********************** */
function CountTTRecords returns integer 
  ( input ipcTable as character ) forward.

function DeleteEntriesTT returns logical 
  ( input ipcTable        as character,
    input ipiBitPosition  as integer,
    input ipiBitValue     as integer ) forward.

// variables
define variable vcBinary     as character no-undo.
define variable viTeller     as integer   initial 0 no-undo.

// temp-table definitions
define temp-table ttBinary no-undo
  field nr as integer 
  field binaryNumber as character
  index PK is primary unique 
    nr.

define temp-table ttOxygen no-undo like ttBinary.
define temp-table ttCO2    no-undo like ttBinary.

// read the file 
input  from value(search("day03/input.txt":u)).

repeat : 

  import vcBinary.

  create ttBinary.
  assign 
    viteller              = viteller + 1
    ttBinary.nr           = viTeller
    ttBinary.binaryNumber = trim(vcBinary)
    .
end.

input  close.

empty temp-table ttOxygen.
empty temp-table ttCO2.

for each ttBinary : 
  create ttOxygen.
  create ttCO2.
  buffer-copy ttBinary to ttOxygen.
  buffer-copy ttBinary to ttCO2.
end.

// part 1 

define variable viLength        as integer   no-undo.
define variable vi              as integer   no-undo.
define variable vcGamma         as character extent no-undo.
define variable vcEpsilon       as character extent no-undo.  
define variable viGamma         as integer   no-undo.
define variable vcGammaString   as character no-undo.
define variable vcEpsilonString as character no-undo.
define variable viEpsilon       as integer   no-undo.
define variable viCount0        as integer   no-undo.
define variable viCount1        as integer   no-undo.

// find the length of the binary string
find first ttBinary no-lock no-error.
if available (ttBinary) then viLength = length(ttBinary.binaryNumber).

// set the extent size
extent(vcGamma) = viLength.
extent(vcEpsilon) = viLength.

do vi = 1 to viLength : 
  
  assign viCount0 = 0
         viCount1 = 0.
  
  for each ttBinary : 
    
    case substring(ttBinary.binaryNumber,vi,1):
      when "0" then viCount0 = viCount0 + 1.
      when "1" then viCount1 = viCount1 + 1.
    end case.
    
  end.
  
  if viCount0 > viCount1 then assign vcGamma[vi]   = "0"
                                     vcEpsilon[vi] = "1".
                         else assign vcGamma[vi]   = "1"
                                     vcEpsilon[vi] = "0".
  
end.  

do vi = 1 to extent(vcGamma) : 
  assign vcGammaString   = vcGammaString   + vcGamma[vi]
         vcEpsilonString = vcEpsilonString + vcEpsilon[vi].
end.

assign
  viGamma   = Convert:ToInt32(vcGammaString, 2)
  viEpsilon = Convert:ToInt32(vcEpsilonString, 2).

message "Gamma string   : " vcGammaString       skip 
        "Epsilon string : " vcEpsilonString     skip 
        "Gamma number   : " viGamma             skip
        "Epsilon number : " viEpsilon           skip
        "Result         : " viGamma * viEpsilon
view-as alert-box.
/*
Gamma string :  101110101011 
Epsilon string :  010001010100 
Gamma number :  2987 
Epsilon number :  1108 
Result :  3309596
*/

/* *************
     Part 2 
************* */

/* oxygen */ 
/*
Start with all 12 numbers and consider only the first bit of each number. There are more 1 bits (7) than 0 bits (5), so keep only the 7 numbers with a 1 in the first position: 11110, 10110, 10111, 10101, 11100, 10000, and 11001.
Then, consider the second bit of the 7 remaining numbers: there are more 0 bits (4) than 1 bits (3), so keep only the 4 numbers with a 0 in the second position: 10110, 10111, 10101, and 10000.
In the third position, three of the four numbers have a 1, so keep those three: 10110, 10111, and 10101.
In the fourth position, two of the three numbers have a 1, so keep those two: 10110 and 10111.
In the fifth position, there are an equal number of 0 bits and 1 bits (one each). So, to find the oxygen generator rating, keep the number with a 1 in that position: 10111.
As there is only one number left, stop; the oxygen generator rating is 10111, or 23 in decimal.
*/
define variable viNumber0 as integer no-undo.
define variable viNumber1 as integer no-undo.
define variable vj        as integer no-undo.

vi = CountTTRecords("oxygen":u).

do while vi > 1 : 
  do vj = 1 to 12 : 
    run GetQuantities("oxygen":u, vj, output viNumber0, output viNumber1).
    if viNumber0 > viNumber1 then DeleteEntriesTT("oxygen", vj, 1).
                             else DeleteEntriesTT("oxygen", vj, 0).
                             
    vi = CountTTRecords("oxygen":u).
    if vi = 1 then leave.
  end.
end.

/* CO2 */ 
/* 
Start again with all 12 numbers and consider only the first bit of each number. There are fewer 0 bits (5) than 1 bits (7), so keep only the 5 numbers with a 0 in the first position: 00100, 01111, 00111, 00010, and 01010.
Then, consider the second bit of the 5 remaining numbers: there are fewer 1 bits (2) than 0 bits (3), so keep only the 2 numbers with a 1 in the second position: 01111 and 01010.
In the third position, there are an equal number of 0 bits and 1 bits (one each). So, to find the CO2 scrubber rating, keep the number with a 0 in that position: 01010.
As there is only one number left, stop; the CO2 scrubber rating is 01010, or 10 in decimal. 
*/ 
vi = CountTTRecords("co2":u).

do while vi > 1 : 
  do vj = 1 to 12 : 
    run GetQuantities("co2":u, vj, output viNumber0, output viNumber1).
    if viNumber0 > viNumber1 then DeleteEntriesTT("co2", vj, 0).
                             else DeleteEntriesTT("co2", vj, 1).
                             
    vi = CountTTRecords("co2":u).
    if vi = 1 then leave.
  end.
end.


/* get the one record that's left */ 
find first ttOxygen no-error.
assign 
  viNumber0 =  Convert:ToInt32(ttOxygen.binaryNumber, 2).

find first ttCO2 no-error.
assign 
  viNumber1 =  Convert:ToInt32(ttCO2.binaryNumber, 2).
  
message "Oxygen : " viNumber0  skip
        "CO2 : " viNumber1 skip 
        "Result : " viNumber0 * viNumber1
view-as alert-box.

/*
Oxygen :  2815 
CO2 :  1059 
Result :  2981085
*/

/* **********************  Internal Procedures  *********************** */


procedure GetQuantities:
  
  define input  parameter ipcTable    as character no-undo.
  define input  parameter ipiPosition as integer   no-undo.
  define output parameter opiNumber0  as integer   no-undo.
  define output parameter opiNumber1  as integer   no-undo.
  
  case ipcTable : 
    when "oxygen":u then do:
      for each ttOxygen :
        case substring(ttOxygen.binaryNumber, ipiPosition, 1) :
          when "0":u then assign opiNumber0 = opiNumber0 + 1.
          when "1":u then assign opiNumber1 = opiNumber1 + 1.
        end case.
      end.
    end.
    when "co2":u then do:
      for each ttCO2 :
        case substring(ttCO2.binaryNumber, ipiPosition, 1) :
          when "0":u then assign opiNumber0 = opiNumber0 + 1.
          when "1":u then assign opiNumber1 = opiNumber1 + 1.
        end case.
      end.
    end.
  end case.

end procedure.

/* ************************  Function Implementations ***************** */
function CountTTRecords returns integer 
  ( input ipcTable as character ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/  
  case ipcTable : 
    when "oxygen":u then do:
      define query q for ttOxygen cache 0.
      open query q preselect each ttOxygen.
      return num-results( "q" ).
    end.
    when "co2":u then do:
      define query s for ttCO2 cache 0.
      open query s preselect each ttCO2.
      return num-results( "s" ).
    end.
  end case.
    
end function.

function DeleteEntriesTT returns logical 
  ( input ipcTable        as character,
    input ipiBitPosition  as integer,
    input ipiBitValue     as integer ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/  

  case ipcTable : 
    when "oxygen":u then do:
      for each ttOxygen :
        if int(substring(ttOxygen.binaryNumber, ipiBitPosition,1)) = ipiBitValue then delete ttOxygen.    
      end.
    end.
    when "co2":u then do:
      for each ttCO2 :
        if int(substring(ttCO2.binaryNumber, ipiBitPosition,1)) = ipiBitValue then delete ttCO2.    
      end.
    end.
  end case.
        
end function.
