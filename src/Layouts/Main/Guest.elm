module Layouts.Main.Guest exposing (Model, Msg, Props, layout)

import Components.Nav.CategoryBtns
import Components.NavLink
import Design.Colors
import Dict
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import FlatColors.TurkishPalette as Colors
import Layout exposing (Layout)
import Layouts.Main
import Route exposing (Route)
import Route.Path
import Shared
import Shared.Model
import View exposing (View)


type alias Props =
    {}


layout :
    Props
    -> Shared.Model
    -> Route ()
    -> Layout Layouts.Main.Props Model Msg contentMsg
layout props sharedModel route =
    let
        _ =
            Debug.log "Guest Route" route
    in
    Layout.new
        { init = init
        , update = update
        , view = view sharedModel
        , subscriptions = subscriptions
        }
        |> Layout.withParentProps {}



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model
            , Effect.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model.Model -> { toContentMsg : Msg -> contentMsg, content : View contentMsg, model : Model } -> View contentMsg
view sharedModel { toContentMsg, model, content } =
    { title = content.title ++ " | App Starter"
    , attributes = []
    , element =
        column [ width fill, height fill ]
            [ viewNavbar sharedModel
            , row [ centerX, centerY ] [ content.element ]
            ]
    }


viewNavbar : Shared.Model.Model -> Element msg
viewNavbar sharedModel =
    row
        [ spaceEvenly
        , Background.color (Design.Colors.secondary |> Design.Colors.setAlpha 1)
        , width fill
        , padding 20
        ]
        [ row [] [ Components.NavLink.view Route.Path.Home_ ]
        , row [ spacing 30 ]
            [ Components.Nav.CategoryBtns.view sharedModel.categories
            , Components.NavLink.view Route.Path.Basket
            , row [ spacing 5 ]
                [ Components.NavLink.view Route.Path.Signup
                , text "/"
                , Components.NavLink.view Route.Path.Login
                ]
            ]
        ]
