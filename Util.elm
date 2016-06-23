module Util exposing (..)

paddedNumber: Int -> String
paddedNumber num =
  let
      pad = if num < 10 then "0" else ""
  in
     pad ++ toString num
