module Layouts.User exposing (Model, Msg, Props, layout)

import Components.NavLink
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Input exposing (button)
import Layout exposing (Layout)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


type alias Props =
    {}


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout props shared route =
    Layout.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



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
    = Logout


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        Logout ->
            ( model
            , Effect.logout
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
                |> Element.map toContentMsg
            , row [ centerX, centerY ] [ content.element ]
            ]
    }


viewNavbar : Model -> Element Msg
viewNavbar model =
    row
        [ spaceEvenly
        , Background.color (rgb255 150 150 150)
        , width fill
        , padding 20
        ]
        [ row [] [ text "App Starter logo" ]
        , row [ spacing 20 ]
            [ Components.NavLink.view Route.Path.User_Profile
            , button [] { onPress = Just Logout, label = text "Logout" }
            ]
        ]
