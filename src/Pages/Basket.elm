module Pages.Basket exposing (Model, Msg, page)

import Api.Basket
import Components.Basket exposing (viewBasketTotal)
import Components.Page.Header
import Design.Colors
import Effect exposing (Effect, incrementBasketItemQty)
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
        { init = init
        , update = update sharedModel
        , subscriptions = subscriptions
        , view = view sharedModel
        }
        |> Page.withLayout
            (\model ->
                case sharedModel.token of
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
    | ContinueToStep2
    | ApiIncrementItemResponse (Result Http.Error { id : Int })
    | ApiDecrementItemResponse (Result Http.Error { id : Int })


update : Shared.Model.Model -> Msg -> Model -> ( Model, Effect Msg )
update sharedModel msg model =
    case msg of
        IncrementItem { id } ->
            case sharedModel.user of
                Just _ ->
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

                Nothing ->
                    ( model
                    , Effect.incrementBasketItemQty { id = id }
                    )

        DecrementItem { id } ->
            case sharedModel.user of
                Just _ ->
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

                Nothing ->
                    ( model
                    , Effect.decrementBasketItemQty { id = id }
                    )

        ClearBasket ->
            ( model
            , Effect.batch
                [ Effect.toggleModal
                    { modal = Just Shared.Model.ClearBasketConfirmation }
                ]
            )

        ContinueToStep2 ->
            ( model
            , Effect.batch
                [ Effect.pushRoutePath Route.Path.BasketStep2
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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model.Model -> Model -> View Msg
view sharedModel model =
    let
        isBasketNotEmpty : Bool
        isBasketNotEmpty =
            sharedModel.userBasket
                |> List.isEmpty
                |> not

        isUserLoggedIn : Bool
        isUserLoggedIn =
            case sharedModel.user of
                Just _ ->
                    True

                Nothing ->
                    False
    in
    { title = "Basket"
    , attributes = []
    , element =
        column
            [ width fill
            , height fill
            , spacing 50
            ]
            [ Components.Basket.viewTrail { basketStep = 1 }
            , row [ centerX, spacing 5 ]
                [ Components.Page.Header.view "BASKET"
                , viewBasketClearBtn
                ]
            , if isBasketNotEmpty then
                viewBasketItems sharedModel.userBasket

              else
                row [ centerX, Font.italic ] [ text "Your basket is empty." ]
            , if isBasketNotEmpty then
                Components.Basket.viewBasketTotal sharedModel.userBasket

              else
                none
            , if isBasketNotEmpty && isUserLoggedIn then
                Components.Basket.viewBasketProceedBtn { onPress = Just ContinueToStep2, labelText = "Continue" }

              else
                row [ centerX, Font.italic ] [ text "Log in to proceed to Payment." ]
            ]
    }


viewBasketItems : List Shared.Model.BasketItem -> Element Msg
viewBasketItems userBasket =
    column [ spacing 20 ] <|
        List.map
            (\{ id, name, price, qty } ->
                row
                    [ spacing 5

                    -- , below <|
                    --     el
                    --         [ mouseOver [ alpha 1 ]
                    --         , alpha 0
                    --         , Font.size 14
                    --         , Font.color Colors.shadowedSteel
                    --         ]
                    --     <|
                    --         text "The moon icon is purely decorative. You Are Not Purchasing the Earth's Moon!! ☝"
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



-- BTNS


viewBasketIncrementItemBtn : { id : Int } -> Element Msg
viewBasketIncrementItemBtn { id } =
    Input.button
        [ Background.color Design.Colors.secondary
        , Font.color Design.Colors.white
        , width (px 20)
        , height (px 20)
        , Font.center
        , Border.rounded 5
        ]
        { onPress = Just (IncrementItem { id = id }), label = text "+" }


viewBasketDecrementItemBtn : { id : Int, qty : Int } -> Element Msg
viewBasketDecrementItemBtn { id, qty } =
    Input.button
        [ Background.color Design.Colors.ternary
        , Font.color Design.Colors.secondary
        , width (px 20)
        , height (px 20)
        , Border.rounded 5
        ]
        { onPress =
            if qty > 0 then
                Just (DecrementItem { id = id })

            else
                Nothing
        , label = el [ centerX, centerY ] <| text "-"
        }


viewBasketClearBtn : Element Msg
viewBasketClearBtn =
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
