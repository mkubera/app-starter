module Layouts.Main.User exposing (Model, Msg, Props, layout)

import Api.Basket
import Api.Logout
import Components.Nav.CategoryBtns
import Components.NavLink
import Design.Colors
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
        { init = init sharedModel
        , update = update sharedModel
        , view = view sharedModel
        , subscriptions = subscriptions
        }
        |> Layout.withParentProps {}



-- MODEL


type alias Model =
    { isLoggingOut : Bool }


init : Shared.Model.Model -> () -> ( Model, Effect Msg )
init sharedModel _ =
    let
        userId =
            case sharedModel.user of
                Just u ->
                    u.id

                Nothing ->
                    0
    in
    ( { isLoggingOut = False }
    , Effect.batch
        [ Api.Basket.get
            { onResponse = ApiGetBasketResponse
            , userId = userId
            , apiUrl = sharedModel.apiUrl
            , token = sharedModel.token |> Maybe.withDefault ""
            }
        ]
    )



-- UPDATE


type Msg
    = Logout
    | ApiLogoutResponse (Result Http.Error ())
    | ApiGetBasketResponse (Result Http.Error Api.Basket.GetBasketResponseData)


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

        ApiGetBasketResponse (Ok userBasket) ->
            ( model
            , Effect.batch
                [ Effect.getBasket { userBasket = userBasket }
                ]
            )

        ApiGetBasketResponse (Err _) ->
            ( model
            , Effect.saveErrorNotification
                { errString = "Something went wrong. Please try again." }
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
            [ viewNavbar sharedModel model
                |> Element.map toContentMsg
            , row [ centerX, centerY ] [ content.element ]
            ]
    }


viewNavbar : Shared.Model.Model -> Model -> Element Msg
viewNavbar sharedModel model =
    row
        [ spaceEvenly
        , Background.color (Design.Colors.primary |> Design.Colors.setAlpha 0.33)
        , width fill
        , padding 20
        ]
        [ row [] [ Components.NavLink.view Route.Path.Home_ ]
        , row [ spacing 30 ]
            [ Components.Nav.CategoryBtns.view sharedModel.categories
            , Components.NavLink.view Route.Path.User_Profile
            , Components.NavLink.view Route.Path.Basket
            , if model.isLoggingOut then
                button
                    [ alpha 0.5
                    ]
                    { onPress = Nothing, label = text "log out" }

              else
                button
                    [ mouseOver [ alpha 0.5 ]
                    ]
                    { onPress = Just Logout, label = text "log out" }
            ]
        ]
