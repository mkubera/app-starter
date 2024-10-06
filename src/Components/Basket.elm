module Components.Basket exposing (..)

import Design.Colors
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Route.Path
import Shared.Model
import Utils


viewTrail : { basketStep : Int } -> Element msg
viewTrail { basketStep } =
    let
        columns =
            [ 1, 2, 3 ]
    in
    row [ height (px 50) ] <|
        (columns
            |> List.map
                (\columnNumber ->
                    let
                        defaultAttributes =
                            [ spacing 5 ]

                        attributes =
                            if basketStep == columnNumber then
                                defaultAttributes ++ [ Font.bold ]

                            else
                                defaultAttributes ++ [ alpha 0.33 ]

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
                        [ row
                            [ centerX
                            , Border.color (Design.Colors.primary |> Design.Colors.setAlpha 0.5)
                            , Border.solid
                            , Border.width 1
                            , Border.rounded 100
                            , padding 10
                            , width (px 40)
                            , height (px 40)
                            ]
                            [ el [ centerX ] <| text (String.fromInt columnNumber) ]
                        , row [] [ text headerText ]
                        ]
                )
            |> List.intersperse
                (column
                    [ width (px 100)
                    ]
                    [ row
                        [ height (px 1)
                        , Background.color Design.Colors.primary
                        , paddingXY 30 0
                        , alpha 0.33
                        , centerX
                        ]
                        []
                    ]
                )
        )


viewBasketProceedBtn : { onPress : Maybe msg, labelText : String } -> Element msg
viewBasketProceedBtn { onPress, labelText } =
    row
        [ centerX
        , Background.color Design.Colors.secondary
        , Font.size 18
        , Font.bold
        , padding 10
        , Border.rounded 5
        , mouseOver
            [ Background.color (Design.Colors.secondary |> Design.Colors.setAlpha 0.5)
            ]
        ]
        [ Input.button []
            { onPress = onPress, label = text labelText }
        ]


viewBasketBackBtn : { to : Route.Path.Path } -> Element msg
viewBasketBackBtn { to } =
    link
        [ Background.color (Design.Colors.black |> Design.Colors.setAlpha 0.33)
        , Font.size 18
        , padding 10
        , Border.rounded 5
        ]
        { url = Route.Path.toString to
        , label = text "🔙"
        }


viewBasketTotal : List Shared.Model.UserItem -> Element msg
viewBasketTotal userBasket =
    let
        sumOfItems : Float
        sumOfItems =
            List.foldl (\{ qty, price } acc -> acc + (toFloat qty * price)) 0 userBasket
    in
    column
        [ centerX
        , Font.color Design.Colors.ternary
        , alpha 0.8
        , Font.italic
        , Border.width 1
        , Border.solid
        , Border.color Design.Colors.ternary
        , padding 10
        , spacing 5
        ]
        [ row [ centerX, Font.size 14 ] [ text "total" ]
        , row [ centerX, Font.size 18 ] [ text <| "€" ++ Utils.setDecimal sumOfItems 2 ]
        ]
