 
 /*------------------------------------------------------------------------
    File        : Digit
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : gdb
    Created     : Wed Dec 08 10:19:49 CET 2021
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

block-level on error undo, throw.

class day08.Digit: 
  
  

  define public property U  as character no-undo get. set. 
  define public property LU as character no-undo get. set.
  define public property RU as character no-undo get. set.
  define public property M  as character no-undo get. set.
  define public property LD as character no-undo get. set.
  define public property RD as character no-undo get. set.
  define public property D  as character no-undo get. set.

  /*------------------------------------------------------------------------------
   Purpose: Determine segments
   Notes:
  ------------------------------------------------------------------------------*/

  method public void DetermineSegments(input ipcInput as character):
    
//c = replace("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab", " ", ",").
    
    define variable c       as character no-undo.
    define variable vi      as integer   no-undo.
    define variable vcUP    as character no-undo.
    define variable vcMID   as character no-undo.
    define variable vcDOWN  as character no-undo.
    define variable vcLU    as character no-undo.
    define variable vcLD    as character no-undo.
    define variable vcRU    as character no-undo.
    define variable vcRD    as character no-undo.

    define variable vc9     as character no-undo.
    define variable vc5     as character no-undo.
    define variable vc6     as character no-undo.
    define variable vc3     as character no-undo.
    define variable vcEntry as character no-undo.
    define variable vcChars as character no-undo.
    define variable vj      as integer   no-undo.
    define variable vcInput2 as character no-undo.
    define variable vcInput3 as character no-undo.
    define variable vcInput4 as character no-undo.
    define variable vcInput5 as character no-undo.
    define variable vcInput6 as character no-undo.
    define variable vcInput7 as character no-undo.
    
    // replace the " " in the input string 
    ipcInput = replace(ipcInput, " ":u, ",":u).
    
    // sort by length 
    do vi = 1 to num-entries(ipcInput) : 
      case length(entry(vi,ipcInput)): 
        when 2 then vcInput2 = entry(vi,ipcInput).
        when 3 then vcInput3 = entry(vi,ipcInput).
        when 4 then vcInput4 = entry(vi,ipcInput).
        when 7 then vcInput7 = entry(vi,ipcInput).
        when 5 then vcInput5 = vcInput5 + "," + entry(vi,ipcInput).
        when 6 then vcInput6 = vcInput6 + "," + entry(vi,ipcInput).
      end case.
    end.
    ipcInput = vcInput2 + "," + vcInput3 + "," + vcInput4 + vcInput6  + vcInput5 + "," + vcInput7.

    do vi = 1 to num-entries(ipcInput) : 
      vcEntry = entry(vi,ipcInput).
      /* getal 1 geeft combinatie van letters voor RU en RD */ 
      if length(vcEntry) = 2 then assign vcRU = vcEntry
                                         vcRD = vcEntry.
      /* getal 7 is drie lang en bestaat uit de combo van getal 1 en UP */                                      
      if length(vcEntry) = 3 then assign vcUP = vcEntry.
      
      /* getal 4 is 4 lang en bestaat uit combo van LU,MID,RU,RD (RU en RD hadden we al, dus MID en LU is voorlopig 
         combinatie van de rest */ 
      if length(vcEntry) = 4 then assign vcMID = vcEntry
                                         vcLU  = vcEntry. 
      /* getallen 0,6,9 */ 
      if length(vcEntry) = 6 then assign vc6 = vc6 + ",":u + vcEntry
                                         vc6 = trim(vc6,",":u).
      /* getallen 2,3,5 */                                       
      if length(vcEntry) = 5 then assign vc5 = vc5 + ",":u + vcEntry
                                         vc5 = trim(vc5,",":u).
      /* getal 8 , steken we in LD omdat die op het einde bepaald wordt  */                                           
      if length(vcEntry) = 7 then assign vcLD = vcEntry.                           
    end.
    
    // determinatie UP : 7 = UP + RU + RD
    do vi = 1 to length(vcRU) : 
      vcUP = replace(vcUP, substring(vcRU,vi,1),"":u).  
    end.
    // weghalen van de letters van 1 uit de 4 
    do vi = 1 to length(vcRU) : 
      vcMid = replace(vcMid,substring(vcRU,vi,1),"":u).
    end.
    vclu = vcmid.
    // determinatie DOWN : 9 = UP, RU, RD, LU, MID, D waarbij enkel D niet gekend is 
    // 9 is 6 cijfers lang 
    vc9 = vcUP + vcMID + vcRU.
    do vi = 1 to length(vc9) :
      do vj = 1 to num-entries(vc6) :
        entry(vj,vc6) = replace(entry(vj,vc6),substring(vc9,vi,1),"":u).
      end.   
    end.
    do vi = 1 to num-entries(vc6) : 
      if length(entry(vi,vc6)) = 1 then do:
        vcDOWN = entry(vi,vc6).
        leave.
      end.
    end.
    // determinatie MID : 3 = UP,DOWN, RU,RD , MID waarbij enkel MID niet gekend is 
    vcChars = vc5.
    vc3 = vcUP + vcDOWN + vcRU.
    do vi = 1 to length(vc3) :
      do vj = 1 to num-entries(vcChars) :
        entry(vj,vcChars) = replace(entry(vj,vcChars),substring(vc3,vi,1),"":u).
      end.   
    end.
    do vi = 1 to num-entries(vcChars) : 
      if length(entry(vi,vcChars)) = 1 then do:
        vcMID = entry(vi,vcChars).
        leave.
      end.
    end.
    // determinatie LU = schrappenv van de MID en RU
    vcLU = replace(vcLU,vcMID,"":u).
    do vi = 1 to num-entries(vcRU):
      vcLU = replace(vcLU,entry(vi,vcRU),"":u).
    end.  
    // determinatie RD = cijfers met length = 5 : 5 = U + MID + LU + DOWN + RD 
    vcChars = vcUP + vcDOWN + vcMID + vcLU.
    do vi = 1 to length(vcChars) :
      do vj = 1 to num-entries(vc5) :
        entry(vj,vc5) = replace(entry(vj,vc5),substring(vcChars,vi,1),"":u).
      end.   
    end.
    do vi = 1 to num-entries(vc5) : 
      if length(entry(vi,vc5)) = 1 then do:
        vcRD = entry(vi,vc5).
        leave.
      end.
    end.
    vcRU = replace(replace(vcRU,vcRD,"":u),",":u,"":u).
    /* LD = som van alles wat we al hebben en die letters schrappen in het enige woord van 7 lang */ 
    vcChars = vcUP + vcDOWN + vcMid + vcLU + vcRD + vcRU.
    do vi = 1 to length(vcChars) :                       
      vcLD = replace(vcLD,substring(vcChars,vi,1),"":u).       
    end.                                                 

    assign
      this-object:U   = vcUp 
      this-object:D   = vcDown 
      this-object:M   = vcMid 
      this-object:LU  = vcLU 
      this-object:LD  = vcLD 
      this-object:RU  = vcRU 
      this-object:RD  = vcRD.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public character GetNumber( input viLength as integer , input ipcDigit as character ):
        
    define variable vi       as integer   no-undo.
    define variable vcNumber as character initial "0000000":u no-undo. /* change each 0 to 1 when in order U,LU,RU,M,LD,RD,D is set */ 
    
    do vi = 1 to length(ipcDigit) :
      case substring(ipcDigit, vi, 1):
        when this-object:U then 
          substring(vcNumber,1,1) = "1":u.
        when this-object:LU then 
          substring(vcNumber,2,1) = "1":u.
        when this-object:RU then 
          substring(vcNumber,3,1) = "1":u.
        when this-object:M then 
          substring(vcNumber,4,1) = "1":u.
        when this-object:LD then 
          substring(vcNumber,5,1) = "1":u. 
        when this-object:RD then 
          substring(vcNumber,6,1) = "1":u.
        when this-object:D then 
          substring(vcNumber,7,1) = "1":u.
      end case.     
    end.
    
    case vcNumber : 
      when "1110111" then return "0".
      when "1011101" then return "2".
      when "1011011" then return "3".
      when "1101011" then return "5".
      when "1101111" then return "6".
      when "1111011" then return "9".
    end case.
    
    return "".

  end method.

end class.