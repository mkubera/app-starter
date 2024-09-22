module Api.Logout exposing (..)

import Api.Headers
import Effect exposing (Effect)
import Http


post :
    { onResponse : Result Http.Error () -> msg
    , apiUrl : String
    , token : String
    }
    -> Effect msg
post { onResponse, apiUrl, token } =
    let
        cmd : Cmd msg
        cmd =
            Http.request
                { method = "post"
                , headers =
                    [ Api.Headers.auth token
                    ]
                , url = apiUrl ++ "/users/logout"
                , body = Http.emptyBody
                , expect = Http.expectWhatever onResponse
                , timeout = Nothing
                , tracker = Nothing
                }
    in
    Effect.sendCmd cmd
