
/*------------------------------------------------------------------------
    File        : solution_part1.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : gdb
    Created     : Sun Dec 05 11:18:03 CET 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

using day08.Digit from propath.

/* ************************  Function Prototypes ********************** */


define variable vcInput    as character no-undo.
define variable vi         as integer   no-undo.
define variable vcDigits   as character no-undo.
define variable vcSegments as character no-undo.
define variable vclijn     as character no-undo.
define variable vcLetters  as character no-undo.
define variable viLength   as integer   no-undo.
define variable viSom      as integer   no-undo.
define variable viCount    as integer   extent 10 no-undo.
define variable voDigit    as Digit     no-undo.
define variable viSom2     as int64     no-undo.
define variable vcSom as character no-undo.

// read the file     
input from value(search("day08/input.txt")).

voDigit = new Digit().

repeat : 
  import unformatted vclijn.

  assign 
    vcSegments = trim(entry(1, vclijn, "|":u))
    vcDigits   = trim(entry(2, vclijn, "|":u)).
    
  voDigit:DetermineSegments(vcSegments).
  
  vcSom = "":u.
  
  do vi = 1 to num-entries(vcDigits," ":u) :
    assign
      viLength = length(entry(vi, vcDigits," ":u))
     .
     
   case vilength:
     when 2 /* 1 */ then assign viCount[1] = vicount[1] + 1
                                 vcSom = vcSom +  "1".
     when 4 /* 4 */ then assign viCount[4] = vicount[4] + 1
                                vcSom = vcSom +  "4".
     when 3 /* 7 */ then assign viCount[7] = vicount[7] + 1
                                 vcSom = vcSom +  "7".
     when 7 /* 8 */ then assign viCount[8] = vicount[8] + 1
                                 vcSom = vcSom +  "8".
    when 5 /* 2,3,5 */ or when 6 /* 0,6,9 */  then vcSom = vcSom + voDigit:GetNumber(vilength, entry(vi,vcDigits, " ":u)).
   end.
  end.
 
  viSom2 = viSom2 + int(vcSom).
  
end. 
input close.

/* count digit 1, 4 ,7 & 8 */
visom  = viCount[1] + viCount[4] + viCount[7] + viCount[8].

message "Part 1 : " viSom skip
        "Part 2 : " viSom2
view-as alert-box.



