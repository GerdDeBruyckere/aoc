
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

  message "kik"
  view-as alert-box.
  
for each ttPath where ttPath.BeginPoint = "start":u :
  
  vcRoute  = ttPath.Beginpoint + "-" + ttPath.EndPoint.
  
  run NextPath(vcRoute).   
  
end.

procedure NextPath : 
  
  define input parameter ipcRoute      as character no-undo.
  
  define variable vcRoute      as character no-undo.
  define variable vcBeginPoint as character no-undo.
  define variable vcEndPoint   as character no-undo.
  define variable vcPoint      as character no-undo.
  define variable vcpoint2 as character no-undo.
  
  define buffer b for ttPath.
  
  assign 
    vcPoint = entry(num-entries(ipcRoute,"-"), ipcRoute, "-").
      
  for each b where b.BeginPoint = vcPoint :
    
    if b.BeginPoint = "start":u or b.EndPoint = "start":u  then next.
    
    if not isUpper(b.EndPoint) and lookup(b.EndPoint, ipcRoute, "-") > 0 then next.
    
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

/*
start,A,b,A,c,A,end
start,A,b,A,end
start,A,b,end
start,A,c,A,b,A,end
start,A,c,A,b,end
start,A,c,A,end
start,A,end
start,b,A,c,A,end
start,b,A,end
start,b,end
*/


/*

zoek naar alle paden waar start in zit 

--> vanaf eindpunt, zoek alle paden waar begin of einde gelijk is aan eindpunt van vorige 
--> herhaal tot eindpunt einde is , als einde is --> stop 


*/
    


/* ************************  Function Implementations ***************** */
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
