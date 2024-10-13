module Components.Page.Header exposing (..)

import Design.Typography
import Element exposing (..)
import Element.Font as Font


view : String -> Element msg
view txt =
    row
        [ Design.Typography.sizes.page.header
        , Font.bold
        , Font.letterSpacing 0.44
        , centerX
        , centerY
        ]
        [ text txt ]
