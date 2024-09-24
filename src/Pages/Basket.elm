module Pages.Basket exposing (Model, Msg, page)

import Components.Page.Header
import Effect exposing (Effect)
import Element exposing (..)
import Element.Font as Font
import FlatColors.TurkishPalette as Colors
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
        , update = update
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
            , viewBasket sharedModel.userBasket
            ]
    }


viewBasket userBasket =
    -- TODO:
    -- 1) UI basket (U+D)
    column [ spacing 20 ] <|
        List.map
            (\{ id, name, price } ->
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
                    [ text <| "[id:" ++ String.fromInt id ++ "]🌗 "
                    , text name
                    , text (" (€" ++ String.fromFloat price ++ ")")
                    ]
            )
            userBasket
