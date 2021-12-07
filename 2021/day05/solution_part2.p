
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

define variable viCounter as integer   no-undo.
define variable vcPoint1  as character no-undo.
define variable vcArrow   as character no-undo.
define variable vcPoint2  as character no-undo.
define variable vi        as integer   no-undo.
define variable vX        as integer   no-undo.
define variable vY        as integer   no-undo.
define variable viMax     as integer   no-undo.
define variable viMin     as integer   no-undo.

define temp-table ttLine no-undo
  field LineNumber as integer 
  field X1 as integer
  field Y1 as integer 
  field X2 as integer 
  field Y2 as integer
  index PK is primary unique 
    LineNumber.
    
define temp-table ttOverlap no-undo
  field X as integer 
  field Y as integer
  field O as integer 
  index PK is primary unique
    X
    Y.   

/* ************************  Function Prototypes ********************** */
function UpdateOverlaps returns character 
  (input ipiX as integer , input ipiY as integer   ) forward.

/* ************************  Function Implementations ***************** */


function UpdateOverlaps returns character 
  (input ipiX as integer , input ipiY as integer   ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/  

  find ttOverlap where ttOverlap.X = ipiX and ttOverlap.Y = ipiY no-error.
  
  if available(ttOverlap) then ttOverlap.O = ttOverlap.O + 1. 
  else do:
    create ttOverlap.
    assign
      ttOverlap.X = ipiX
      ttOverlap.Y = ipiY
      ttOverlap.O = 1.
  end.

    
end function.


// read the file     
 input from value(search("day05/input.txt")).
 
 repeat :

   import vcPoint1 vcArrow vcPoint2.  

   viCounter = viCounter + 1 .
 
   create ttLine.
   assign
     ttLine.LineNumber = viCounter
     ttLine.X1 = int(entry(1, trim(vcPoint1)))
     ttLine.Y1 = int(entry(2, trim(vcPoint1)))
     ttLine.X2 = int(entry(1, trim(vcPoint2)))
     ttLine.Y2 = int(entry(2, trim(vcPoint2)))
     .       
 end.
 
 input close.
  
 
 for each ttLine no-lock : 
 
   assign
     viMax = 0
     viMin = 0.
     
   if ttLine.X1 = ttLine.X2 then /* vertical */ 
   do:
     viMax = max(ttLine.Y1, ttLine.Y2).
     viMin = min(ttLine.Y1, ttLine.Y2).
     do vi = viMin to viMax : 
       UpdateOverlaps(ttLine.X1, vi).
     end.
   end.
   
   if ttLine.Y1 = ttLine.Y2 then /* horizontal */ 
   do:
     viMax = max(ttLine.X1, ttLine.X2).
     viMin = min(ttLine.X1, ttLine.X2).
     do vi = viMin to viMax : 
       UpdateOverlaps(vi,ttLine.Y1).
     end.
   end.
   
   if absolute(ttLine.X1 - ttLine.X2) = absolute(ttLine.Y1 - ttLine.Y2) then /* diagonal 45 ° */
   do:
     if ttLine.X1 < ttLine.X2 then do :
       vY = ttLine.Y1. 
       do vX = ttLine.X1 to ttLine.X2: 
         UpdateOverlaps(vX, vY).
         if ttLine.Y1 > ttLine.Y2 then vY = vY - 1.
                                  else vY = vY + 1. 
       end.
     end.
     
     if ttLine.X1 > ttLine.X2 then 
     do :
       vY = ttLine.Y1. 
       do vX = ttLine.X1 to ttLine.X2 by -1: 
         UpdateOverlaps(vX, vY). 
         if ttLine.Y1 > ttLine.Y2 then vY = vY - 1.
                                  else vY = vY + 1.
       end.
     end.
   end. 
      
end.     


//get the overlaps 
define variable viOverlaps as integer no-undo.

for each ttOverlap where ttOverlap.O > 1 :
  viOverlaps = viOverlaps + 1.
end. 

message "Number of overlaps : " viOverlaps
view-as alert-box.

/*
Number of overlaps : 21373
*/

