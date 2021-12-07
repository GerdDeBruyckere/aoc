
/*------------------------------------------------------------------------
    File        : solution.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : gdb
    Created     : Sat Dec 04 08:22:19 CET 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

using OpenEdge.Core.Collections.*.
using day04.BingoCard from propath.

block-level on error undo, throw.

define variable voListBingoCards    as List      no-undo.
define variable voBingoCard         as BingoCard no-undo.
define variable vcWinningNumbers    as character no-undo.
define variable vcBingoCard         as character no-undo.
define variable vi                  as integer   no-undo.
define variable viTheNumber         as integer   no-undo.
define variable vc1                 as character no-undo.
define variable vc2                 as character no-undo.
define variable vc3                 as character no-undo.
define variable vc4                 as character no-undo.
define variable vc5                 as character no-undo.
define variable voBingoCardIterator as IIterator no-undo.
define variable viCalcBingocard     as integer   no-undo.
define variable viSize              as integer   no-undo.

// create a list of bingo cards
voListBingoCards = new List().

/* read the input */
// winning numbers
input from value(search("day04/input_winning_numbers.txt")).
  import unformatted vcWinningNumbers.
input close.

assign
  vcWinningNumbers = replace(vcWinningNumbers," ":u, ",":u).

// bingo cards
input from value(search("day04/input_bingocards.txt")).
repeat : 
  import vc1 vc2 vc3 vc4 vc5.

  assign vcBingoCard = vcBingoCard + ",":u + vc1 + ",":u + vc2 + ",":u + vc3 + ",":u + vc4 + ",":u + vc5 
         vcBingoCard = trim(vcBingoCard,",":u).
  
  if num-entries(trim(vcBingoCard,",":u)) = 25 then 
  do:
    // create bingocard
    voBingoCard = new BingoCard(5, vcBingoCard).
    voListBingoCards:Add(voBingoCard).
    
    vcBingoCard = "":u.
    import  vc1 . /* om de lege lijn te skippen */
  end.
end.
  
input close.

// start the game

viSize = voListBingoCards:Size.

do vi = 1 to num-entries(vcWinningNumbers) : 
  
  viTheNumber = int(entry(vi, vcWinningNumbers)).

  voBingoCardIterator = voListBingoCards:Iterator().
  
  do while voBingoCardIterator:HasNext() : 
    
    voBingoCard = cast(voBingoCardIterator:Next(), BingoCard).
    
    if valid-object(voBingoCard) then do:
      
      voBingoCard:SetWinningNumber(viTheNumber).
      if voBingoCard:isCardWinning() then do:
       
        viCalcBingocard = voBingoCard:CalculateWinningCard().
        
        if voListBingoCards:Size = viSize 
        then 
           message "First winning bingo card " skip 
                 "***********************" skip
                "The number  : " viTheNumber skip        
                "Winning bingocard : " skip
                voBingoCard:ToString() skip
                "Calc bingocard : " viCalcBingocard skip
                "Result : " viTheNumber * viCalcBingocard
              view-as alert-box.
          
        
        
        voListBingoCards:Remove(voBingoCard).
      end.
    end.
  end.
end.

/* 
First winning bingo card 
***********************
The number  :  74 
Winning bingocard :  
-1  -1   5  69  -1
-1  60  40  73   6
-1  54  67  32  38
-1  62  17  51  86
-1  88  99   3  16 
Calc bingocard :  866 
Result :  64084
 */

