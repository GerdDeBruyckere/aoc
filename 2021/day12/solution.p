
/*------------------------------------------------------------------------
    File        : solution.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : gdb
    Created     : Fri Dec 10 11:36:13 CET 2021
    Notes       :
-------------------------------------------------------------------------*/     
      

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

using System.Char from assembly.

/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


function isUpper returns logical 
  ( input ipcString as character ) forward.



define variable vcPath as character no-undo.
define variable vi     as integer   no-undo.
 
define temp-table ttPath no-undo
  field BeginPoint as character 
  field EndPoint   as character 
  .

define temp-table ttSmallCave no-undo
  field cave as character
  field qty  as integer.

define temp-table ttPoint no-undo
  field Id as character 
  field isSmallCave as logical  
  .

define temp-table ttRoute no-undo
  field route as character format "x(40)"
  .

input from value(search("day12/input.txt")).
repeat : 
  import vcPath.
 
  /* from --> to */  
  create ttPath.
  assign
    ttPath.BeginPoint = entry(1, vcPath, "-":u)
    ttPath.EndPoint   = entry(2, vcPath, "-":u)
    .
  /* to --> from  */
  create ttPath.
  assign
    ttPath.BeginPoint = entry(2, vcPath, "-":u)
    ttPath.EndPoint   = entry(1, vcPath, "-":u)
    .
end.
input close.

define buffer ttPath2 for ttPath.
define buffer ttPath3 for ttPath.

define variable vcBeginPoint as character no-undo.
define variable vcEndpoint   as character no-undo.
define variable vcBeginPoint2 as character no-undo.
define variable vcEndpoint2  as character no-undo.
define variable vcBeginPoint3 as character no-undo.
define variable vcEndpoint3  as character no-undo.
define variable vcRoute as character format "x(40)"no-undo.


for each ttPath where ttPath.BeginPoint = "start":u :
  
  vcRoute  = ttPath.Beginpoint + "-" + ttPath.EndPoint.
  
  run NextPath(vcRoute).   
  
end.

procedure NextPath : 
  
  define input parameter ipcRoute      as character no-undo.
  
  define variable vcRoute          as character no-undo.
  define variable vcPoint          as character no-undo.
  define variable vlAllowed as logical   no-undo.
  define variable vcTwicePoint as character no-undo.
  
  define buffer b for ttPath.
  
  assign 
    vcPoint = entry(num-entries(ipcRoute,"-"), ipcRoute, "-").
      
  for each b where b.BeginPoint = vcPoint :
    
    if b.BeginPoint = "start":u or b.EndPoint = "start":u  then next.
    run CheckCaves(input ipcRoute, input b.EndPoint, output vlAllowed).
    if not vlAllowed then next.
    
    vcroute = ipcRoute + "-" + b.Endpoint.                                                    
  
    if entry(num-entries(vcRoute,"-"), vcRoute, "-") = "end":u then 
    do:
      create ttRoute.
      assign
        ttRoute.route = vcroute.
    end.
    else run NextPath(vcRoute).
    
  end.
end.

for each ttRoute : 
  
vi  = vi + 1.
end. 

display vi.

procedure CheckCaves : 
  
  define input parameter ipcCheckString as character no-undo.
  define input parameter ipcCharToAdd   as character no-undo.
  define output parameter oplAllowed    as logical   no-undo.
    
    define variable vi as integer no-undo.
    define variable vcEntry as character no-undo.
    define buffer c for ttSmallCave.
    
    empty temp-table ttSmallCave.
    
    if isUpper(ipcCharToAdd) then 
    do:
       oplAllowed = true.
       return.
    end.
    
    loop#: 
    do vi = 1 to num-entries (ipcCheckString, "-") : 
      
      vcEntry = entry(vi, ipcCheckString, "-":u).
      
      if vcEntry = "start" then next loop#. 
      
      if isUpper(vcEntry) then next loop#.
      
      find ttSmallCave where ttSmallCave.cave = vcEntry no-error.
      if not available(ttSmallCave) then do:
        create ttSmallCave.
        assign
          ttSmallCave.cave = vcEntry
          ttSmallCave.qty  = 1.
      end.
      else 
        ttSmallCave.qty = ttSmallCave.qty + 1.
    end.
    find first ttSmallCave where ttSmallCave.qty = 2 no-error.
    
    if available(ttSmallCave) then do:
      if ttSmallCave.cave =  ipcCharToAdd then oplAllowed = false.
                                          else do :
                                            find c no-lock where c.cave = ipcCharToAdd no-error.
                                            if not avail(c) then oplAllowed = true.
                                                            else oplAllowed = false.
                                          end.
    end.
    else oplAllowed = true.
    
    
end procedure.

function isUpper returns logical 
  ( input ipcString as character  ):
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/  
  define variable vi      as integer no-undo.
    
  do vi = 1 to length(ipcString) : 
    if not Char:isUpper(substring(ipcString, vi, 1)) then return false.  
  end.
  return true.
    
end function.
