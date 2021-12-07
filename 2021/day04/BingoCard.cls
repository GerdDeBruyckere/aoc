 
 /*------------------------------------------------------------------------
    File        : BingoCard
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : gdb
    Created     : Sat Dec 04 08:21:49 CET 2021
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

block-level on error undo, throw.

class day04.BingoCard: 
  
  define property ArrayBingoCard as System.Array no-undo
  get.
  set.
  define property ElementsPerDimension as integer no-undo
  get.
  set.
  
  constructor public BingoCard ( input ipiDimension as integer ):
    super ().
    
    this-object:ElementsPerDimension = ipiDimension.
    this-object:ArrayBingoCard = System.Array:CreateInstance(System.Type:GetType("System.Int32"), ipiDimension, ipiDimension).
      
  end constructor.
  
  constructor public BingoCard (input ipiDimension as integer, input ipcValueList as character).
    super ().
  
    this-object:ArrayBingoCard = System.Array:CreateInstance(System.Type:GetType("System.Int32"), ipiDimension, ipiDimension).
    this-object:ElementsPerDimension = ipiDimension.
    this-object:InitializeBingoCard(ipcValueList).
      
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose: Sum of all elements that are not -1
  ------------------------------------------------------------------------------*/

  method public integer CalculateWinningCard(  ):
    
    define variable viSom as integer no-undo.
    define variable vi    as integer no-undo.
    define variable vj    as integer no-undo.
    
    do vi = 0 to this-object:ElementsPerDimension - 1: 
      do vj = 0 to this-object:ElementsPerDimension - 1 : 
        
        if unbox(this-object:ArrayBingoCard:GetValue(vi, vj)) <> - 1 then viSom = viSom + unbox(this-object:ArrayBingoCard:GetValue(vi, vj)). 
        
      end.
    end.
    
    return viSom.

  end method.

  /*------------------------------------------------------------------------------
   Purpose: Intialize the bingo card 
   ------------------------------------------------------------------------------*/

  method public void InitializeBingoCard (ipcValueList  as character):
    
    define variable vi       as integer no-undo.
    define variable viRow    as integer initial 0 no-undo.
    define variable viColumn as integer initial 0 no-undo.
    
    if not valid-object(this-object:ArrayBingoCard) then return.
    
    do vi = 1 to num-entries(ipcValueList) : 
 
      this-object:ArrayBingoCard:SetValue(int(entry(vi,ipcValueList)),  /* value */  
                                          viRow,                        /* row */ 
                                          viColumn                      /* column */   
                                          ).        
      viColumn = viColumn + 1.
      if vi mod this-object:ElementsPerDimension = 0 then assign viRow    = viRow + 1
                                                                 viColumn = 0. 
    end.
    
    return.

  end method.
  
  

  /*------------------------------------------------------------------------------
   Purpose: check if card is winning 
  ------------------------------------------------------------------------------*/

  method public logical isCardWinning(  ):
    
    define variable viSom     as integer no-undo.
    define variable vi as integer no-undo.
    define variable vj as integer no-undo.
    
    /* check rows (0,0) (0,1)  */ 
     do vi = 0 to this-object:ElementsPerDimension - 1 : 
      do vj = 0 to this-object:ElementsPerDimension - 1 :
         viSom = viSom + unbox(this-object:ArrayBingoCard:GetValue(vi, vj)).        
      end.
      if viSom = -5 then return true.
      assign
        viSom = 0.
    end.
    
    /* check columns */ 
    
    do vj = 0 to this-object:ElementsPerDimension - 1 :
      do vi = 0 to this-object:ElementsPerDimension - 1 : 
         viSom = viSom + unbox(this-object:ArrayBingoCard:GetValue(vi, vj)).        
      end.
      if viSom = -5 then return true.
      assign
        viSom = 0.
    end.
    
    
    /* check diagonals */ 
    // upper left corner to lower right bottom
     do vi = 0 to this-object:ElementsPerDimension - 1 :
       viSom = viSom +  unbox(this-object:ArrayBingoCard:GetValue(vi, vi)).       
     end.
     if viSom = -5 then return true.
     assign
       viSom = 0.
    
    // upper right corner to lower left bottom  (0,4) (1,3) (2,2) (3,1), (4,0)
     do vi = 0 to this-object:ElementsPerDimension - 1 :
       do vj = this-object:ElementsPerDimension - 1  to 0 :
         if vi + vj = this-object:ElementsPerDimension - 1 then 
            viSom = viSom +  unbox(this-object:ArrayBingoCard:GetValue(vi, vj)).       
       end.
     end.
     if viSom = -5 then return true.
     assign
       viSom = 0.
    
    return false.
   
    
  end method.

  /*------------------------------------------------------------------------------
   Purpose:  set the winning number to value -1 
  ------------------------------------------------------------------------------*/

  method public void SetWinningNumber( input ipiNumber as integer) :

    define variable vi as integer no-undo.
    define variable vj as integer no-undo.
    
    /* iterate through the card */ 
    do vi = 0 to this-object:ElementsPerDimension - 1 : 
      do vj = 0 to this-object:ElementsPerDimension - 1 : 
        
        if unbox(this-object:ArrayBingoCard:GetValue(vi, vj)) = ipiNumber
        then 
          this-object:ArrayBingoCard:SetValue( -1, vi, vj).
        
      end.
    end.
    
  end method.

/*------------------------------------------------------------------------------
   Purpose:  Give the card back in a raster 
  ------------------------------------------------------------------------------*/
  method override public character ToString(  ):
    
    define variable vcBingoCard as character no-undo.
    define variable vcLine      as character no-undo.
    define variable viRow       as integer   no-undo.
    define variable viColumn    as integer   no-undo.
    
    if not valid-object(this-object:ArrayBingoCard) then return "":u.
    
    do viRow = 0 to this-object:ElementsPerDimension - 1: 
      do viColumn = 0 to this-object:ElementsPerDimension - 1 : 
        vcLine = vcLine + " ":u + string(unbox(this-object:ArrayBingoCard:GetValue(viRow, viColumn)), "->9":u).
      end.
      assign
        vcBingoCard = vcBingoCard + trim(vcLine) + chr(10).
        vcLine      = "":u.
    end. 
    
    return trim(vcBingoCard).

  end method.

end class.






