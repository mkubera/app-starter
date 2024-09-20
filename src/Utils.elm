module Utils exposing (..)

import Element exposing (..)


paddingBottom : Int -> Attribute msg
paddingBottom n =
    paddingEach
        { top = 0, right = 0, bottom = n, left = 0 }
