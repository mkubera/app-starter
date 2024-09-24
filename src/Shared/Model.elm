module Shared.Model exposing (..)

{-| -}


{-| Normally, this value would live in "Shared.elm"
but that would lead to a circular dependency import cycle.

For that reason, both `Shared.Model` and `Shared.Msg` are in their
own file, so they can be imported by `Effect.elm`

-}
type alias User =
    { id : Int
    , email : String
    }


type alias Item =
    { id : Int
    , name : String
    , price : Float
    , qty : Int
    , createdAt : Int
    }


type alias BasketItem =
    { id : Int
    , itemId : Int
    , name : String
    , price : Float
    , qty : Int
    , createdAt : Int
    }


type alias UserItem =
    BasketItem


type Modal
    = PayConfirmation
    | ClearBasketConfirmation


type alias Model =
    { token : Maybe String
    , user : Maybe User
    , apiUrl : String
    , successNotification : Maybe String
    , errorNotification : Maybe String
    , modal : Maybe Modal

    -- DATA
    , items : List Item
    , userBasket : List BasketItem
    , userItems : List UserItem
    }
