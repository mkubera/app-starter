module Shared exposing
    ( Flags, decoder
    , Model, Msg
    , init, update, subscriptions
    , dummyItem, dummyUser
    )

{-|

@docs Flags, decoder
@docs Model, Msg
@docs init, update, subscriptions

-}

import Api.Basket
import Api.Categories
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


dummyItem : Shared.Model.Item
dummyItem =
    { id = 0
    , categoryId = 0
    , name = ""
    , price = 0
    , qty = 0
    , createdAt = 0
    }



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

            -- COMMERCIAL DATA
            , items = []
            , categories = []

            -- USER-OWNED DATA
            , userBasket = []
            , userItems = []
            , modal = Nothing
            }

        initEffects { apiUrl } =
            Effect.batch
                [ Api.Categories.getAll
                    { onResponse = Shared.Msg.ApiGetCategoriesResponse
                    , apiUrl = apiUrl
                    }
                , Api.Items.getAll
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
        Shared.Msg.ClearBasket ->
            case model.user of
                Just _ ->
                    ( model
                    , Effect.batch
                        [ Api.Basket.clear
                            { onResponse = Shared.Msg.ApiClearBasketResponse
                            , apiUrl = model.apiUrl
                            , token = model.token |> Maybe.withDefault ""
                            }
                        ]
                    )

                Nothing ->
                    ( { model | userBasket = [] }, Effect.none )

        Shared.Msg.ApiClearBasketResponse (Ok userBasket) ->
            ( { model | userBasket = userBasket }
            , Effect.batch
                [ Effect.saveSuccessNotification { successString = "Your Basket was cleared! 👍" }
                ]
            )

        Shared.Msg.ApiClearBasketResponse (Err _) ->
            ( model
            , Effect.saveErrorNotification { errString = "Something went wrong." }
            )

        Shared.Msg.IncrementBasketItem { id } ->
            let
                newBasket =
                    List.map
                        (\basketItem ->
                            if basketItem.id == id then
                                { basketItem | qty = basketItem.qty + 1 }

                            else
                                basketItem
                        )
                        model.userBasket
            in
            ( { model | userBasket = newBasket }, Effect.none )

        Shared.Msg.DecrementBasketItem { id } ->
            let
                newBasket =
                    model.userBasket
                        |> List.map
                            (\basketItem ->
                                if basketItem.id == id then
                                    { basketItem | qty = basketItem.qty - 1 }

                                else
                                    basketItem
                            )
            in
            ( { model | userBasket = newBasket }, Effect.none )

        Shared.Msg.SaveBasket { basket } ->
            ( { model
                | userBasket = basket
              }
            , Effect.none
            )

        Shared.Msg.AddToBasket { basketItem } ->
            ( { model | userBasket = basketItem :: model.userBasket }
            , Effect.none
            )

        Shared.Msg.ApiGetCategoriesResponse (Ok categories) ->
            ( model
            , Effect.saveCategories { categories = categories }
            )

        Shared.Msg.ApiGetCategoriesResponse (Err _) ->
            ( model
            , Effect.saveErrorNotification
                { errString = "Something went wrong." }
            )

        Shared.Msg.SaveCategories categories ->
            ( { model
                | categories = categories
              }
            , Effect.none
            )

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

        Shared.Msg.ToggleModal { modal } ->
            ( { model | modal = modal }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions route model =
    Sub.none
