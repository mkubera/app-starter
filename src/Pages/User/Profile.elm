module Pages.User.Profile exposing (Model, Msg, page)

import Auth
import Components.Page.Header
import Effect exposing (Effect)
import Element exposing (..)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Shared.Model
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page authUser sharedModel route =
    Page.new
        { init = init
        , update = update authUser
        , subscriptions = subscriptions
        , view = view sharedModel
        }
        |> Page.withLayout (\model -> Layouts.User {})



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.batch
        [ Effect.clearSuccessNotification
        , Effect.clearErrorNotification
        ]
    )



-- UPDATE


type Msg
    = NoOp


update : Auth.User -> Msg -> Model -> ( Model, Effect Msg )
update { token } msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model.Model -> Model -> View Msg
view sharedModel model =
    { title = "Profile"
    , attributes = []
    , element =
        row []
            [ Components.Page.Header.view "PROFILE"
            ]
    }
