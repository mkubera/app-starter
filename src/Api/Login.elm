module Api.Login exposing (..)

import Effect exposing (Effect)
import Http
import Json.Encode as E
import Shared exposing (Msg)


post :
    { onResponse : Result Http.Error () -> msg
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
                , expect = Http.expectWhatever onResponse
                }
    in
    Effect.sendCmd cmd
