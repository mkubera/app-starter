module Api.User.Profile exposing (..)

import Api.Headers
import Effect exposing (Effect)
import Http
import Json.Decode as D
import Json.Encode as E
import Shared exposing (Msg, decoder)
import Shared.Model


type alias ResponseData =
    Shared.Model.User



-- responseDecoder : D.Decoder ResponseData
-- responseDecoder =
--     D.map2
--         ResponseData
--         (D.field "token" D.string)
--         (D.field "user" userDecoder)


responseDecoder : D.Decoder ResponseData
responseDecoder =
    D.map2 Shared.Model.User
        (D.field "id" D.int)
        (D.field "email" D.string)


put :
    { onResponse : Result Http.Error ResponseData -> msg
    , email : String
    , apiUrl : String
    , token : String
    }
    -> Effect msg
put { onResponse, email, apiUrl, token } =
    let
        encodedBody : E.Value
        encodedBody =
            E.object
                [ ( "email", E.string email )
                ]

        cmd : Cmd msg
        cmd =
            Http.request
                { method = "put"
                , headers =
                    [ Api.Headers.auth token
                    ]
                , url = apiUrl ++ "/users/profile"
                , body = Http.jsonBody encodedBody
                , expect = Http.expectJson onResponse responseDecoder
                , timeout = Nothing
                , tracker = Nothing
                }
    in
    Effect.sendCmd cmd
