module Layouts.Guest exposing (Model, Msg, Props, layout)

import Components.NavLink
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Layout exposing (Layout)
import Layouts.Main
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


type alias Props =
    {}


layout :
    Props
    -> Shared.Model
    -> Route ()
    -> Layout () Model Msg contentMsg



-- -> Layout Layouts.Main.Props Model Msg contentMsg


layout props sharedModel route =
    Layout.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- |> Layout.withParentProps {}
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


view : { toContentMsg : Msg -> contentMsg, content : View contentMsg, model : Model } -> View contentMsg
view { toContentMsg, model, content } =
    { title = content.title ++ " | App Starter"
    , attributes = []
    , element =
        column [ width fill, height fill ]
            [ viewNavbar model
            , row [ centerX, centerY ] [ content.element ]
            ]
    }


viewNavbar : Model -> Element msg
viewNavbar model =
    row
        [ spaceEvenly
        , Background.color (rgb255 150 150 150)
        , width fill
        , padding 20
        ]
        [ row [] [ text "App Starter logo" ]
        , row [ spacing 20 ]
            [ Components.NavLink.view Route.Path.Home_
            , Components.NavLink.view Route.Path.Signup
            , Components.NavLink.view Route.Path.Login
            ]
        ]
