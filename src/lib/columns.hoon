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
  =/  max-widths=(list @ud)  (roll (turn rows |=([r=wall] (turn r lent))) pairwise-max)
  %+  turn
    rows
  |=  [columns=wall]
  ^-  tape
  =/  column-widths=(list @ud)  (final-widths (scag (lent columns) max-widths) mode columns)
  %-  zing
  |-
  ?~  columns  ~
  ?~  column-widths  !!
  :-  (align:titling mode i.column-widths i.columns) 
  $(columns t.columns, column-widths t.column-widths)
--
::
|%
::  +final-widths: ensure words in adjacent columns are separated without
::  adding extra leading and trailing whitespaces to rows
::
::    %left - increments of all but the last; the last is the width
::    of the contents of the column
::    %center - increments of all but the first and the last
::    %right - increments of all but the first
::
++  final-widths
  |=  [column-widths=(list @ud) mode=?(%left %center %right) columns=wall]
  ^-  (list @ud)
  ::
  =/  increment  |=(a=@ud +(a))
  ?~  column-widths  ~
  ?-  mode
    %left    (turn-but-tail column-widths increment |=(a=@ud (lent (rear columns))))
    %center  [i.column-widths (turn-but-tail t.column-widths increment |=(a=@ud a))]
    %right   [i.column-widths (turn t.column-widths increment)]
  ==
::  +turn-but-tail: produce a list with a gate applied to each element
::  except the last
::
++  turn-but-tail
  |=  [l=(list @ud) transform=$-(@ud @ud) tail-transform=$-(@ud @ud)]
  ^-  (list @ud)
  ::
  ?~  l  ~
  |-
  ?~  t.l
    ~[(tail-transform i.l)]
  [(transform i.l) $(l t.l)]
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