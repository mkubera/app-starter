module Pages.Items.Id_ exposing (Model, Msg, page)

import Api.Basket
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


page : Shared.Model -> Route { id : String } -> Page Model Msg
page sharedModel route =
    let
        routeId =
            case route.path of
                Route.Path.Items_Id_ { id } ->
                    id
                        |> String.toInt
                        |> Debug.log "path id"
                        |> Maybe.withDefault 0

                _ ->
                    99
    in
    Page.new
        { init = init sharedModel
        , update = update sharedModel
        , subscriptions = subscriptions
        , view = view sharedModel routeId
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
    = AddToBasket { id : Int }
    | ApiAddToBasketResponse (Result Http.Error Api.Basket.AddToBasketResponseData)


update : Shared.Model.Model -> Msg -> Model -> ( Model, Effect Msg )
update sharedModel msg model =
    case msg of
        AddToBasket { id } ->
            ( model
            , Api.Basket.add
                { onResponse = ApiAddToBasketResponse
                , id = id
                , apiUrl = sharedModel.apiUrl
                , token = sharedModel.token |> Maybe.withDefault ""
                }
            )

        ApiAddToBasketResponse (Ok { basketItem }) ->
            ( model
            , Effect.addToBasket { basketItem = basketItem }
            )

        ApiAddToBasketResponse (Err _) ->
            ( model
            , Effect.saveErrorNotification { errString = "Something went wrong." }
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model.Model -> Int -> Model -> View Msg
view sharedModel itemId model =
    let
        dummyItem : Shared.Model.Item
        dummyItem =
            { id = 0, name = "", price = 0, qty = 0, createdAt = 0 }

        item : Shared.Model.Item
        item =
            sharedModel.items
                |> List.filter (\{ id } -> id == itemId)
                |> Debug.log "filtered item"
                |> List.head
                |> Maybe.withDefault dummyItem
    in
    { title = "Items"
    , attributes = []
    , element =
        column
            [ width fill
            , height fill
            , spacing 20
            , padding 20
            ]
            [ Components.Link.view
                { routePath = Route.Path.Items
                , label = text "<- back to Items"
                }
            , Components.Page.Header.view "ITEM"
            , viewAddToBasket item.id
            , viewItem item
            ]
    }


viewAddToBasket : Int -> Element Msg
viewAddToBasket id =
    column
        [ centerX
        ]
        [ Input.button
            [ Font.color Colors.balticSea
            , padding 8
            , Border.color Colors.balticSea
            , Border.solid
            , Border.width 2
            , Border.rounded 5
            , mouseOver
                [ Font.color Colors.radiantYellow
                , Border.color Colors.radiantYellow
                ]
            ]
            { onPress = Just (AddToBasket { id = id })
            , label = text "+basket"
            }
        ]


viewItem : Shared.Model.Item -> Element msg
viewItem item =
    column
        [ width (px 620)
        , height (px 620)
        , Border.color Colors.balticSea
        , Border.solid
        , Border.width 2
        , Border.rounded 5
        , centerX
        , centerY
        , spacingXY 10 10
        ]
        [ row [ centerX, centerY, Font.size 22, Font.bold ] [ text item.name ]
        , row [ centerX, centerY, Font.size 18 ] [ text ("€" ++ String.fromFloat item.price) ]
        , row [ centerX, centerY, Font.size 14 ] [ text (String.fromInt item.qty ++ " copies left") ]
        ]
