module Pages.Home_ exposing (page)

import Element exposing (..)
import View exposing (View)


page : View msg
page =
    { title = "Homepage"
    , attributes = []
    , element = column [] [ text "Hello, world!" ]
    }
