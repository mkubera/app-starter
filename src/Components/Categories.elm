module Components.Categories exposing (..)

import Components.Items
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FlatColors.TurkishPalette as Colors
import Shared.Model


view :
    { categories : List Shared.Model.Category
    , items : List Shared.Model.Item
    }
    -> Element msg
view { categories, items } =
    column [ padding 50, spacing 50, width fill ] <|
        List.map
            (\category ->
                let
                    itemsOfCategory =
                        List.filter (\item -> item.categoryId == category.id) items
                in
                column [ width fill, spacing 10 ] <|
                    [ el
                        [ padding 2
                        , Font.size 24
                        , Font.bold
                        ]
                      <|
                        text category.name
                    , Components.Items.view { items = itemsOfCategory }
                    ]
            )
            categories
