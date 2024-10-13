module Effect exposing
    ( Effect
    , none, batch
    , sendCmd, sendMsg
    , pushRoute, replaceRoute
    , pushRoutePath, replaceRoutePath
    , loadExternalUrl, back
    , map, toCmd
    , addToBasket, clearBasket, clearErrorNotification, clearNotificationsAfterSleep, clearSuccessNotification, decrementBasketItemQty, getBasket, incrementBasketItemQty, login, logout, saveCategories, saveErrorNotification, saveItems, saveSuccessNotification, toggleModal, updateUser
    )

{-|

@docs Effect

@docs none, batch
@docs sendCmd, sendMsg

@docs pushRoute, replaceRoute
@docs pushRoutePath, replaceRoutePath
@docs loadExternalUrl, back

@docs map, toCmd

-}

import Browser.Navigation
import Dict exposing (Dict)
import Process
import Route exposing (Route)
import Route.Path
import Shared.Model
import Shared.Msg
import Task
import Url exposing (Url)


type Effect msg
    = -- BASICS
      None
    | Batch (List (Effect msg))
    | SendCmd (Cmd msg)
      -- ROUTING
    | PushUrl String
    | ReplaceUrl String
    | LoadExternalUrl String
    | Back
      -- SHARED
    | SendSharedMsg Shared.Msg.Msg



-- ADDED


clearNotificationsAfterSleep : { seconds : Int } -> Effect Shared.Msg.Msg
clearNotificationsAfterSleep { seconds } =
    let
        clearSuccessNotificationCmd : Cmd Shared.Msg.Msg
        clearSuccessNotificationCmd =
            Process.sleep (toFloat (seconds * 1000))
                |> Task.perform (\_ -> Shared.Msg.ClearSuccessNotification)

        clearErrorNotificationCmd : Cmd Shared.Msg.Msg
        clearErrorNotificationCmd =
            Process.sleep (toFloat (seconds * 1000))
                |> Task.perform (\_ -> Shared.Msg.ClearErrorNotification)
    in
    batch
        [ SendCmd clearSuccessNotificationCmd
        , SendCmd clearErrorNotificationCmd
        ]


toggleModal : { modal : Maybe Shared.Model.Modal } -> Effect msg
toggleModal { modal } =
    SendSharedMsg (Shared.Msg.ToggleModal { modal = modal })


clearBasket : Effect msg
clearBasket =
    SendSharedMsg Shared.Msg.ClearBasket


incrementBasketItemQty : { id : Int } -> Effect msg
incrementBasketItemQty { id } =
    SendSharedMsg (Shared.Msg.IncrementBasketItem { id = id })


decrementBasketItemQty : { id : Int } -> Effect msg
decrementBasketItemQty { id } =
    SendSharedMsg (Shared.Msg.DecrementBasketItem { id = id })


getBasket : { userBasket : List Shared.Model.BasketItem } -> Effect msg
getBasket { userBasket } =
    SendSharedMsg (Shared.Msg.SaveBasket { basket = userBasket })


addToBasket : { basketItem : Shared.Model.BasketItem } -> Effect msg
addToBasket { basketItem } =
    SendSharedMsg (Shared.Msg.AddToBasket { basketItem = basketItem })


saveCategories : { categories : List Shared.Model.Category } -> Effect msg
saveCategories { categories } =
    SendSharedMsg (Shared.Msg.SaveCategories categories)


saveItems : { items : List Shared.Model.Item } -> Effect msg
saveItems { items } =
    SendSharedMsg (Shared.Msg.SaveItems items)


updateUser : { user : Shared.Model.User } -> Effect msg
updateUser { user } =
    SendSharedMsg (Shared.Msg.UpdateUser user)


login : { token : String, user : Shared.Model.User } -> Effect msg
login data =
    SendSharedMsg (Shared.Msg.Login data)


logout : Effect msg
logout =
    SendSharedMsg Shared.Msg.Logout


saveSuccessNotification : { successString : String } -> Effect msg
saveSuccessNotification { successString } =
    SendSharedMsg (Shared.Msg.SaveSuccessNotification successString)


clearSuccessNotification : Effect msg
clearSuccessNotification =
    SendSharedMsg Shared.Msg.ClearSuccessNotification


saveErrorNotification : { errString : String } -> Effect msg
saveErrorNotification { errString } =
    SendSharedMsg (Shared.Msg.SaveErrorNotification errString)


clearErrorNotification : Effect msg
clearErrorNotification =
    SendSharedMsg Shared.Msg.ClearErrorNotification



-- BASICS


{-| Don't send any effect.
-}
none : Effect msg
none =
    None


{-| Send multiple effects at once.
-}
batch : List (Effect msg) -> Effect msg
batch =
    Batch


{-| Send a normal `Cmd msg` as an effect, something like `Http.get` or `Random.generate`.
-}
sendCmd : Cmd msg -> Effect msg
sendCmd =
    SendCmd


{-| Send a message as an effect. Useful when emitting events from UI components.
-}
sendMsg : msg -> Effect msg
sendMsg msg =
    Task.succeed msg
        |> Task.perform identity
        |> SendCmd



-- ROUTING


{-| Set the new route, and make the back button go back to the current route.
-}
pushRoute :
    { path : Route.Path.Path
    , query : Dict String String
    , hash : Maybe String
    }
    -> Effect msg
pushRoute route =
    PushUrl (Route.toString route)


{-| Same as `Effect.pushRoute`, but without `query` or `hash` support
-}
pushRoutePath : Route.Path.Path -> Effect msg
pushRoutePath path =
    PushUrl (Route.Path.toString path)


{-| Set the new route, but replace the previous one, so clicking the back
button **won't** go back to the previous route.
-}
replaceRoute :
    { path : Route.Path.Path
    , query : Dict String String
    , hash : Maybe String
    }
    -> Effect msg
replaceRoute route =
    ReplaceUrl (Route.toString route)


{-| Same as `Effect.replaceRoute`, but without `query` or `hash` support
-}
replaceRoutePath : Route.Path.Path -> Effect msg
replaceRoutePath path =
    ReplaceUrl (Route.Path.toString path)


{-| Redirect users to a new URL, somewhere external to your web application.
-}
loadExternalUrl : String -> Effect msg
loadExternalUrl =
    LoadExternalUrl


{-| Navigate back one page
-}
back : Effect msg
back =
    Back



-- INTERNALS


{-| Elm Land depends on this function to connect pages and layouts
together into the overall app.
-}
map : (msg1 -> msg2) -> Effect msg1 -> Effect msg2
map fn effect =
    case effect of
        None ->
            None

        Batch list ->
            Batch (List.map (map fn) list)

        SendCmd cmd ->
            SendCmd (Cmd.map fn cmd)

        PushUrl url ->
            PushUrl url

        ReplaceUrl url ->
            ReplaceUrl url

        Back ->
            Back

        LoadExternalUrl url ->
            LoadExternalUrl url

        SendSharedMsg sharedMsg ->
            SendSharedMsg sharedMsg


{-| Elm Land depends on this function to perform your effects.
-}
toCmd :
    { key : Browser.Navigation.Key
    , url : Url
    , shared : Shared.Model.Model
    , fromSharedMsg : Shared.Msg.Msg -> msg
    , batch : List msg -> msg
    , toCmd : msg -> Cmd msg
    }
    -> Effect msg
    -> Cmd msg
toCmd options effect =
    case effect of
        None ->
            Cmd.none

        Batch list ->
            Cmd.batch (List.map (toCmd options) list)

        SendCmd cmd ->
            cmd

        PushUrl url ->
            Browser.Navigation.pushUrl options.key url

        ReplaceUrl url ->
            Browser.Navigation.replaceUrl options.key url

        Back ->
            Browser.Navigation.back options.key 1

        LoadExternalUrl url ->
            Browser.Navigation.load url

        SendSharedMsg sharedMsg ->
            Task.succeed sharedMsg
                |> Task.perform options.fromSharedMsg
