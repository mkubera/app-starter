module Components.Page.Header exposing (..)

import Element exposing (..)
import Element.Font as Font


view txt =
    row
        [ Font.size 24, centerX, paddingXY 0 0 ]
        [ text txt ]
