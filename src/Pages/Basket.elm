module Pages.Basket exposing (Model, Msg, page)

import Components.Page.Header
import Effect exposing (Effect)
import Element exposing (..)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Shared.Model
import View exposing (View)



-- TODO:
-- 1) UI basket (RUD)


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
    let
        userBasket =
            List.map
                (\itemId ->
                    List.filter (\item -> item.id == itemId) sharedModel.items
                        |> List.head
                        |> Maybe.withDefault Shared.dummyItem
                )
                sharedModel.userBasket
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
            [ Components.Page.Header.view "BASKET"
            , viewBasket userBasket
            ]
    }


viewBasket userBasket =
    column [] <|
        List.map
            (\userBasketItem ->
                row
                    [ onLeft (text "⚫ ")
                    ]
                    [ text userBasketItem.name
                    ]
            )
            userBasket
