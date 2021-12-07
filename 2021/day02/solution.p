/* ********************************************************
Advent of code - day 2 
******************************************************** */ 
define variable viHorizontal as integer   no-undo.
define variable viVertical   as integer   no-undo.
define variable viAim        as integer   no-undo.
define variable viDepth      as integer   no-undo.
define variable vcDirection  as character no-undo.
define variable viStep       as integer   no-undo.
define variable viTeller     as integer   initial 0 no-undo.


define temp-table ttInstructions no-undo
  field nr        as integer 
  field direction as character
  field steps     as integer 
  index PK is primary unique 
    nr.

// read the file    
input from value(search("day02/input.txt":u)).

repeat : 

  import vcDirection viStep.

  create ttInstructions.
  assign 
    viteller                 = viteller + 1
    ttInstructions.nr        = viTeller
    ttInstructions.direction = vcDirection
    ttInstructions.steps     = viStep
    .
end.

input close.

//temp-table ttInstructions:write-json("file", "c:\temp\adventcode\day2_instructions.json").

assign 
  viAim   = 0.
  viDepth = 0.


for each ttInstructions
      by ttInstructions.nr :

  case ttInstructions.direction:
    when "forward":u then assign viHorizontal = viHorizontal + ttInstructions.steps
                                 viDepth      = viDepth      + viAim * ttInstructions.steps.
    when "up":u      then assign viVertical   = viVertical   - ttInstructions.steps
                                 viAim        = viAim        - ttInstructions.steps.                             
    when "down":u    then assign viVertical   = viVertical   + ttInstructions.steps
                                 viAim        = viAim        + ttInstructions.steps.
  end case.
end.

message "Horizontal : " viHorizontal skip 
        "Vertical : "   viVertical skip 
        "Horizontal * Vertical : " viHorizontal * viVertical skip  /* 1480518 */
        "Depth : "  viDepth skip
        "Horizontal * Depth : " viHorizontal * viDepth             /* 1282809906 */
  view-as alert-box information buttons ok.
  

  
