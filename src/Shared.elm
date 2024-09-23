module Shared exposing
    ( Flags, decoder
    , Model, Msg
    , init, update, subscriptions
    , dummyUser
    )

{-|

@docs Flags, decoder
@docs Model, Msg
@docs init, update, subscriptions

-}

import Api.Items
import Dict
import Effect exposing (Effect)
import Json.Decode
import Route exposing (Route)
import Route.Path
import Shared.Model
import Shared.Msg


dummyUser : Shared.Model.User
dummyUser =
    { id = 0, email = "" }



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
    let
        initModel : { apiUrl : String } -> Model
        initModel { apiUrl } =
            { token = Nothing
            , user = Nothing
            , apiUrl = apiUrl
            , successNotification = Nothing
            , errorNotification = Nothing
            , items = []
            }

        initEffects { apiUrl } =
            Effect.batch
                [ Api.Items.getAll
                    { onResponse = Shared.Msg.ApiGetItemsResponse
                    , apiUrl = apiUrl
                    }
                ]
    in
    case flagsResult of
        Ok { apiUrl } ->
            ( initModel { apiUrl = apiUrl }
            , initEffects { apiUrl = apiUrl }
            )

        Err _ ->
            ( initModel { apiUrl = "" }
            , Effect.saveErrorNotification
                { errString = "Failed to load data. Refresh the window or try again later." }
            )



-- UPDATE


type alias Msg =
    Shared.Msg.Msg


update : Route () -> Msg -> Model -> ( Model, Effect Msg )
update route msg model =
    case msg of
        Shared.Msg.ApiGetItemsResponse (Ok items) ->
            ( model
            , Effect.saveItems { items = items }
            )

        Shared.Msg.ApiGetItemsResponse (Err _) ->
            ( model
            , Effect.saveErrorNotification
                { errString = "Something went wrong." }
            )

        Shared.Msg.SaveItems items ->
            ( { model
                | items = items
              }
            , Effect.none
            )

        Shared.Msg.UpdateUser user ->
            ( { model
                | user = Just user
              }
            , Effect.batch
                [ Effect.clearErrorNotification
                , Effect.saveSuccessNotification
                    { successString = "Profile update successful! 👌" }
                ]
            )

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
