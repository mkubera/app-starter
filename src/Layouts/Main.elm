module Layouts.Main exposing (Model, Msg, Props, layout)

import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import FlatColors.TurkishPalette as Colors
import Layout exposing (Layout)
import Route exposing (Route)
import Shared
import Shared.Model
import View exposing (View)


type alias Props =
    {}


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout props sharedModel route =
    Layout.new
        { init = init
        , update = update
        , view = view sharedModel
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
            [ viewErrorNotification sharedModel.errorNotification
            , text "DEL ME"
            , content.element
            ]
    }


viewErrorNotification : Maybe String -> Element msg
viewErrorNotification mbErrorNotification =
    case mbErrorNotification of
        Just err ->
            row [ Background.color Colors.redOrange, width fill, padding 10 ] [ text err ]

        Nothing ->
            none
