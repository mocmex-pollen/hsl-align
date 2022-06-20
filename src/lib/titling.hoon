::
::  A library for producing aligned text and boxed text.
::
|%
::  +align: produce a tape padded with aces to width characters where
::  the given text is aligned within according to mode
::
++  align
  |=  [mode=?(%left %center %right) width=@ud text=tape]
  ^-  tape
  ?>  (gte width (lent text))
  ::
  =/  aces-n=@ud  (sub width (lent text))
  =/  ace=@t  ' '
  ?-  mode
    %left    (weld text (reap aces-n ace))
    ::
    %center
      =/  [quot=@ud rem=@ud]  (dvr aces-n 2)
      =/  left-n  quot
      =/  right-n  (add quot rem)
      (weld (runt [left-n ace] text) (reap right-n ace))
    ::
    %right   (runt [aces-n ace] text)
  ==
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
