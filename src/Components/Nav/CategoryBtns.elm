module Components.Nav.CategoryBtns exposing (..)

import Dict
import Element exposing (..)
import Element.Background as Background
import FlatColors.TurkishPalette as Colors
import Route exposing (Route)
import Route.Path
import Shared.Model


view categories =
    row [ spacing 20 ] <|
        List.map viewBtn categories


viewBtn : Shared.Model.Category -> Element msg
viewBtn category =
    let
        defaultAttributes : List (Attribute msg)
        defaultAttributes =
            [ mouseOver [ alpha 0.5 ]
            ]

        urlWithQueryParams =
            Route.toString
                { path = Route.Path.Items
                , query = Dict.fromList [ ( "categoryId", String.fromInt category.id ) ]
                , hash = Nothing
                }
    in
    link defaultAttributes
        { url = urlWithQueryParams
        , label = text category.name
        }
