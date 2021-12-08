
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

/* ************************  Function Prototypes ********************** */


define variable vcInput    as character no-undo.
define variable vi as integer no-undo.
define variable vcDigits as character no-undo.
define variable vclijn as character no-undo.
define variable viLength  as integer no-undo.
define variable viCount as integer extent 10 no-undo.

// read the file     
input from value(search("day08/input.txt")).
repeat : 
  import unformatted vclijn.

  vcDigits = trim(entry(2, vclijn, "|":u)).
  
  do vi = 1 to num-entries(vcDigits," ":u) :
    assign
      viLength = length(entry(vi, vcDigits," ":u)).
    case vilength:
      when 2 /* 1 */ then viCount[1] = vicount[1] + 1.
      when 4 /* 1 */ then viCount[4] = vicount[4] + 1.
      when 3 /* 7 */ then viCount[7] = vicount[7] + 1.
      when 7 /* 8 */ then viCount[8] = vicount[8] + 1.
      end case.
  end.    
  
end. 
input close.

/* count digit 1, 4 ,7 & 8 */
define variable visom as integer no-undo.
visom  = viCount[1] + viCount[4] + viCount[7] + viCount[8].
message visom
view-as alert-box.

