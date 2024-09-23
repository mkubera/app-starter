module Pages.Items exposing (Model, Msg, page)

import Api.Items
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
    Page.new
        { init = init sharedModel
        , update = update
        , subscriptions = subscriptions
        , view = view sharedModel
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


view : Shared.Model.Model -> Model -> View Msg
view sharedModel model =
    { title = "Items"
    , attributes = []
    , element =
        column
            [ width fill
            , height fill
            , spacing 20
            , padding 20
            ]
            [ Components.Page.Header.view "ITEMS"
            , viewItems sharedModel.items
            ]
    }


viewItems : List Shared.Model.Item -> Element msg
viewItems items =
    wrappedRow
        [ width (fill |> maximum 620)
        , centerX
        , centerY
        , spacingXY 10 10
        ]
    <|
        List.map
            (\item ->
                Components.Link.view
                    { routePath =
                        Route.Path.Items_Id_ { id = item.id |> String.fromInt }
                    , label =
                        column
                            [ width (px 300)
                            , height (px 300)
                            , Border.color Colors.balticSea
                            , Border.solid
                            , Border.width 2
                            , Border.rounded 5
                            , spacing 5
                            , pointer
                            , mouseOver
                                [ alpha 0.4
                                , Border.color Colors.radiantYellow
                                , Font.color Colors.radiantYellow
                                ]
                            ]
                            [ row [ centerX, centerY, Font.size 22, Font.bold ] [ text item.name ]
                            , row [ centerX, centerY, Font.size 18 ] [ text ("€" ++ String.fromFloat item.price) ]
                            , row [ centerX, centerY, Font.size 14 ] [ text (String.fromInt item.qty ++ " copies left") ]
                            ]
                    }
            )
            items
