::
::  A library for producing aligned text and boxed text.
::
|%
::
++  align
  |=  [mode=?(%left %center %right) width=@ud text=tape]
  ^-  tape
  ?>  (gte width (lent text))
  ::
  !!
::
++  box-text
  |=  [gap=@ud text=tape]
  ^-  wall
  ::
  !!
::
++  double-box-text
  |=  [gap=@ud text=tape]
  ^-  wall
  ::
  !!

++  symbol-box-text
  |=  [symbol=@t gap=@ud text=tape]
  ^-  wall
  ::
  !!
--
