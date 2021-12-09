
/*------------------------------------------------------------------------
    File        : solution.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : gdb
    Created     : Thu Dec 09 08:51:55 CET 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

/*

Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.

Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.

The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the heightmap is therefore 15.
  
  */
define variable vcInput  as character no-undo.
define variable vi       as integer   initial 0 no-undo.
define variable vj       as integer   no-undo.  

define temp-table ttRaster no-undo
  field X  as integer
  field Y  as integer
  field Val as integer 
  index PK is primary unique 
  X
  Y
  .

input from value(search("day09/input.txt")).
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

temp-table ttRaster:write-json("file", "c:\temp\ttRAster.json").

// num rows
define buffer b for ttRaster.

define variable viValue as integer no-undo.
define variable viUnder as integer no-undo.
define variable viAbove as integer no-undo.
define variable viLeft as integer no-undo.
define variable viRight as integer no-undo.
define variable viSom as integer no-undo.

/*for each ttRaster where ttRaster.Y = 2  :*/
/*  display X val.                         */
/*end.                                     */


for each ttRaster by ttRaster.Y
                  by ttRaster.X:
  
     viValue = ttRaster.Val.
  
  
     /* above */ 
     find b no-lock where b.X = ttRaster.X and b.Y = ttRaster.Y - 1 no-error.
     viAbove = if available(b) then b.Val else 999999.
     
     /* under */ 
     find b no-lock where b.X = ttRaster.X and b.Y = ttRaster.Y + 1 no-error.
     viUnder = if available(b) then b.Val else 999999.
     
     /* left */ 
     find b no-lock where b.X = ttRaster.X - 1 and b.Y = ttRaster.Y no-error.
     viLeft = if available(b) then b.Val else 999999.
     
     /* right */ 
     find b no-lock where b.X = ttRaster.X + 1 and b.Y = ttRaster.Y no-error.
     viRight = if available(b) then b.Val else 999999.
     
     
     if viValue < viUnder 
       and viValue < viRight
       and viValue < viAbove
       and viValue < viLeft
       then viSom = viSom  + viValue + 1.
     
/*     message "(" ttRaster.X "," ttRaster.Y ")"                 */
/*       viAbove skip viLeft " " viValue " " viRight skip viAbove*/
/*     skip viSom                                                */
/*     view-as alert-box.                                        */
/*                                                               */
  
end.

message viSom
view-as alert-box.





























  
