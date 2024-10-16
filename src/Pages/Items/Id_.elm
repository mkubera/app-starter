module Pages.Items.Id_ exposing (Model, Msg, page)

import Api.Basket
import Components.Link
import Components.Page.Header
import Design.Colors
import Design.Typography
import Dict
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Http
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared exposing (dummyCategory, dummyItem)
import Shared.Model
import Utils
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
    { isSubmitting : Bool }


init : Shared.Model.Model -> () -> ( Model, Effect Msg )
init sharedModel () =
    ( { isSubmitting = False }
    , Effect.none
    )



-- UPDATE


type Msg
    = AddToBasket { itemId : Int }
    | ApiAddToBasketResponse (Result Http.Error Api.Basket.AddToBasketResponseData)


update : Shared.Model.Model -> Msg -> Model -> ( Model, Effect Msg )
update sharedModel msg model =
    case msg of
        AddToBasket { itemId } ->
            case sharedModel.user of
                Just _ ->
                    ( { model | isSubmitting = True }
                    , Api.Basket.add
                        { onResponse = ApiAddToBasketResponse
                        , itemId = itemId
                        , apiUrl = sharedModel.apiUrl
                        }
                    )

                Nothing ->
                    let
                        newBasketItem =
                            Utils.basketItemFromItemId
                                { itemId = itemId
                                , items = sharedModel.items
                                , userBasket = sharedModel.userBasket
                                }
                    in
                    ( model, Effect.addToBasket { basketItem = newBasketItem } )

        ApiAddToBasketResponse (Ok { basketItem }) ->
            ( { model | isSubmitting = False }
            , Effect.addToBasket { basketItem = basketItem }
            )

        ApiAddToBasketResponse (Err _) ->
            ( { model | isSubmitting = False }
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
        item : Shared.Model.Item
        item =
            sharedModel.items
                |> List.filter (\{ id } -> id == itemId)
                |> List.head
                |> Maybe.withDefault dummyItem

        itemCategory : Shared.Model.Category
        itemCategory =
            sharedModel.categories
                |> List.filter (\{ id } -> id == item.categoryId)
                |> List.head
                |> Maybe.withDefault dummyCategory

        urlWithQueryParams =
            Route.toString
                { path = Route.Path.Items
                , query =
                    Dict.fromList
                        [ ( "categoryId", String.fromInt itemCategory.id )
                        , ( "categoryName", itemCategory.name )
                        ]
                , hash = Nothing
                }
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
            [ link
                [ Font.size 14
                , centerX
                , Font.color Design.Colors.secondary
                , Background.color Design.Colors.primary
                , padding 10
                , Border.rounded 5
                ]
                { url = urlWithQueryParams
                , label = text <| "<- back to " ++ itemCategory.name
                }
            , viewItem item sharedModel.userBasket model.isSubmitting
            ]
    }


viewItem : Shared.Model.Item -> List Shared.Model.UserItem -> Bool -> Element Msg
viewItem item userBasket isSubmitting =
    column
        [ width (px 620)
        , spacingXY 10 10
        ]
        [ -- IMAGE
          row
            [ centerX
            , centerY
            ]
            [ image [ height (px 420) ]
                { src = "https://i.discogs.com/NtYmZPWZ21Wz9gVhsQzh8M3lXbvkCO1zKcSPbMW5cdo/rs:fit/g:sm/q:90/h:480/w:480/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTExNTgx/NzE0LTE2NTc0MTY1/OTItMzUxMS5qcGVn.jpeg"
                , description = ""
                }
            ]

        -- PRICE
        , row
            [ centerX
            , centerY
            , Design.Typography.sizes.itemId.description
            ]
            [ text ("€" ++ String.fromFloat item.price) ]

        -- NAME
        , row [ centerX, centerY, Design.Typography.sizes.itemId.name, Font.bold ]
            [ text item.name
            ]

        -- QTY
        , row
            [ centerX
            , centerY
            , Font.size 14
            ]
            [ text (String.fromInt item.qty ++ " left") ]

        -- DESCRIPTION
        , paragraph
            [ centerX
            , centerY
            , Design.Typography.sizes.itemId.description
            , Design.Typography.fonts.secondary
            ]
            [ text item.description
            ]
        , column
            [ paddingXY 0 20
            , spacing 10
            , width fill
            ]
            [ -- ADD TO BASKET BTN
              viewAddToBasket
                { id = item.id
                , userBasket = userBasket
                , isSubmitting = isSubmitting
                }
            ]
        ]


viewAddToBasket :
    { id : Int
    , userBasket : List Shared.Model.BasketItem
    , isSubmitting : Bool
    }
    -> Element Msg
viewAddToBasket { id, userBasket, isSubmitting } =
    let
        itemAlreadyInBasket =
            List.any (\basketItem -> basketItem.itemId == id) userBasket
    in
    if itemAlreadyInBasket then
        row
            [ Font.italic
            , Font.color Design.Colors.primary
            , Font.size 18
            , centerX
            , alpha 0.8
            ]
            [ text "in your 🛒" ]

    else
        row
            [ centerX
            ]
            [ Input.button
                [ Font.color Design.Colors.primary
                , padding 8
                , Background.color Design.Colors.secondary
                , Border.solid
                , Border.width 2
                , Border.rounded 5
                , mouseOver
                    [ Background.color (Design.Colors.secondary |> Design.Colors.setAlpha 0)
                    , Font.color Design.Colors.secondary
                    , Border.color Design.Colors.secondary
                    ]
                ]
                { onPress =
                    if isSubmitting then
                        Nothing

                    else
                        Just (AddToBasket { itemId = id })
                , label = text "add to basket"
                }
            ]
