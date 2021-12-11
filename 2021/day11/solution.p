
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

/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


function CountFlashes returns integer 
  (  ) forward.

function CountZero returns integer 
  (  ) forward.


/* ***************************  Main Block  *************************** */

define variable vcFlashLevels as character format "x(15)" no-undo.
define variable viX as integer no-undo.
define variable viY as integer no-undo.
 
define temp-table ttFlash no-undo
  field X as integer 
  field Y as integer 
  field FlashLevel as integer 
  field flash# as integer 
  field hasFlashed as logical
  .
define variable viSom as integer no-undo.
define variable vi as integer no-undo.

input from value(search("day11/input.txt")).
repeat : 
  import vcFlashLevels.
  if vcFlashLevels eq "":u then leave.
  viY = viY + 1.
  do viX = 1 to length(vcFlashLevels) : 
    create ttFlash.
    assign 
      ttFlash.x = viX
      ttFlash.y = viY
      ttFlash.FlashLevel = int(substring(vcFlashLevels,viX,1)).
  end.
end.
input close.

viSom = 0.
define variable viStep as integer no-undo.
viStep = 0.
outerblock:
repeat:
  vi = 0.
  
  /* raise every level + 1 */ 
  for each ttFlash : 
    ttFlash.FlashLevel = ttFlash.FlashLevel + 1.
  end.
  
  repeatblock:
  repeat : 
    find first ttFlash where ttFlash.FlashLevel > 9 and ttFlash.hasFlashed = false no-error.
    if available(ttFlash) 
    then run CheckFlash(input ttFlash.X, input ttFlash.Y).  
    else leave repeatblock.
  end.
    
  //reset the board 
  for each ttFlash where ttFlash.hasFlashed: 
    assign 
      ttFlash.hasFlashed = false
      ttFlash.FlashLevel = 0.
      viSom = viSom + 1.
  end.
    
  vi = 0.
  for each ttFlash where ttFlash.FlashLevel > 0:
    vi = vi + 1.
  end.
  viStep = viStep + 1.
  if vi = 0 then leave outerblock. 
end.

/*vi = 0.                                                      */
/*for each ttFlash by ttFlash.y by ttFlash.x                   */
/*:                                                            */
/*  vi = vi + 1.                                               */
/*  vcFlashLevels = vcFlashLevels + string(ttFlash.FlashLevel).*/
/*                                                             */
/*  if vi mod 10 = 0 then do:                                  */
/*    display vcFlashLevels.                                   */
/*    assign vcFlashLevels = "":u    .                         */
/*  end.                                                       */
/*end.                                                         */
message "Part 1 : " viSom
  view-as alert-box.
  
message "Part 2 : " viStep
view-as alert-box.  

procedure CheckFlash :
  define input parameter ipiX as integer no-undo.
  define input parameter ipiY as integer no-undo.
  
  define buffer c for ttFlash.
  define buffer b for ttFlash .
     
  find c where c.x = ipiX 
                 and c.Y = ipiY 
                 no-error. 
                 
  if available(c) then do:  
     c.hasFlashed = true.
     /* adjacent */  
    
    /*left up */ 
    find b where b.X = c.x - 1 and b.Y = c.Y - 1 no-error.
    if available(b) then b.FlashLevel = b.FlashLevel + 1.
    
    /* up */ 
    find b where b.X = c.x and b.Y = c.Y - 1 no-error.
    if available(b) then b.FlashLevel = b.FlashLevel + 1.    
    
    /* right up */ 
    find b where b.X = c.x + 1 and b.Y = c.Y - 1 no-error.
    if available(b) then b.FlashLevel = b.FlashLevel + 1. 
    
    /* left */ 
    find b where b.X = c.x - 1 and b.Y = c.Y no-error.
    if available(b) then b.FlashLevel = b.FlashLevel + 1.
    
    /* right */ 
    find b where b.X = c.x + 1 and b.Y = c.Y no-error.
    if available(b) then b.FlashLevel = b.FlashLevel + 1.
    
    /* down left */ 
    find b where b.X = c.x - 1 and b.Y = c.Y + 1 no-error.
    if available(b) then b.FlashLevel = b.FlashLevel + 1.
    
    /* down  */ 
    find b where b.X = c.x  and b.Y = c.Y + 1 no-error.
    if available(b) then b.FlashLevel = b.FlashLevel + 1.
    
    /* down right */ 
    find b where b.X = c.x + 1 and b.Y = c.Y + 1 no-error.
    if available(b) then b.FlashLevel = b.FlashLevel + 1.
    
  end.
  
end procedure.







