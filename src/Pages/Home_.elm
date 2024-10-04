module Pages.Home_ exposing (Model, Msg, page)

import Components.Categories
import Components.Items
import Components.Page.Header
import Effect exposing (Effect)
import Element exposing (..)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page sharedModel route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view sharedModel
        }
        |> Page.withLayout (\model -> Layouts.Main_Guest {})



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


view : Shared.Model -> Model -> View Msg
view sharedModel model =
    { title = "Homepage"
    , attributes = []
    , element =
        column [ width fill ]
            -- [ Components.Page.Header.view "HOME"
            [ Components.Categories.view
                { categories = sharedModel.categories
                , items = sharedModel.items
                }
            ]
    }
