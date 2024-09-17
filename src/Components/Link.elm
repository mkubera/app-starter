module Components.Link exposing (..)

import Element exposing (..)
import Route.Path exposing (Path(..))


view : Path -> Element msg
view routePath =
    case routePath of
        Home_ ->
            link []
                { url = Route.Path.toString Route.Path.Home_
                , label = text "Back to homepage"
                }

        _ ->
            none
