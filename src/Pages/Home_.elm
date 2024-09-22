module Pages.Home_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Element exposing (..)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)
import Components.Page.Header


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
        |> Page.withLayout (\model -> Layouts.Guest {})



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
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


view : Model -> View Msg
view model =
    { title = "Homepage"
    , attributes = []
    , element =
        column []
            [ Components.Page.Header.view "HOME"
            ]
    }
