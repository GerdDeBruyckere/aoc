
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

function GetMinSteps returns integer 
  (  ) forward.

define temp-table ttCrab no-undo
  field Nr as integer 
  field Position as integer
  index pk is primary unique
    Nr.

define temp-table ttSteps no-undo
  field Nr    as integer 
  field Steps as integer
  index pk is primary unique
    Nr.    

define variable vcInput    as character no-undo.
define variable vi         as integer   no-undo.
define variable viMin      as integer   initial 9999999 no-undo.
define variable viMax      as integer   initial -1 no-undo.
define variable viResult   as integer   initial -1 no-undo.
define variable viSteps    as integer   no-undo.
define variable viNumsteps as integer   no-undo.
define variable vj         as integer   no-undo.

// read the file     
input from value(search("day07/input.txt")).
import vcInput. 
input close.

//vcInput = "16,1,2,0,4,2,7,1,2,14":u.

do vi = 1 to num-entries (vcInput) : 
  create ttCrab.
  assign
    ttCrab.Nr = vi
    ttCrab.position = int(entry(vi,vcInput))
    viMin = minimum (vimin, ttCrab.Position).   
    viMax = max (vimax, ttCrab.Position).
    . 
end.

do vi = viMin to viMax :
  
  viSteps = 0 . 
  for each ttCrab: 
    viSteps = viSteps + absolute (ttCrab.Position - vi)   .
  end.
  
  create ttSteps.
    assign
      ttSteps.Nr = vi
      ttSteps.Steps = viSteps.
 end.  

message "Part 1 : " GetMinSteps()
view-as alert-box.


empty temp-table ttSteps.

do vi = viMin to viMax :
  
  viSteps = 0 . 
  for each ttCrab: 
    assign viNumSteps = absolute (ttCrab.Position - vi).
    
    viSteps = viSteps + viNumSteps * (viNumSteps + 1) / 2.
  end.
  
  create ttSteps.
  assign
    ttSteps.Nr = vi
    ttSteps.Steps = viSteps.
     
end.  
//temp-table ttSteps:write-json("file", "c:\temp\ttsteps.json").

define variable viVal as integer no-undo.
viVal = GetMinSteps().

message "Part 2 : " vival
view-as alert-box.

/* ************************  Function Implementations ***************** */

function GetMinSteps returns integer 
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/  

    define query q for ttSteps.
    define variable viMin as integer initial 999999999 no-undo.
    
    query q:query-prepare("for each ttSteps").
    query q:query-open().
    
    query q:get-first().
    
    do while not (query q:query-off-end) : 
      viMin = min(viMin , ttSteps.Steps).
      query q:get-next().
    end.
    

    return viMin.

    
end function.
