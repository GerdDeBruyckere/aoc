
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
// (1 for Rock, 2 for Paper, and 3 for Scissors) 
// plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won)
// X for Rock, Y for Paper, and Z for Scissors
// A for Rock, B for Paper, and C for Scissors


/* ***************************  Main Block  *************************** */

/* part 1 */ 

define variable vcOpponent as character no-undo.
define variable vcYou as character no-undo.
define variable viTotal as integer no-undo.

// read the file 
input from value("2022/day02/input.txt":u).

message "kk"
  view-as alert-box.

repeat : 
  import vcOpponent vcYou.
  
/* begin part 1   
  case vcYou : 
    when "X":u then viTotal = viTotal + 1. /* rock */ 
    when "Y":u then viTotal = viTotal + 2. /* paper */ 
    when "Z":u then viTotal = viTotal + 3. /* scissors */
  end case.

// Rock (X) wins from scissors (C), loses from paper (B), draw when rock (A)
  if vcYou = "X":u then do:
    case vcOpponent :
      when "A":u then viTotal = viTotal + 3.
      when "B":u then viTotal = viTotal + 0.
      when "C":u then viTotal = viTotal + 6. 
    end case.
  end.
  
// Paper (Y) wins from rock (A), loses from scissors (C), draw when paper (B)
  if vcYou = "Y":u then do:
    case vcOpponent :
      when "A":u then viTotal = viTotal + 6.
      when "B":u then viTotal = viTotal + 3.
      when "C":u then viTotal = viTotal + 0. 
    end case.
  end.
// SCissors (Z) wins from paper (B), loses from rock (A), draw when scissors (C)
  if vcYou = "Z":u then do:
    case vcOpponent :
      when "A":u then viTotal = viTotal + 0.
      when "B":u then viTotal = viTotal + 6.
      when "C":u then viTotal = viTotal + 3. 
    end case.
  end.
  
   end part 1 */
  
  // begin part 2 
  // X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win
  case vcYou : 
    when "X" then do:  /* lose */ 
      case vcOpponent :
        when "A" /* rock */     then viTotal = viTotal + 3. /* scissors */
        when "B" /* paper */    then viTotal = viTotal + 1. /* rock */
        when "C" /* scissors */ then viTotal = viTotal + 2. /* paper */  
      end case.
    end.
    when "Y" then do:  /* draw */ 
      case vcOpponent :
        when "A" /* rock */     then viTotal = viTotal + 1. /* rock */
        when "B" /* paper */    then viTotal = viTotal + 2. /* paper */
        when "C" /* scissors */ then viTotal = viTotal + 3. /* scissors */  
      end case.
      viTotal = viTotal + 3.
    end.
    when "Z" then do:  /* win */ 
      case vcOpponent :
        when "A" /* rock */     then viTotal = viTotal + 2. /* paper */
        when "B" /* paper */    then viTotal = viTotal + 3. /* scissors */
        when "C" /* scissors */ then viTotal = viTotal + 1. /* rock */  
      end case.
      viTotal = viTotal + 6.
    end.
  end case.
  
  //vcValue = "":u.
end.

input close.

 message viTotal
   view-as alert-box.