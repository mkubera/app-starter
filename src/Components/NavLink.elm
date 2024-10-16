module Components.NavLink exposing (..)

import Design.Typography
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

        attributesHome_ =
            defaultAttributes
                ++ [ Design.Typography.fonts.logo
                   , Font.regular
                   , Font.letterSpacing 2
                   ]
    in
    case routePath of
        Home_ ->
            link attributesHome_
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
                , label = text "👤"
                }

        Basket ->
            link defaultAttributes
                { url = Route.Path.toString Route.Path.Basket
                , label = text "🛒"
                }

        _ ->
            none
