module Components.Form.SubmitBtn exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FlatColors.TurkishPalette as Colors


type alias Opts msg =
    { labelText : String
    , attributes : List (Attribute msg)
    , maybeMsg : Maybe msg
    , isSubmitting : Bool
    }


{-| Create an input button for form submission.

    init
        { labelText = "Submit"
        , attributes = []
        , maybeMsg = Nothing
        , isSubmitting = False
        }

-}
init : Opts msg -> Element msg
init { labelText, attributes, maybeMsg, isSubmitting } =
    let
        defaultAttributes : List (Attribute msg)
        defaultAttributes =
            [ height (px 44)
            , paddingXY 10 0
            , Background.color Colors.balticSea
            , Font.color Colors.dornYellow
            , centerX
            , Border.rounded 5
            , pointer
            ]

        allAttributes : List (Attribute msg)
        allAttributes =
            if isSubmitting then
                defaultAttributes ++ attributes ++ [ alpha 0.5 ]

            else
                defaultAttributes ++ attributes

        currentMsg : Maybe msg
        currentMsg =
            if isSubmitting then
                Nothing

            else
                maybeMsg
    in
    Input.button allAttributes
        { onPress = currentMsg
        , label = text labelText
        }
