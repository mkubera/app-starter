module Components.Items exposing (..)

-- import FlatColors.TurkishPalette as Colors

import Components.Link
import Design.Colors
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
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
                            , height (px 250)
                            , spacing 5
                            ]
                            [ row
                                [ width (px 200)
                                , height (px 200)

                                -- , Border.color Design.Colors.primary
                                -- , Border.solid
                                -- , Border.width 2
                                -- , Border.rounded 25
                                -- , padding 20
                                , spacing 5
                                , pointer
                                , mouseOver
                                    [ alpha 0.8
                                    , Border.color Design.Colors.secondary
                                    , Font.color Design.Colors.secondary
                                    ]
                                ]
                                [ image [ width (px 200) ]
                                    { src = "https://i.discogs.com/NtYmZPWZ21Wz9gVhsQzh8M3lXbvkCO1zKcSPbMW5cdo/rs:fit/g:sm/q:90/h:480/w:480/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTExNTgx/NzE0LTE2NTc0MTY1/OTItMzUxMS5qcGVn.jpeg"
                                    , description = ""
                                    }
                                ]
                            , paragraph
                                [ centerX
                                , centerY
                                , Font.size 20
                                , Font.bold
                                , Font.center
                                ]
                                [ text item.name ]
                            , row
                                [ centerX
                                , centerY
                                , Font.size 18
                                ]
                                [ text ("€" ++ String.fromFloat item.price) ]
                            ]
                    }
            )
            items
