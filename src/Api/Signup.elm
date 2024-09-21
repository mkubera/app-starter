module Api.Signup exposing (..)

import Effect exposing (Effect)
import Http
import Json.Decode as D
import Json.Encode as E


type alias ResponseData =
    { msg : String
    }


responseDecoder : D.Decoder ResponseData
responseDecoder =
    D.map
        ResponseData
        (D.field "msg" D.string)


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
                { url = apiUrl ++ "/users/signup"
                , body = Http.jsonBody encodedBody
                , expect = Http.expectJson onResponse responseDecoder
                }
    in
    Effect.sendCmd cmd
