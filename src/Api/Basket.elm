module Api.Basket exposing (..)

import Api.Headers
import Effect exposing (Effect)
import Http
import Json.Decode as D
import Json.Encode as E



-- GET BASKET (BY USER ID)


type alias GetBasketResponseData =
    List Int


getBasketresponseDecoder : D.Decoder GetBasketResponseData
getBasketresponseDecoder =
    D.list D.int


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
    { id : Int }


addToBasketResponseDecoder : D.Decoder AddToBasketResponseData
addToBasketResponseDecoder =
    D.map AddToBasketResponseData
        (D.field "id" D.int)


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
