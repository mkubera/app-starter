module Components.Form.Input exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input


type Field
    = Text
    | Email
    | NewPassword


type alias Opts msg =
    { field : Field

    -- { label : List (Attribute msg) -> Element msg -> Input.Label msg
    -- , labelAttributes : List (Attribute msg)
    , labelText : String

    -- , placeholder : Maybe (Input.Placeholder msg)
    , value : String
    , attributes : List (Attribute msg)
    , msg : String -> msg
    }


{-| Create an input element for a form.

    init
        { label = Input.labelAbove
        , labelAttributes = []
        , labelText = "username"
        , placeholder = Just (Input.placeholder [] (text "Winston Smith"))
        , value = ""
        , field = Text
        , attributes = []
        , msg = Save
        }

-}
init : Opts msg -> Element msg
init opts =
    let
        tempOpts =
            { label = Input.labelAbove
            , labelAttributes = []
            , value = ""
            , placeholder = Nothing
            }

        defaultAttributes =
            [ height (px 44)
            , paddingXY 10 10
            , Background.color (rgba255 0 0 0 0)
            , Font.color (rgb255 0 0 0)
            , Font.size 18
            , Border.rounded 5
            ]

        attributes =
            defaultAttributes ++ opts.attributes

        options =
            { onChange = opts.msg
            , text = opts.value
            , placeholder = tempOpts.placeholder
            , label =
                tempOpts.label
                    tempOpts.labelAttributes
                    (text opts.labelText)
            }

        optionsNewPassword =
            { onChange = opts.msg
            , text = opts.value
            , placeholder = tempOpts.placeholder
            , label =
                tempOpts.label
                    tempOpts.labelAttributes
                    (text opts.labelText)
            , show = False
            }
    in
    case opts.field of
        Text ->
            Input.text attributes options

        Email ->
            Input.email attributes options

        NewPassword ->
            Input.newPassword attributes optionsNewPassword
