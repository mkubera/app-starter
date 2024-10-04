module Components.Items exposing (..)

import Components.Link
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FlatColors.TurkishPalette as Colors
import Route.Path
import Shared.Model


view : { items : List Shared.Model.Item } -> Element msg
view { items } =
    wrappedRow
        [ width (fill |> maximum 620)
        , centerX
        , centerY
        , spacingXY 10 10
        ]
    <|
        List.map
            (\item ->
                Components.Link.view
                    { routePath =
                        Route.Path.Items_Id_ { id = item.id |> String.fromInt }
                    , label =
                        column
                            [ width (px 200)
                            , height (px 200)
                            , Border.color Colors.balticSea
                            , Border.solid
                            , Border.width 2
                            , Border.rounded 5
                            , spacing 5
                            , padding 20
                            , pointer
                            , mouseOver
                                [ alpha 0.4
                                , Border.color Colors.radiantYellow
                                , Font.color Colors.radiantYellow
                                ]
                            ]
                            [ paragraph
                                [ centerX
                                , centerY
                                , Font.size 20
                                , Font.bold
                                , Font.center
                                , width fill
                                ]
                                [ text item.name ]
                            , row
                                [ centerX
                                , centerY
                                , Font.size 18
                                ]
                                [ text ("€" ++ String.fromFloat item.price) ]

                            -- , row
                            --     [ centerX
                            --     , centerY
                            --     , Font.size 14
                            --     ]
                            --     [ text (String.fromInt item.qty ++ " left") ]
                            ]
                    }
            )
            items
