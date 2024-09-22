module Api.Logout exposing (..)

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
        authHeader : Http.Header
        authHeader =
            Http.header "authorization" ("bearer " ++ token)

        cmd : Cmd msg
        cmd =
            Http.request
                { method = "post"
                , headers =
                    [ authHeader
                    ]
                , url = apiUrl ++ "/users/logout"
                , body = Http.emptyBody
                , expect = Http.expectWhatever onResponse
                , timeout = Nothing
                , tracker = Nothing
                }
    in
    Effect.sendCmd cmd
