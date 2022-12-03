
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

/* part 1 */ 

define variable vcRucksack as character no-undo.
define variable viID       as integer no-undo.
define variable viLength   as integer no-undo.
define variable viMiddle   as integer no-undo.
define variable vcLower    as character case-sensitive initial "abcdefghijklmnopqrstuvwxyz":u no-undo.
define variable vcCaps     as character case-sensitive initial "ABCDEFGHIJKLMNOPQRSTUVWXYZ":u no-undo.

define temp-table ttRucksack no-undo
  field id           as integer 
  field contents     as character format "x(75)":u
  field compartment1 as character format "x(35)":u case-sensitive
  field compartment2 as character format "x(35)":u case-sensitive 
  field commonItem   as character
  field priority     as integer
  . 

// read the file 
input from value("2022/day03/input.txt":u).


repeat :
  
  create ttRucksack.
  assign ttRucksack.id = viId + 1
         viId          = viId + 1. 
  import ttRucksack.contents.
  
  assign viLength = length(ttRucksack.contents)
         viMiddle = viLength / 2.
  
  assign ttRucksack.compartment1 = substring(ttRucksack.contents, 1 , viMiddle) 
         ttRucksack.compartment2 = substring(ttRucksack.contents, viMiddle + 1).
  
end.

input close.

define variable vi     as integer   no-undo.
define variable vcItem as character no-undo.


 for each ttRucksack : 
  
   loopCompartment: 
   do vi = 1 to length(ttRucksack.compartment1) : 
     
     vcItem = substring(ttRucksack.compartment1, vi, 1).
     
     if index(ttRucksack.compartment2, vcItem) > 0 then 
     do:
       assign ttRucksack.commonItem = vcItem.
       
       if index(vcLower, ttRucksack.commonItem) > 0 then ttRucksack.priority = index(vcLower, ttRucksack.commonItem).
       if index(vcCaps, ttRucksack.commonItem)  > 0 then ttRucksack.priority = index(vcCaps, ttRucksack.commonItem) + 26.
       
       
       leave loopCompartment.
     end.
     
   end.
   //display compartment1 compartment2 commonItem priority.
   
 end.  
 
 define variable vitotal as integer no-undo.
 
 for each ttRucksack : 
   viTotal = viTotal + ttRucksack.priority.
 end.
 
 message viTotal view-as alert-box.