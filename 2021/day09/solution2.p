
/*------------------------------------------------------------------------
    File        : solution2.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : gdb
    Created     : Thu Dec 09 16:21:08 CET 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/*
The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.

The top-left basin, size 3:

2199943210
3987894921
9856789892
8767896789
9899965678
*/

define variable vcInput  as character no-undo.
define variable vi       as integer   initial 0 no-undo.
define variable vj       as integer   no-undo.  

define temp-table ttRaster no-undo
  field X           as integer
  field Y           as integer
  field Val         as integer 
  field isBassin    as logical 
  field isProcessed as logical  
  index PK is primary unique 
  X
  Y
  .
  
define temp-table ttBassin no-undo
  field X           as integer
  field Y           as integer
  field BassinSize  as integer 
  index PK is primary unique 
  X
  Y
  .  

input from value(search("day09/input_full.txt")).
repeat : 
  vi = vi + 1.
  
  import unformatted vcInput.
  
  do vj = 1 to length(vcInput) :
     
    create ttRaster.
    assign
      ttRaster.X    = vj 
      ttRaster.Y    = vi
      ttRaster.Val  = integer(substring(vcInput, vj,1))
      .
  end.  
end. 
input close.


define buffer b for ttRaster.

define variable viValue as integer no-undo.
define variable viSizeBassin as integer no-undo.
define variable viResult as integer initial 1 no-undo.


/* ************************  Function Prototypes ********************** */


function CheckBassin returns integer 
  ( input ipiX as integer , input ipiY as integer ) forward.

function DetermineSizeBassin returns integer 
  (input ipiX as integer , input ipiY as integer  ) forward.

for each ttRaster 
     by ttRaster.Y
     by ttRaster.X : 
  CheckBassin(ttRaster.X,ttRaster.Y).
end.

for each ttRaster where ttraster.isbassin = true :

  create ttBassin.
  assign 
    ttBassin.X = ttRaster.X
    ttBassin.Y = ttRaster.Y
    ttBassin.BassinSize =  DetermineSizeBassin(ttRaster.X, ttRaster.Y).
  
end.

temp-table ttbassin:write-json("file", "c:\temp\ttBassin.json").
   
vi = 0.
for each ttBassin by ttBassin.BassinSize descending : 
  vi = vi + 1.
  viResult = viResult * ttBassin.BassinSize.
  if vi = 3 then leave.
end.

message viResult
view-as alert-box.



/* ************************  Function Implementations ***************** */
function CheckBassin returns integer 
  ( input ipiX as integer , input ipiY as integer   ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/  

define variable viUnder as integer no-undo.
define variable viAbove as integer no-undo.
define variable viLeft as integer no-undo.
define variable viRight as integer no-undo.


  find ttRaster where ttRaster.X = ipiX 
                  and ttRaster.Y = ipiY no-error.
  
  if available(ttRaster) then 
  do:
       viValue = ttRaster.Val.
       /* above */ 
       find b no-lock where b.X = ttRaster.X and b.Y = ttRaster.Y - 1 no-error.
       viAbove = if available(b) then b.Val else 9.
       
       /* under */ 
       find b no-lock where b.X = ttRaster.X and b.Y = ttRaster.Y + 1 no-error.
       viUnder = if available(b) then b.Val else 9.
       
       /* left */ 
       find b no-lock where b.X = ttRaster.X - 1 and b.Y = ttRaster.Y no-error.
       viLeft = if available(b) then b.Val else 9.
       
       /* right */ 
       find b no-lock where b.X = ttRaster.X + 1 and b.Y = ttRaster.Y no-error.
       viRight = if available(b) then b.Val else 9.
       
       if viValue < viAbove and viValue < viUnder and viValue < viLeft and viValue < viRight 
       then 
         ttRaster.isBassin = true. 
  end.
  
  return 0.
    
end function.

function DetermineSizeBassin returns integer 
  ( input ipiX as integer , input ipiY as integer ):
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/  

  define variable viUnder as integer no-undo.
  define variable viAbove as integer no-undo.
  define variable viLeft  as integer no-undo.
  define variable viRight as integer no-undo.


  define variable vi# as integer no-undo.
  define buffer c for ttRaster.
  define variable viSize as integer no-undo.

  find c where c.X = ipiX
           and c.Y = ipiY no-error.

  if available(c) and c.isProcessed = false then
  do:
    c.isProcessed = true.
       vi# = vi# + 1.
       /* above */
       find b no-lock where b.X = c.X and b.Y = c.Y - 1 no-error.
       viAbove = if available(b) then b.Val else 9.

       /* under */
       find b no-lock where b.X = c.X and b.Y = c.Y + 1 no-error.
       viUnder = if available(b) then b.Val else 9.

       /* left */
       find b no-lock where b.X = c.X - 1 and b.Y = c.Y no-error.
       viLeft = if available(b) then b.Val else 9.

       /* right */
       find b no-lock where b.X = c.X + 1 and b.Y = c.Y no-error.
       viRight = if available(b) then b.Val else 9.

       if viRight <> 9
       then do:
         //if not (c.isProcessed) then 
         vi# = vi# + DetermineSizeBassin (c.X + 1, c.Y).
       end.
       if viLeft <> 9
       then do:
         //if not (c.isProcessed) then 
         vi# = vi# + DetermineSizeBassin (c.X - 1, c.Y).
       end.
       if viAbove <> 9
       then do:
         //if not (c.isProcessed) then 
         vi# = vi# + DetermineSizeBassin (c.X, c.Y - 1).
       end.
       if viUnder <> 9
       then do:
         //if not (c.isProcessed) then 
         vi# = vi# + DetermineSizeBassin (c.X, c.Y + 1).
       end.
       return vi#.
  end.
  else vi# = 0.

  return vi#.


    
end function.
