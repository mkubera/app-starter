module Pages.NotFound_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Element exposing (..)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
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


view : Model -> View Msg
view model =
    let
        _ =
            Debug.log "" (Debug.toString <| Route.Path.href Route.Path.Home_)
    in
    { title = "404"
    , attributes = []
    , element =
        column []
            [ row [] [ text "404" ]
            , row [] [ text "Page not found" ]
            , row []
                [ link []
                    { url = Route.Path.toString Route.Path.Home_
                    , label = text "Back to homepage"
                    }
                ]
            ]
    }
