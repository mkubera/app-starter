module Shared.Msg exposing (Msg(..))

{-| -}

import Shared.Model


{-| Normally, this value would live in "Shared.elm"
but that would lead to a circular dependency import cycle.

For that reason, both `Shared.Model` and `Shared.Msg` are in their
own file, so they can be imported by `Effect.elm`

-}
type Msg
    = Login { token : String, user : Shared.Model.User }
    | Logout
    | SaveErrorNotification String
    | ClearErrorNotification
