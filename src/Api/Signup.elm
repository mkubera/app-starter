module Api.Signup exposing (..)

import Effect exposing (Effect)
import Http
import Json.Encode as E


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
                { url = apiUrl ++ "/users/signup"
                , body = Http.jsonBody encodedBody
                , expect = Http.expectWhatever onResponse
                }
    in
    Effect.sendCmd cmd
