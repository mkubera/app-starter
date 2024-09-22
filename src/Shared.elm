module Shared exposing
    ( Flags, decoder
    , Model, Msg
    , init, update, subscriptions
    )

{-|

@docs Flags, decoder
@docs Model, Msg
@docs init, update, subscriptions

-}

import Dict
import Effect exposing (Effect)
import Json.Decode
import Route exposing (Route)
import Route.Path
import Shared.Model
import Shared.Msg



-- FLAGS


type alias Flags =
    { apiUrl : String }


decoder : Json.Decode.Decoder Flags
decoder =
    Json.Decode.map Flags
        (Json.Decode.field "apiUrl" Json.Decode.string)



-- INIT


type alias Model =
    Shared.Model.Model


init : Result Json.Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init flagsResult route =
    case flagsResult of
        Ok { apiUrl } ->
            ( { token = Nothing
              , user = Nothing
              , apiUrl = apiUrl
              , successNotification = Nothing
              , errorNotification = Nothing
              }
            , Effect.none
            )

        Err err ->
            ( { token = Nothing
              , user = Nothing
              , apiUrl = ""
              , successNotification = Nothing
              , errorNotification = Nothing
              }
            , Effect.none
            )



-- UPDATE


type alias Msg =
    Shared.Msg.Msg


update : Route () -> Msg -> Model -> ( Model, Effect Msg )
update route msg model =
    case msg of
        Shared.Msg.Login { token, user } ->
            ( { model
                | token = Just token
                , user = Just user
              }
            , Effect.pushRoute
                { path = Route.Path.User_Profile
                , query = Dict.empty
                , hash = Nothing
                }
            )

        Shared.Msg.Logout ->
            ( { model
                | token = Nothing
                , user = Nothing
              }
            , Effect.pushRoute
                { path = Route.Path.Home_
                , query = Dict.empty
                , hash = Nothing
                }
            )

        Shared.Msg.SaveSuccessNotification string ->
            ( { model | successNotification = Just string }
            , Effect.none
            )

        Shared.Msg.ClearSuccessNotification ->
            ( { model | successNotification = Nothing }
            , Effect.none
            )

        Shared.Msg.SaveErrorNotification string ->
            ( { model | errorNotification = Just string }
            , Effect.none
            )

        Shared.Msg.ClearErrorNotification ->
            ( { model | errorNotification = Nothing }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions route model =
    Sub.none
