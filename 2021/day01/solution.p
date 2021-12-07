
/*------------------------------------------------------------------------
    File        : solution.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : gdb
    Created     : Thu Dec 02 17:17:42 CET 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

/* part 1 */ 

define variable vcInput as character no-undo.
define variable vcValue as character no-undo.
define variable viCount as integer   no-undo.
define variable vi      as integer   no-undo.

// read the file 
input from value("day01/input.txt":u).

repeat : 
  import vcValue.
  vcInput = vcInput + ",":u + vcValue.
end.

input close.

vcInput = trim(vcInput,",":u).

do vi = 1 to num-entries(vcInput) - 1 : 
  if int(entry(vi + 1 , vcInput)) > int(entry(vi, vcInput)) then viCount = viCount + 1.
end.
  
/* part 2 */
  
define variable viValue1 as integer no-undo.
define variable viValue2 as integer no-undo.
define variable viCount2 as integer no-undo.

do vi = 1 to num-entries(vcInput) - 3 :
     
  assign 
    viValue1 = int(entry(vi , vcInput)) + int(entry(vi + 1 , vcInput)) + int(entry(vi + 2 , vcInput))
    viValue2 = int(entry(vi + 1, vcInput)) + int(entry(vi + 2 , vcInput)) + int(entry(vi + 3 , vcInput)).
     
  if viValue2 > viValue1 then viCount2 = viCount2 + 1.
end.
   
message "Part 1 : " viCount  skip     /* 1316 */ 
        "Part 2 : " viCount2 skip     /* 1344 */ 
  view-as alert-box. 
   