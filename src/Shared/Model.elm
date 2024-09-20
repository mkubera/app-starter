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


type alias Model =
    { token : Maybe String
    , user : Maybe User
    , apiUrl : String
    }
