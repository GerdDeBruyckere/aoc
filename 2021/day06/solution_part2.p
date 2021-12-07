
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
function GetNumRecords returns int64 
  (  ) forward.

function TableToString returns character 
  (  ) forward.
  
define variable vcInput      as character no-undo.
define variable viNummer     as integer   no-undo.
define variable vi           as integer   no-undo.
define variable vj           as integer   no-undo.
define variable viLanterfish as decimal   extent 9 no-undo.
define variable viAantal     as decimal   no-undo.
define variable viSom        as dec       no-undo.

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
  viNummer = int(entry(vi, vcInput)).
  viLanterfish[viNummer + 1] = viLanterfish[viNummer + 1] + 1.  
end.
 
do vi = 1 to 256: 
  
  
  viaantal = viLanterFish [1].                                       
  
  do vj = 2 to 9:
    viLanterFish [vj - 1] = viLanterFish [vj].
  end.
  
  if viaantal ne 0 then assign viLanterFish [7] =   viLanterFish [7] + viaantal
                               viLanterFish [9] =  viAantal.
                   else        viLanterFish [9] =  0.
  
end.



do vi = 1 to extent(viLanterfish) : 
  visom = viSom + viLanterfish[vi].
end. 

message viSom
view-as alert-box.


/*

---------------------------
Message (Press HELP to view stack trace)
---------------------------
1639643057051
---------------------------
OK   Help   
---------------------------



*/


 /* too slow */ 
 /* 
do vi = 1 to 80 :
  
  /* */ 
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

*/



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
