module Shared.Msg exposing (Msg(..))

{-| -}

import Http
import Shared.Model


{-| Normally, this value would live in "Shared.elm"
but that would lead to a circular dependency import cycle.

For that reason, both `Shared.Model` and `Shared.Msg` are in their
own file, so they can be imported by `Effect.elm`

-}
type Msg
    = --BASKET
      ClearBasket
      | ApiClearBasketResponse (Result Http.Error ())
    | IncrementBasketItem { id : Int }
    | DecrementBasketItem { id : Int }
    | SaveBasket { basket : List Shared.Model.BasketItem }
    | AddToBasket { basketItem : Shared.Model.BasketItem }
      -- ITEMS
    | ApiGetItemsResponse (Result Http.Error (List Shared.Model.Item))
    | SaveItems (List Shared.Model.Item)
      -- USER
    | UpdateUser Shared.Model.User
      -- AUTH
    | Login { token : String, user : Shared.Model.User }
    | Logout
      -- NOTIFICATIONS
    | SaveSuccessNotification String
    | ClearSuccessNotification
    | SaveErrorNotification String
    | ClearErrorNotification
      -- MODAL
    | ToggleModal { modal : Maybe Shared.Model.Modal }
