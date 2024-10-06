module Components.Link exposing (..)

import Design.Colors
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import FlatColors.TurkishPalette as Colors
import Route.Path
import Element.Border as Border


view : { routePath : Route.Path.Path, label : Element msg } -> Element msg
view { routePath, label } =
    case routePath of
        Route.Path.Home_ ->
            link []
                { url = Route.Path.toString Route.Path.Home_
                , label = text "Back to homepage"
                }

        Route.Path.Items ->
            link
                [ Font.size 14
                , centerX
                , Font.color Design.Colors.secondary
                , Background.color Design.Colors.primary
                , padding 10
                , Border.rounded 5
                ]
                { url = Route.Path.toString Route.Path.Items
                , label = label
                }

        Route.Path.Items_Id_ { id } ->
            link []
                { url = Route.Path.toString (Route.Path.Items_Id_ { id = id })
                , label = label
                }

        _ ->
            none
