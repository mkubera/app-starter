module Components.Basket exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FlatColors.TurkishPalette as Colors
import Route.Path
import Shared.Model


viewTrail : { basketStep : Int } -> Element msg
viewTrail { basketStep } =
    let
        columns =
            [ 1, 2, 3 ]
    in
    row [] <|
        (columns
            |> List.map
                (\columnNumber ->
                    let
                        highlightingAttributes =
                            [ Font.bold
                            ]

                        attributes =
                            if basketStep == columnNumber then
                                highlightingAttributes

                            else
                                []

                        headerText =
                            case columnNumber of
                                1 ->
                                    "Choose"

                                2 ->
                                    "Review Order"

                                _ ->
                                    "Payment"
                    in
                    column attributes
                        [ row [ centerX ] [ text (String.fromInt columnNumber) ]
                        , row [] [ text headerText ]
                        ]
                )
            |> List.intersperse (column [ padding 20 ] [ text "------" ])
        )


viewBasketProceedBtn : { onPress : Maybe msg, labelText : String } -> Element msg
viewBasketProceedBtn { onPress, labelText } =
    row
        [ centerX
        , Background.color Colors.radiantYellow
        , Font.size 18
        , padding 10
        , Border.rounded 5
        ]
        [ Input.button []
            { onPress = onPress, label = text labelText }
        ]


viewBasketBackBtn : { to : Route.Path.Path } -> Element msg
viewBasketBackBtn { to } =
    link
        [ Background.color (rgb255 188 188 188)
        , padding 10
        , Border.rounded 5
        ]
        { url = Route.Path.toString to
        , label = text "back"
        }


viewBasketTotal : List Shared.Model.UserItem -> Element msg
viewBasketTotal userBasket =
    let
        sumOfItems : Float
        sumOfItems =
            List.foldl (\{ qty, price } acc -> acc + (toFloat qty * price)) 0 userBasket

        totalTxt : String
        totalTxt =
            String.fromFloat sumOfItems
    in
    row
        [ centerX
        , Font.color Colors.lightIndigo
        , alpha 0.8
        , Font.italic
        , Font.size 18
        , Border.width 1
        , Border.solid
        , Border.color Colors.lightIndigo
        , padding 10
        ]
        [ text <| "€" ++ totalTxt
        ]
