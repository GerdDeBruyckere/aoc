
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


/* ***************************  Main Block  *************************** */
input from value(search("day10/input.txt")).

define variable vi                         as integer   no-undo.
define variable vcClosingChars             as character initial "},),>,]" no-undo.
define variable vcOpeningChars             as character initial "~{,(,<,[" no-undo.
define variable vcCorrupt                  as character no-undo.
define variable vcCorrespondingOpeningChar as character no-undo.
define variable viSom                      as integer   no-undo.

 
define temp-table ttLine no-undo
  field Code      as character
  field isCorrupt as logical
  field ClosingChars as character
  field score as int64
  .

repeat : 
  create ttLine.
  import unformatted ttLine.Code.
 end. 
input close.

/* get rid of the incomplete, uneaqual number of closing and opening chars  */ 
for each ttLine :
  vcCorrupt = "":u.
  #CodeLoop:
  do vi = 1 to length(ttLine.Code):
    vcCorrupt = vcCorrupt + substring(ttLine.Code, vi, 1).
    if lookup(substring(ttLine.Code, vi, 1) , vcClosingChars) > 0 then do:
      case substring(ttLine.Code, vi, 1) : 
        when ")":u then vcCorrespondingOpeningChar = "(".
        when ">":u then vcCorrespondingOpeningChar = "<".
        when "}":u then vcCorrespondingOpeningChar = "~{".
        when "]":u then vcCorrespondingOpeningChar = "[".
      end case.
      if vcCorrespondingOpeningChar <> substring(vcCorrupt,length(vcCorrupt) - 1, 1) then 
      do:
        ttLine.isCorrupt = true.
        case substring(ttLine.Code, vi, 1) :
          when ")":u then viSom = viSom + 3.
          when "]":u then viSom = viSOm + 57.
          when "}":u then viSom = viSom + 1197.
          when ">":u then viSom = viSom + 25137.
        end case.
        leave #CodeLoop.
      end.
      else vcCorrupt = replace(vcCorrupt, vcCorrespondingOpeningChar + substring(ttLine.Code, vi, 1) , "":u).
      
    end.         
  end. 
end.  
/* part 1 */   
message "Part 1 : " viSom
  view-as alert-box.


define variable c as character no-undo .
define variable d as character  no-undo.
define variable vlOnlyOpeningChars as logical no-undo.
define variable viNumIncompleteLines as integer no-undo.


for each ttLine :
  c = ttLine.Code.
  if ttLine.isCorrupt = true or ttLine.Code eq "":u then
  do: 
      delete ttLine.
      next.
  end.
  repeatLoop#:
  repeat : 
    d = c.
    assign 
      c = replace(c, "()":u, "":u)
      c = replace(c, "[]":u, "":u)
      c = replace(c, "~{}":u, "":u)
      c = replace(c, "<>":u, "":u).
    
    loop#:  
    do vi = 1 to length(c) : 
      if lookup(substring(c,vi,1), vcClosingChars ) > 0 then leave loop#.
    end. 
    if c = d then leave repeatLoop#.
  end.
  
  do vi =  length(c)  to 1 by -1:
    case substring(c, vi,1) : 
      when "~{" then assign ttLine.ClosingChars = ttLine.ClosingChars + "}":u.
      when "["  then assign ttLine.ClosingChars = ttLine.ClosingChars + "]":u.
      when "<"  then assign ttLine.ClosingChars = ttLine.ClosingChars + ">":u.
      when "("  then assign ttLine.ClosingChars = ttLine.ClosingChars + ")":u.
    end case. 
  end.
  
  do vi = 1 to length(ttLine.ClosingChars) :
    ttLine.score = ttLine.score * 5.
    case substring(ttLine.ClosingChars,vi,1):
      when "}":u then assign ttLine.score = ttLine.score + 3.
      when "]":u then assign ttLine.score = ttLine.score + 2.
      when ">":u then assign ttLine.score = ttLine.score + 4.
      when ")":u then assign ttLine.score = ttLine.score + 1.
    end case.   
  end.
  viNumIncompleteLines = viNumIncompleteLines + 1.
end.
define variable viMiddle as integer no-undo.
define variable viScore as int64 no-undo.
viMiddle  = trunc(viNumIncompleteLines / 2,0) + 1.
vi = 0.
for each ttLine by ttLine.score : 
  vi = vi + 1.
  viscore = ttLine.score.
  if vi = viMiddle then leave.
end.
temp-table ttLine:write-json("file", "c:\temp\ttLine.json").

message "Part 2 : " viscore
view-as alert-box.