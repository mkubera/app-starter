module Components.NavLink exposing (..)

import Element exposing (..)
import Element.Events as Events
import Element.Font as Font
import FlatColors.TurkishPalette as Colors
import Route.Path exposing (Path(..))


view : Path -> Element msg
view routePath =
    let
        defaultAttributes : List (Attribute msg)
        defaultAttributes =
            [ mouseOver [ alpha 0.5 ]
            ]
    in
    case routePath of
        Home_ ->
            link defaultAttributes
                { url = Route.Path.toString Route.Path.Home_
                , label = text "App Starter logo"
                }

        Items ->
            link defaultAttributes
                { url = Route.Path.toString Route.Path.Items
                , label = text "Items"
                }

        Signup ->
            link defaultAttributes
                { url = Route.Path.toString Route.Path.Signup
                , label = text "Signup"
                }

        Login ->
            link defaultAttributes
                { url = Route.Path.toString Route.Path.Login
                , label = text "Login"
                }

        User_Profile ->
            link defaultAttributes
                { url = Route.Path.toString Route.Path.User_Profile
                , label = text "Profile"
                }

        _ ->
            none
