module Design.Colors exposing (..)

import Element exposing (..)
import FlatColors.AmericanPalette as Colors


primary : Color
primary =
    Colors.draculaOrchid


secondary : Color
secondary =
    Colors.brightYarrow


ternary : Color
ternary =
    Colors.exodusFruit


black : Color
black =
    rgb255 0 0 0


white : Color
white =
    rgb255 255 255 255



-- SET


setAlpha : Float -> Color -> Color
setAlpha alpha color =
    let
        deconstructedColor : { red : Float, green : Float, blue : Float, alpha : Float }
        deconstructedColor =
            toRgb color
    in
    { deconstructedColor | alpha = alpha }
        |> fromRgb
