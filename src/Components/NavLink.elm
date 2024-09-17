module Components.NavLink exposing (..)

import Element exposing (..)
import Route.Path exposing (Path(..))


view : Path -> Element msg
view routePath =
    case routePath of
        Home_ ->
            link []
                { url = Route.Path.toString Route.Path.Home_
                , label = text "Home"
                }

        Signup ->
            link []
                { url = Route.Path.toString Route.Path.Signup
                , label = text "Signup"
                }

        Login ->
            link []
                { url = Route.Path.toString Route.Path.Login
                , label = text "Login"
                }

        _ ->
            none
