module Utils exposing (..)

import Element exposing (..)
import Shared
import Shared.Model
import Tuple exposing (second)



-- UI


paddingBottom : Int -> Attribute msg
paddingBottom n =
    paddingEach
        { top = 0, right = 0, bottom = n, left = 0 }



-- BASKET


basketItemFromItemId :
    { itemId : Int
    , items : List Shared.Model.Item
    , userBasket : List Shared.Model.BasketItem
    }
    -> Shared.Model.BasketItem
basketItemFromItemId { itemId, items, userBasket } =
    let
        itemFoundById =
            List.filter (\item -> item.id == itemId) items
                |> List.head
                |> Maybe.withDefault Shared.dummyItem
    in
    { id = userBasket |> List.length |> (+) 1
    , categoryId = itemFoundById.categoryId
    , itemId = itemFoundById.id
    , name = itemFoundById.name
    , price = itemFoundById.price
    , qty = 1
    , createdAt = 0 -- TODO: generate Unix time in Elm
    }



-- PRICES


setDecimal : Float -> Int -> String
setDecimal number digits =
    let
        splittedNumber =
            number |> String.fromFloat |> String.split "."

        num =
            case splittedNumber of
                [ first, second ] ->
                    if String.length second < digits then
                        first ++ "." ++ second ++ String.repeat (digits - String.length second) "0"

                    else
                        first ++ "." ++ second

                _ ->
                    number |> String.fromFloat
    in
    num
