::
::  A library for turning delimited text into columns of text.
::
/+  titling
::
=<
::
|%
::
++  columnify
  |=  [mode=?(%left %center %right) lines=wall]
  ^-  wall
  ::
  =/  rows=(list wall)  (turn lines parse-row)
  =/  column-widths=(list @ud)  (roll (turn rows |=([r=wall] (turn r lent))) pairwise-max)
  %+  turn
    rows
  |=  [columns=wall]
  ^-  tape
  %-  zing
  |-
  ?~  columns  ~
  ?~  column-widths  !!
  ::  Adding an extra space to each column ensures words are always seperated,
  ::  but this would also add trailing whitespace to the final column in left
  ::  and center alignment modes, so we don't do it then.
  ::
  =/  final-width
  ?:  &(=(~ t.columns) !=(mode %right))
    i.column-widths
  (add 1 i.column-widths)
  ::
  :-  (align:titling mode final-width i.columns) 
  $(columns t.columns, column-widths t.column-widths)
--
::
|%
::  +parse-row: split tape into a list of tapes on the delimiter buc
::
::    Trailing empty columns are discarded.
::
++  parse-row
  |=  [row=tape]
  ^-  wall
  ::
  =/  columns=wall  ~
  |-
  =/  column=tape  ~
  |-
  ?~  row
    (flop (pop-empties (turn [column columns] flop)))
  ?:  =('$' i.row)
    ^$(columns [column columns], row t.row)
  $(column [i.row column], row t.row)
::  +pop-empties: remove all ~ from the front of a list
::
::    Useful to remove empty columns from the end of a row.
::
++  pop-empties
  |=  [columns=wall]
  ^-  wall
  ::
  |-
  ?~  columns
    ~
  ?~  i.columns
    t.columns
  columns
::  +pairwise-max: produce a list of the max value of corresponding elements
::  of two lists
::
::    When the lists have uneven lengths, values from the longer list are
::    taken as the max where the shorter list has no values.
::    ex: (pairwise-max ~[1 2 3] ~[4 1]) -> ~[4 2 3]
::
++  pairwise-max
  |=  [l1=(list @) l2=(list @)]
  ^-  (list @)
  ::
  |-
  ?:  &(=(~ l1) =(~ l2))
    ~
  ?~  l1
    ?~  l2  !!
    [i.l2 $(l2 t.l2)]
  ?~  l2
    ?~  l1  !!
    [i.l1 $(l1 t.l1)]
  [(max i.l1 i.l2) $(l1 t.l1, l2 t.l2)]
--