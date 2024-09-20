module Components.Form exposing (..)

import Browser exposing (element)
import Element exposing (..)
import Element.Font as Font
import FlatColors.TurkishPalette as Colors
import Html


type alias Opts msg =
    { element : List (Attribute msg) -> List (Element msg) -> Element msg
    , attributes : List (Attribute msg)
    , children : List (Element msg)
    }


{-| Create a form.

    init
        { element = column
        , attributes = []
        , children = []
        }

-}
init : Opts msg -> Element msg
init opts =
    el [] <|
        html <|
            Html.form []
                [ layoutWith { options = [ noStaticStyleSheet ] } [] <|
                    opts.element opts.attributes opts.children
                ]


viewNotification : Result String String -> Element msg
viewNotification fieldNotification =
    case fieldNotification of
        Ok txt ->
            row [ Font.color Colors.weirdGreen ] [ text txt ]

        Err error ->
            row [ Font.color Colors.redOrange ] [ text error ]
