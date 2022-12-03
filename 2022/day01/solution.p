
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

define temp-table ttElve no-undo
  field ElveNumber as int64
  field ElveTotal  as int64
  .

define variable vcInput as character no-undo.
define variable vcValue as character no-undo.
define variable viCount as integer   no-undo.
define variable viElve  as integer   no-undo.

// read the file 
input from value("2022/day01/input.txt":u).

define variable viValue as integer no-undo.

repeat : 
  import vcValue.
  
  if vcValue eq "":u then do: 
    create ttElve.
    assign ttElve.ElveNumber = viElve + 1
           ttElve.ElveTotal  = viCount
           viCount           = 0 
           viElve            = viElve + 1.
  end.
  else 
    viCount = viCount + int(vcValue).           
  
  vcValue = "":u.
end.

input close.

define variable vi as integer no-undo.
define variable viTotal as integer no-undo.

for each ttElve no-lock by ttElve.ElveTotal descending:
  vi = vi + 1.
  viTotal = viTotal + ttElve.ElveTotal. 
  if vi = 1 then message ttElve.ElveNumber skip ttElve.ElveTotal view-as alert-box.
  if vi = 3 then do:
    message viTotal
      view-as alert-box.
    leave.
  end.
end.
 