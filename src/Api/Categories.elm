module Api.Categories exposing (..)

import Effect exposing (Effect)
import Http
import Json.Decode as D
import Shared.Model


type alias ResponseData =
    List Shared.Model.Category


responseDecoder : D.Decoder ResponseData
responseDecoder =
    D.list categoryDecoder


categoryDecoder : D.Decoder Shared.Model.Category
categoryDecoder =
    D.map4
        Shared.Model.Category
        (D.field "id" D.int)
        (D.field "name" D.string)
        (D.field "description" D.string)
        (D.field "createdAt" D.int)


getAll :
    { onResponse : Result Http.Error ResponseData -> msg
    , apiUrl : String
    }
    -> Effect msg
getAll { onResponse, apiUrl } =
    let
        cmd : Cmd msg
        cmd =
            Http.get
                { url = apiUrl ++ "/categories"
                , expect = Http.expectJson onResponse responseDecoder
                }
    in
    Effect.sendCmd cmd
