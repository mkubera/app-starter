module Api.Basket exposing (..)

import Effect exposing (Effect)
import Http
import Json.Decode as D
import Json.Encode as E


type alias AddToBasketResponseData =
    { id : Int }


responseDecoder : D.Decoder AddToBasketResponseData
responseDecoder =
    D.map AddToBasketResponseData
        (D.field "id" D.int)


add :
    { onResponse : Result Http.Error AddToBasketResponseData -> msg
    , id : Int
    , apiUrl : String
    }
    -> Effect msg
add { onResponse, id, apiUrl } =
    let
        encodedBody : E.Value
        encodedBody =
            E.object
                [ ( "id", E.int id )
                ]

        cmd : Cmd msg
        cmd =
            Http.post
                { url = apiUrl ++ "/basket/add"
                , body = Http.jsonBody encodedBody
                , expect = Http.expectJson onResponse responseDecoder
                }
    in
    Effect.sendCmd cmd
