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
    | Pay
    | ApiIncrementItemResponse (Result Http.Error { id : Int })
    | ApiDecrementItemResponse (Result Http.Error { id : Int })
    -- | ApiClearBasketResponse (Result Http.Error ())


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
                [ Effect.toggleModal
                    { modal = Just Shared.Model.ClearBasketConfirmation }
                ]
              -- [ Api.Basket.clear
              --     { onResponse = ApiClearBasketResponse
              --     , apiUrl = sharedModel.apiUrl
              --     , token = sharedModel.token |> Maybe.withDefault ""
              --     }
              -- ]
            )

        Pay ->
            ( model
            , Effect.batch
                [ Effect.toggleModal
                    { modal = Just Shared.Model.PayConfirmation }
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

        -- ApiClearBasketResponse (Ok _) ->
        --     ( model
        --     , Effect.clearBasket
        --     )

        -- ApiClearBasketResponse (Err _) ->
        --     ( model
        --     , Effect.saveErrorNotification { errString = "Something went wrong." }
        --     )



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
            [ row [ centerX, spacing 5 ]
                [ Components.Page.Header.view "BASKET"
                , viewBasketClear
                ]
            , viewBasketTotal sharedModel.userBasket
            , viewBasketItems sharedModel.userBasket
            , viewBasketPayBtn
            ]
    }


viewBasketItems : List Shared.Model.BasketItem -> Element Msg
viewBasketItems userBasket =
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
                    , viewBasketIncrementItemBtn { id = id }
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


viewBasketClear : Element Msg
viewBasketClear =
    row
        [ centerX
        , Background.color Colors.radiantYellow
        , alpha 0.8
        , Font.size 15
        , padding 8
        , Border.rounded 5
        ]
        [ Input.button []
            { onPress = Just ClearBasket, label = text "🌑" }
        ]


viewBasketPayBtn : Element Msg
viewBasketPayBtn =
    row
        [ centerX
        , Background.color Colors.radiantYellow
        , Font.size 18
        , padding 10
        , Border.rounded 5
        ]
        [ Input.button []
            { onPress = Just Pay, label = text "Payment ➡" }
        ]
