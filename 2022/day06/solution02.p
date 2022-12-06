
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
define variable vlcInput as character no-undo.

// read the file 
input from value("2022/day06/input.txt":u).

loopRead:
repeat:
  
  import unformatted vlcInput. 
  
end.

define variable vi as integer no-undo.
define variable vcMessage as character no-undo.
define variable vj as integer no-undo.
define variable vcChar as character no-undo.
define variable vlUnique as logical no-undo.
define variable viResult as integer no-undo.

loopInput:
do vi = 1 to length(vlcInput) : 
  
  assign vcMessage = substring(vlcInput, vi, 14).
  
  vlUnique = true.
  loopMarker:
  do vj = 1 to length(vcMessage) : 
    vcChar = substring(vcMessage, vj, 1).
    if length(replace(vcMessage, vcChar,"":u)) <> 13 then do: 
      vlUnique = false.
      leave loopMarker.
    end.    
  end.
  
  if vlUnique then do:
    viResult = vi + 14 - 1.
    leave loopInput.
  end.  
end.



message  viResult
  view-as alert-box.

input close.
  