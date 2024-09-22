module Api.LoginMagicToken exposing (..)

import Effect exposing (Effect)
import Http
import Json.Decode as D
import Json.Encode as E
import Shared exposing (Msg)
import Shared.Model


type alias ResponseData =
    { token : String
    , user : Shared.Model.User
    }


responseDecoder : D.Decoder ResponseData
responseDecoder =
    D.map2
        ResponseData
        (D.field "token" D.string)
        (D.field "user" userDecoder)


userDecoder : D.Decoder Shared.Model.User
userDecoder =
    D.map2 Shared.Model.User
        (D.field "id" D.int)
        (D.field "email" D.string)


post :
    { onResponse : Result Http.Error ResponseData -> msg
    , magicToken : String
    , apiUrl : String
    }
    -> Effect msg
post { onResponse, magicToken, apiUrl } =
    let
        encodedBody : E.Value
        encodedBody =
            E.object
                [ ( "magicToken", E.string magicToken )
                ]

        cmd : Cmd msg
        cmd =
            Http.post
                { url = apiUrl ++ "/users/magic-token"
                , body = Http.jsonBody encodedBody
                , expect = Http.expectJson onResponse responseDecoder
                }
    in
    Effect.sendCmd cmd
