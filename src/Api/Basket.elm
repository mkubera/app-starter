module Api.Basket exposing (..)

import Api.Headers
import Effect exposing (Effect)
import Http
import Json.Decode as D
import Json.Encode as E
import Shared.Model



-- GET BASKET (BY USER ID)


type alias GetBasketResponseData =
    List Shared.Model.BasketItem


getBasketresponseDecoder : D.Decoder GetBasketResponseData
getBasketresponseDecoder =
    D.list basketItemDecoder


get :
    { onResponse : Result Http.Error GetBasketResponseData -> msg
    , userId : Int
    , apiUrl : String
    , token : String
    }
    -> Effect msg
get { onResponse, userId, apiUrl, token } =
    let
        cmd : Cmd msg
        cmd =
            Http.request
                { method = "get"
                , headers =
                    [ Api.Headers.auth token
                    ]
                , url = apiUrl ++ "/users/" ++ String.fromInt userId ++ "/basket"
                , body = Http.emptyBody
                , expect = Http.expectJson onResponse getBasketresponseDecoder
                , timeout = Nothing
                , tracker = Nothing
                }
    in
    Effect.sendCmd cmd



-- ADD TO BASKET


type alias AddToBasketResponseData =
    { basketItem : Shared.Model.BasketItem }


addToBasketResponseDecoder : D.Decoder AddToBasketResponseData
addToBasketResponseDecoder =
    D.map AddToBasketResponseData
        (D.field "basketItem" basketItemDecoder)


basketItemDecoder : D.Decoder Shared.Model.BasketItem
basketItemDecoder =
    D.map6
        Shared.Model.BasketItem
        (D.field "id" D.int)
        (D.field "itemId" D.int)
        (D.field "name" D.string)
        (D.field "price" D.float)
        (D.field "qty" D.int)
        (D.field "createdAt" D.int)


add :
    { onResponse : Result Http.Error AddToBasketResponseData -> msg
    , id : Int
    , apiUrl : String
    , token : String
    }
    -> Effect msg
add { onResponse, id, apiUrl, token } =
    let
        encodedBody : E.Value
        encodedBody =
            E.object
                [ ( "id", E.int id )
                ]

        cmd : Cmd msg
        cmd =
            Http.request
                { method = "post"
                , headers = []
                , url = apiUrl ++ "/basket/add"
                , body = Http.jsonBody encodedBody
                , expect = Http.expectJson onResponse addToBasketResponseDecoder
                , timeout = Nothing
                , tracker = Nothing
                }
    in
    Effect.sendCmd cmd



-- INCREMENT BASKET ITEM


type alias IncrementItemResponseData =
    { id : Int }


incrementItemResponseDecoder : D.Decoder IncrementItemResponseData
incrementItemResponseDecoder =
    D.map IncrementItemResponseData
        (D.field "id" D.int)


incrementItem :
    { onResponse : Result Http.Error IncrementItemResponseData -> msg
    , id : Int
    , apiUrl : String
    , token : String
    }
    -> Effect msg
incrementItem { onResponse, id, apiUrl, token } =
    let
        encodedBody : E.Value
        encodedBody =
            E.object
                [ ( "id", E.int id )
                ]

        cmd : Cmd msg
        cmd =
            Http.request
                { method = "put"
                , headers = [ Api.Headers.auth token ]
                , url = apiUrl ++ "/basket/items/" ++ String.fromInt id ++ "/increment"
                , body = Http.jsonBody encodedBody
                , expect = Http.expectJson onResponse incrementItemResponseDecoder
                , timeout = Nothing
                , tracker = Nothing
                }
    in
    Effect.sendCmd cmd



-- DECREMENT BASKET ITEM


type alias DecrementItemResponseData =
    { id : Int }


decrementItemResponseDecoder : D.Decoder DecrementItemResponseData
decrementItemResponseDecoder =
    D.map DecrementItemResponseData
        (D.field "id" D.int)


decrementItem :
    { onResponse : Result Http.Error DecrementItemResponseData -> msg
    , id : Int
    , apiUrl : String
    , token : String
    }
    -> Effect msg
decrementItem { onResponse, id, apiUrl, token } =
    let
        encodedBody : E.Value
        encodedBody =
            E.object
                [ ( "id", E.int id )
                ]

        cmd : Cmd msg
        cmd =
            Http.request
                { method = "put"
                , headers = [ Api.Headers.auth token ]
                , url = apiUrl ++ "/basket/items/" ++ String.fromInt id ++ "/decrement"
                , body = Http.jsonBody encodedBody
                , expect = Http.expectJson onResponse decrementItemResponseDecoder
                , timeout = Nothing
                , tracker = Nothing
                }
    in
    Effect.sendCmd cmd
