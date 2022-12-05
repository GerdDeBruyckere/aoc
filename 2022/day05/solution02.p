
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
define variable vcLine  as character format "x(50) "no-undo.
define variable vlMoves as logical no-undo.
define variable k as integer no-undo.

define temp-table ttStack no-undo
  field Stack as integer 
  field Crate as character
  field row   as integer. 

define temp-table ttMove no-undo
  field id as integer 
  field qty as integer 
  field fromStack as integer
  field toStack as integer.  

define variable vi as integer no-undo.
define variable viRow as integer initial 1 no-undo.
// read the file 
input from value("2022/day05/input.txt":u).

loopRead:
repeat:
  
  import unformatted vcLine. 
  
  if trim(vcLine) begins "1":u then do:
    vlMoves = true.
    import unformatted vcLine.
    next loopRead.
  end.
  
  if vcLine begins "move":u then do:
    create ttMove.
    assign ttMove.id        = k + 1
           ttMove.qty       = int(entry(2, vcLine, " ":u)) 
           ttMove.fromStack = int(entry(4, vcLine, " ":u))
           ttMove.toStack   = int(entry(6, vcLine, " ":u))
           k                = k + 1
           .
  end.
  else do : 
    
    do vi = 1 to length(vcLine) by 4 :
      if trim(substring(vcLine, vi, 4)) begins "[":u then 
      do:
        create ttStack.
        assign ttStack.row   = viRow
               ttStack.Crate = trim(substring(substring(vcLine, vi, 4), 2, 1))
               ttStack.Stack = (vi / 4) + 1.
      end.   
    end.
    viRow = viRow + 1.
  end.
    
  vcLine = "":u.
  
end.

input close.
vi = 1.
/* flip rows */ 
for each ttStack break by ttStack.Stack 
                       by ttStack.row descending:
  assign ttStack.row = vi.
         vi = vi + 1.
 
   if last-of(ttStack.stack) then vi = 1.       
   
end.
/*
[Z] [M] [P]
[N] [C]
[D]    
*/  
define buffer b for ttStack.
virow = 0.
define variable viHighFromStack as integer no-undo.
message "k"
  view-as alert-box.
for each ttMove by ttMove.id : 
  
  /* aantal in de from stack */
  loophigh: 
  for each ttstack where ttStack.stack = ttmove.fromStack by ttstack.row descending : 
    assign viHighFromStack = ttstack.row.
    leave loophigh.
  end.
  
  do vi = ttMove.qty to 1 by -1:
    
    /* find the item to move */ 
    loopMoveItem:
    for each ttStack where ttStack.Stack = ttmove.fromStack 
                       and ttStack.row   = viHighFromStack - vi + 1:
      
      /* find correct row */
      loopcorrectRow:
      for each b where b.Stack = ttmove.toStack by b.row descending:
        viRow = b.row + 1.
        leave loopcorrectRow.
      end. 
        
      /* set stack & row */
      assign ttStack.stack = ttmove.toStack
             ttStack.row   = virow.
      leave loopMoveItem.
    end. 
  end.
end.
define variable vcResult as character no-undo.
for each ttStack break by ttStack.Stack 
                       by ttStack.row descending : 
                         
  if first-of(ttStack.stack) then 
    vcResult = vcResult + ttStack.Crate.
end.

message trim(vcResult) view-as alert-box.
  