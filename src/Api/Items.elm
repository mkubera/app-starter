module Api.Items exposing (..)

-- import Json.Encode as E

import Effect exposing (Effect)
import Http
import Json.Decode as D
import Shared.Model exposing (Item)


type alias ResponseData =
    List Shared.Model.Item


responseDecoder : D.Decoder ResponseData
responseDecoder =
    D.list itemDecoder


itemDecoder : D.Decoder Shared.Model.Item
itemDecoder =
    D.map7
        Shared.Model.Item
        (D.field "id" D.int)
        (D.field "categoryId" D.int)
        (D.field "name" D.string)
        (D.field "description" D.string)
        (D.field "price" D.float)
        (D.field "qty" D.int)
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
                { url = apiUrl ++ "/items"
                , expect = Http.expectJson onResponse responseDecoder
                }
    in
    Effect.sendCmd cmd
