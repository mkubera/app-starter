module Api.Logout exposing (..)

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
                    [ Http.header "authorization" ("bearer " ++ token)
                    ]
                , url = apiUrl ++ "/users/logout"
                , body = Http.emptyBody
                , expect = Http.expectJson onResponse responseDecoder
                , timeout = Nothing
                , tracker = Nothing
                }
    in
    Effect.sendCmd cmd
