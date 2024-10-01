module Components.Nav.Categories exposing (..)

import Element exposing (..)


view categories =
    row [] <|
        List.map
            (\c ->
                column []
                    [ text c.name
                    ]
            )
            categories
