module Pages.BasketStep3 exposing (Model, Msg, page)

import Components.Basket
import Components.Page.Header
import Design.Colors
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
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
    = Pay


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        Pay ->
            ( model
            , Effect.batch
                [ Effect.toggleModal
                    { modal = Just Shared.Model.PayConfirmation }
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
            [ Components.Basket.viewTrail { basketStep = 3 }
            , row [ centerX, spacing 5 ]
                [ Components.Page.Header.view "BASKET"
                ]
            , Components.Basket.viewBasketTotal sharedModel.userBasket
            , row [ centerX, spacing 5 ]
                [ Components.Basket.viewBasketBackBtn { to = Route.Path.BasketStep2 }
                , viewBasketPayBtn
                ]
            ]
    }


viewBasketPayBtn : Element Msg
viewBasketPayBtn =
    row
        [ centerX
        , Background.color Design.Colors.secondary
        , Font.size 18
        , padding 10
        , Border.rounded 5
        ]
        [ Input.button []
            { onPress = Just Pay, label = text "Payment 💰" }
        ]
