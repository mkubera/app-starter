module Pages.Basket exposing (Model, Msg, page)

import Api.Basket
import Components.Page.Header
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FlatColors.TurkishPalette as Colors
import Html exposing (q)
import Http
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Shared.Model
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page sharedModel route =
    Page.new
        { init = init
        , update = update sharedModel
        , subscriptions = subscriptions
        , view = view sharedModel
        }
        |> Page.withLayout (\model -> Layouts.Main_User {})



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
    = IncrementItem { id : Int }
    | DecrementItem { id : Int }
    | ClearBasket
    | ApiIncrementItemResponse (Result Http.Error { id : Int })
    | ApiDecrementItemResponse (Result Http.Error { id : Int })
    | ApiClearBasketResponse (Result Http.Error ())


update : Shared.Model.Model -> Msg -> Model -> ( Model, Effect Msg )
update sharedModel msg model =
    case msg of
        IncrementItem { id } ->
            ( model
            , Effect.batch
                [ Api.Basket.incrementItem
                    { onResponse = ApiIncrementItemResponse
                    , id = id
                    , apiUrl = sharedModel.apiUrl
                    , token = sharedModel.token |> Maybe.withDefault ""
                    }
                ]
            )

        DecrementItem { id } ->
            ( model
            , Effect.batch
                [ Api.Basket.decrementItem
                    { onResponse = ApiDecrementItemResponse
                    , id = id
                    , apiUrl = sharedModel.apiUrl
                    , token = sharedModel.token |> Maybe.withDefault ""
                    }
                ]
            )

        ClearBasket ->
            ( model
            , Effect.batch
                [ Api.Basket.clear
                    { onResponse = ApiClearBasketResponse
                    , apiUrl = sharedModel.apiUrl
                    , token = sharedModel.token |> Maybe.withDefault ""
                    }
                ]
            )

        ApiIncrementItemResponse (Ok { id }) ->
            ( model
            , Effect.incrementBasketItemQty { id = id }
            )

        ApiIncrementItemResponse (Err _) ->
            ( model
            , Effect.saveErrorNotification { errString = "Something went wrong." }
            )

        ApiDecrementItemResponse (Ok { id }) ->
            ( model
            , Effect.decrementBasketItemQty { id = id }
            )

        ApiDecrementItemResponse (Err _) ->
            ( model
            , Effect.saveErrorNotification { errString = "Something went wrong." }
            )

        ApiClearBasketResponse (Ok _) ->
            ( model
            , Effect.clearBasket
            )

        ApiClearBasketResponse (Err _) ->
            ( model
            , Effect.saveErrorNotification { errString = "Something went wrong." }
            )



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
            [ Components.Page.Header.view "BASKET"
            , viewBasketItems sharedModel.userBasket
            , viewBasketTotal sharedModel.userBasket
            , viewBasketClear
            ]
    }


viewBasketItems userBasket =
    -- TODO:
    -- 1) UI basket (D)
    column [ spacing 20 ] <|
        List.map
            (\{ id, name, price, qty } ->
                row
                    [ spacing 5
                    , below <|
                        el
                            [ mouseOver [ alpha 1 ]
                            , alpha 0
                            , Font.size 14
                            , Font.color Colors.shadowedSteel
                            ]
                        <|
                            text "The moon icon is purely decorative. You Are Not Purchasing the Earth's Moon!! ☝"
                    ]
                    [ row
                        (if qty == 0 then
                            [ Font.medium, alpha 0.5 ]

                         else
                            [ Font.medium, alpha 1 ]
                        )
                        [ el [ Font.bold ] <| text (String.fromInt qty ++ "x")
                        , text " 🌗 "
                        , text name
                        , text (" (€" ++ String.fromFloat price ++ ")")
                        ]
                    , text " || "
                    , viewBasketIncrementItemBtn { id = id }

                    -- , text (String.fromInt qty)
                    , viewBasketDecrementItemBtn { id = id, qty = qty }
                    ]
            )
            userBasket


viewBasketIncrementItemBtn : { id : Int } -> Element Msg
viewBasketIncrementItemBtn { id } =
    Input.button
        [ Background.color Colors.brightLilac
        , Font.color (rgb255 255 255 255)
        , width (px 20)
        , height (px 20)
        , Font.center
        , Border.rounded 5
        ]
        { onPress = Just (IncrementItem { id = id }), label = text "+" }


viewBasketDecrementItemBtn : { id : Int, qty : Int } -> Element Msg
viewBasketDecrementItemBtn { id, qty } =
    Input.button
        [ Background.color Colors.redOrange
        , Font.color (rgb255 255 255 255)
        , width (px 20)
        , height (px 20)
        , Font.center
        , Border.rounded 5
        ]
        { onPress =
            if qty > 0 then
                Just (DecrementItem { id = id })

            else
                Nothing
        , label = text "-"
        }


viewBasketTotal : List Shared.Model.UserItem -> Element msg
viewBasketTotal userBasket =
    let
        sumOfItems : Float
        sumOfItems =
            List.foldl (\{ qty, price } acc -> acc + (toFloat qty * price)) 0 userBasket

        totalTxt : String
        totalTxt =
            String.fromFloat sumOfItems
    in
    row
        [ centerX
        , Font.color Colors.lightIndigo
        , alpha 0.8
        , Font.italic
        , Font.size 18
        , Border.width 1
        , Border.solid
        , Border.color Colors.lightIndigo
        , padding 10
        ]
        [ text <| "€" ++ totalTxt
        ]


viewBasketClear =
    row []
        [ Input.button []
            { onPress = Just ClearBasket, label = text "Clear basket" }
        ]


