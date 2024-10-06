module Pages.BasketStep2 exposing (Model, Msg, page)

import Components.Basket
import Components.Page.Header
import Design.Colors
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FlatColors.TurkishPalette as Colors
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
        , update = update
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
    = ContinueToStep3


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ContinueToStep3 ->
            ( model
            , Effect.batch
                [ Effect.pushRoutePath Route.Path.BasketStep3
                ]
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model.Model -> Model -> View Msg
view sharedModel model =
    { title = "Basket"
    , attributes = []
    , element =
        column
            [ width fill
            , height fill
            , spacing 50
            ]
            [ Components.Basket.viewTrail { basketStep = 2 }
            , row [ centerX, spacing 5 ]
                [ Components.Page.Header.view "BASKET"
                ]
            , viewBasketItems sharedModel.userBasket
            , Components.Basket.viewBasketTotal sharedModel.userBasket
            , row [ centerX, spacing 5 ]
                [ Components.Basket.viewBasketBackBtn { to = Route.Path.Basket }
                , Components.Basket.viewBasketProceedBtn { onPress = Just ContinueToStep3, labelText = "Continue" }
                ]
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
                    --         , Font.color Design.Colors.primary
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
                    ]
            )
            userBasket
