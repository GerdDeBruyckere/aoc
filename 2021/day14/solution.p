block-level on error undo, throw.

define temp-table ttInsertion no-undo
  field pair    as character  
  field letter  as character 
  .
  
define temp-table ttQTY no-undo
  field letter as char
  field qty as integer.
  
define variable viMax         as integer   no-undo.
define variable viMin         as integer   no-undo.
define variable vi            as integer   no-undo.
define variable vcLine        as character no-undo.
define variable vcInputString as character no-undo.
define variable vcChar1       as character no-undo.
define variable vcChar2       as character no-undo.
define variable vcResult      as character no-undo.
define variable vcPair        as character no-undo.
define variable vj            as integer   no-undo.

input from value(search("C:\workspaces\OE122\gdb\AdventOfCode\2021\day14\input.txt")).
repeat : 
  import unformatted vcLine.
 
  if vcLine eq "":u then next.
 
  if num-entries (vcLine, "-") > 1 then do:
    create ttInsertion.
    assign
      ttInsertion.pair = substring(vcLine, 1, 2)
      ttInsertion.letter = substring(vcLine, length(vcLine), 1).
  end.
  else 
    vcInputString = vcLine.
  
end.
input close.
do vj = 1 to 10: 
  vcResult = "":u.
  do vi = 1 to length(vcInputString) - 1 :

    vcPair = substring(vcInputString, vi, 2).
    vcChar1 = substring(vcInputString, vi, 1) .
    vcChar2 = substring(vcInputString, vi + 1, 1) .

    find ttInsertion no-lock where ttInsertion.pair = vcPair no-error.
    if available(ttInsertion) then
    do:
      vcResult =  vcResult + vcChar1 + ttInsertion.letter .
    end.
    else 
      vcResult =  vcResult + vcChar1 .
    
  end.
  vcResult = vcResult + substring(vcInputString, length(vcInputString), 1) .
  vcInputString = vcResult.
  
end.

do vi = 1 to length(vcResult):
  find ttQty  where ttQTY.letter = substring(vcResult, vi, 1) no-error.
  if not available(ttQTY) then
  do:
    create ttQTY.
    assign ttQTY.letter =  substring(vcResult, vi, 1)
           ttQTY.qty    = 1.
  end.
  else  ttQTY.qty = ttQTY.qty + 1.
end.

for each ttQty by ttqty.qty descending:
  viMax = ttQTY.qty.
  leave.
end.
for each ttQty by ttqty.qty :
  viMin = ttQTY.qty.
  leave.
end.


message viMax - viMin
  view-as alert-box information buttons ok.

/* ************************  Function Prototypes ********************** */


function CreatePairs returns longchar 
  ( input iplcString as longchar  ) forward.


/* ************************  Function Implementations ***************** */


function CreatePairs returns longchar 
  ( input iplcString as longchar ):
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  define variable vcPairs      as character extent no-undo.
  define variable vlcNewString as longchar  no-undo.
  
  extent(vcPairs) = length(iplcString) - 1. 
  
  do vi = 1 to extent(vcPairs) :
    vcPairs[vi] = substring(iplcString, vi, 2).  
  end.  
  
  find ttInsertion no-lock where ttInsertion.pair = vcPair no-error.
  if available(ttInsertion) 
  then
    vcPairs[vi] =  substring(vcPairs[vi],1,1)  + ttInsertion.letter + substring(vcPairs[vi],2,1).
  
  do vi = 1 to extent(vcPairs) :
    vlcNewString = vlcNewString + vcPairs[vi].  
  end. 

  return vlcNewString.

    
end function.
