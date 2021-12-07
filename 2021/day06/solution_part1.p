
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

/* rather slow */

/* ************************  Function Prototypes ********************** */
function GetNumRecords returns int64 
  (  ) forward.

function TableToString returns character 
  (  ) forward.
  
define variable vcInput              as character no-undo.
define variable vcLanterfish         as longchar  no-undo.
define variable vi                   as integer   no-undo.
define variable vj                   as integer   no-undo.
define variable viNumLanterFishToAdd as integer   no-undo.
define variable viEntries            as integer   no-undo.
define variable s                    as integer   no-undo.

define temp-table ttLanterfish no-undo
  field Nr as int64
  field Age as integer 
  index PK is primary unique
    Nr. 
  

// read the file     
input from value(search("day06/input.txt")).
import vcInput. 
input close.

do vi = 1 to num-entries (vcInput) : 
  create ttLanterfish.
  assign
    ttLanterfish.Nr = vi
    ttLanterfish.Age = int(entry(vi,vcInput))
    . 
end.
  
do vi = 1 to 80 :

  viEntries = GetNumRecords().
    
  do vj = 1 to  viEntries:
    
    find ttLanterfish where ttLanterfish.Nr = vj no-error.
    
    if ttLanterfish.Age = 0 then viNumLanterFishToAdd = viNumLanterFishToAdd + 1.
    
    ttLanterfish.Age = ttLanterfish.Age - 1.
    
    if ttLanterfish.Age = -1 then 
       assign ttLanterfish.Age = 6.
  
    
  end.
  
  if viNumLanterFishToAdd <> 0 then 
  do s = 1 to viNumLanterFishToAdd:
     
    create ttLanterfish.
    assign
      ttLanterfish.Nr  = viEntries + s
      ttLanterfish.Age = 8
      .
      
  end.
  
  viNumLanterFishToAdd = 0.
  
  display vi.
       
end.

message GetNumRecords()
view-as alert-box.  



/* ************************  Function Implementations ***************** */
function GetNumRecords returns int64 
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/  

    define query q for ttLanterfish.
    
    query q:query-prepare("preselect each ttLanterfish").
    query q:query-open().


    return query q:num-results.
    
end function.

function TableToString returns character 
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/  

    define variable vcResult as character no-undo.

    for each ttLanterfish by ttLanterfish.Nr : 
      vcResult = vcResult + ",":u + string(ttLanterfish.Age).
    end.

    return trim(vcResult, ",":u).


    
end function.
