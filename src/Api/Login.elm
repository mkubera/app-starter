module Api.Login exposing (..)

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
    , email : String
    , apiUrl : String
    }
    -> Effect msg
post { onResponse, email, apiUrl } =
    let
        encodedBody : E.Value
        encodedBody =
            E.object
                [ ( "email", E.string email )
                ]

        cmd : Cmd msg
        cmd =
            Http.post
                { url = apiUrl ++ "/users/login"
                , body = Http.jsonBody encodedBody
                , expect = Http.expectJson onResponse responseDecoder
                }
    in
    Effect.sendCmd cmd
