module Layouts.Main.User exposing (Model, Msg, Props, layout)

import Api.Logout
import Components.NavLink
import Dict
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Input exposing (button)
import Html exposing (dl)
import Http
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
    Layout.new
        { init = init
        , update = update sharedModel
        , view = view
        , subscriptions = subscriptions
        }
        |> Layout.withParentProps {}



-- MODEL


type alias Model =
    { isLoggingOut : Bool }


init : () -> ( Model, Effect Msg )
init _ =
    ( { isLoggingOut = False }
    , Effect.none
    )



-- UPDATE


type Msg
    = Logout
    | ApiLogoutResponse (Result Http.Error ())


update : Shared.Model.Model -> Msg -> Model -> ( Model, Effect Msg )
update sharedModel msg model =
    case msg of
        Logout ->
            ( { model | isLoggingOut = True }
            , Api.Logout.post
                { onResponse = ApiLogoutResponse
                , apiUrl = sharedModel.apiUrl
                , token = sharedModel.token |> Maybe.withDefault ""
                }
            )

        ApiLogoutResponse (Ok _) ->
            ( { model
                | isLoggingOut = False
              }
            , Effect.batch
                [ Effect.clearErrorNotification
                , Effect.logout
                , Effect.pushRoute
                    { path = Route.Path.Login
                    , query = Dict.empty
                    , hash = Nothing
                    }
                ]
            )

        ApiLogoutResponse (Err _) ->
            ( { model
                | isLoggingOut = False
              }
            , Effect.saveErrorNotification
                { errString = "Something went wrong. Please try again." }
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
        [ row [] [ Components.NavLink.view Route.Path.Home_ ]
        , row [ spacing 20 ]
            [ Components.NavLink.view Route.Path.Items
            , Components.NavLink.view Route.Path.User_Profile
            , if model.isLoggingOut then
                button
                    [ alpha 0.5
                    ]
                    { onPress = Nothing, label = text "Logout" }

              else
                button
                    [ mouseOver [ alpha 0.5 ]
                    ]
                    { onPress = Just Logout, label = text "Logout" }
            ]
        ]
