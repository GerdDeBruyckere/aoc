
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

for each ttAssignment : 
  
  assign 
    viBeginElf1 = integer(entry(1,ttAssignment.Elf1,"-":u))
    viEndElf1   = integer(entry(2,ttAssignment.Elf1,"-":u))
    viBeginElf2 = integer(entry(1,ttAssignment.Elf2,"-":u))
    viEndElf2   = integer(entry(2,ttAssignment.Elf2,"-":u))
    .

  if (viBeginElf1 <= viBeginElf2 and viEndElf1 >= viEndElf2) or 
     (viBeginElf1 >= viBeginElf2 and viEndElf1 <= viEndElf2) then
  
    ttAssignment.Overlap = true.   
end.

define variable vi as integer no-undo.

for each ttAssignment where ttAssignment.Overlap = true : 
  vi = vi + 1 .
end.

message vi view-as alert-box.
/*
---------------------------
Message (Press HELP to view stack trace)
---------------------------
509
---------------------------
OK   Help   
---------------------------
*/