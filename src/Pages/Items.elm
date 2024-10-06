module Pages.Items exposing (Model, Msg, page)

import Api.Items
import Components.Items
import Components.Link
import Components.Page.Header
import Dict
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FlatColors.TurkishPalette as Colors
import Http
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import Shared.Model
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page sharedModel route =
    let
        categoryId =
            route.query
                |> Dict.get "categoryId"
                |> Maybe.andThen String.toInt
                |> Maybe.withDefault 0

        categoryName =
            route.query
                |> Dict.get "categoryName"
                |> Maybe.withDefault ""
    in
    Page.new
        { init = init sharedModel
        , update = update
        , subscriptions = subscriptions
        , view = view sharedModel categoryId categoryName
        }
        |> Page.withLayout
            (\model ->
                case sharedModel.user of
                    Just _ ->
                        Layouts.Main_User {}

                    Nothing ->
                        Layouts.Main_Guest {}
            )



-- INIT


type alias Model =
    {}


init : Shared.Model.Model -> () -> ( Model, Effect Msg )
init sharedModel () =
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
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model.Model -> Int -> String -> Model -> View Msg
view sharedModel categoryId categoryName model =
    let
        itemsOfCategory =
            List.filter (\item -> item.categoryId == categoryId) sharedModel.items
    in
    { title = String.toUpper categoryName
    , attributes = []
    , element =
        column
            [ width fill
            , height fill
            , spacing 20
            , padding 20
            ]
            [ Components.Page.Header.view (String.toUpper categoryName)
            , Components.Items.view { items = itemsOfCategory }
            ]
    }
