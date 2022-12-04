
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

define temp-table ttAssignment no-undo
  field Elf1 as character
  field Elf2 as character
  field Overlap as logical 
  .

define variable vcPair as character no-undo.
/* part 1 */ 


// read the file 
input from value("2022/day04/input.txt":u).


repeat :
  import vcPair.
  
  if num-entries(vcPair) = 2 then
  do:
    create ttAssignment.
    assign 
      ttAssignment.Elf1 = entry(1, vcPair)
      ttAssignment.Elf2 = entry(2, vcPair)
      .
  end.
end.

input close.

define variable viBeginElf1 as integer no-undo.
define variable viEndElf1   as integer no-undo.
define variable viBeginElf2 as integer no-undo.
define variable viEndElf2   as integer no-undo.
define variable vi as integer no-undo.
define variable vcElf1 as character no-undo.

message "k"
  view-as alert-box.

for each ttAssignment where ttassignment.elf1 > "":u : 
  
  assign 
    viBeginElf1 = integer(entry(1,ttAssignment.Elf1,"-":u))
    viEndElf1   = integer(entry(2,ttAssignment.Elf1,"-":u))
    viBeginElf2 = integer(entry(1,ttAssignment.Elf2,"-":u))
    viEndElf2   = integer(entry(2,ttAssignment.Elf2,"-":u))
    vcElf1      = "".
  
  do vi = viBeginElf1 to viEndElf1 : 
    vcElf1 = vcElf1 + ",":u + string(vi).
  end.
  
  do vi = viBeginElf2 to viEndElf2 : 
    if lookup(string(vi), vcElf1) > 0 then 
    ttAssignment.Overlap = true.   
  end.
end.
vi = 0.

for each ttAssignment where ttAssignment.Overlap = true : 
  vi = vi + 1 .
end.

message vi view-as alert-box.
/*
---------------------------
Message (Press HELP to view stack trace)
---------------------------
870
---------------------------
OK   Help   
---------------------------
*/