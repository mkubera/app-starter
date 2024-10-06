module Layouts.Main exposing (Model, Msg, Props, layout)

import Components.Modal as Modal
import Design.Colors
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Input as Input exposing (button)
import FlatColors.TurkishPalette as Colors
import Layout exposing (Layout)
import Route exposing (Route)
import Shared
import Shared.Model
import View exposing (View)


type alias Props =
    {}


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout props sharedModel route =
    Layout.new
        { init = init
        , update = update sharedModel
        , view = view sharedModel
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = CloseErrorNotification
    | CloseSuccessNotification
    | ToggleModal (Maybe Shared.Model.Modal)
    | ConfirmModal


update : Shared.Model.Model -> Msg -> Model -> ( Model, Effect Msg )
update sharedModel msg model =
    case msg of
        CloseErrorNotification ->
            ( model
            , Effect.clearErrorNotification
            )

        CloseSuccessNotification ->
            ( model
            , Effect.clearSuccessNotification
            )

        ToggleModal mbModal ->
            ( {}
            , Effect.batch
                [ Effect.toggleModal { modal = mbModal }
                ]
            )

        ConfirmModal ->
            ( {}
            , Effect.batch
                [ case sharedModel.modal of
                    Just Shared.Model.PayConfirmation ->
                        Effect.saveSuccessNotification
                            { successString = "TODO: need to do something upon Payment Confirmation(!)" }

                    Just Shared.Model.ClearBasketConfirmation ->
                        Effect.clearBasket

                    Nothing ->
                        Effect.none
                , Effect.toggleModal { modal = Nothing }
                ]
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model.Model -> { toContentMsg : Msg -> contentMsg, content : View contentMsg, model : Model } -> View contentMsg
view sharedModel { toContentMsg, model, content } =
    { title = content.title ++ " | App Starter"
    , attributes =
        [ Background.color (Design.Colors.ternary |> Design.Colors.setAlpha 0.22)
        ]
    , element =
        column
            [ width fill
            , height fill

            -- MODAL
            , inFront
                (Modal.view
                    { sharedModel = sharedModel
                    , onConfirm = ConfirmModal
                    , onClose = ToggleModal Nothing
                    }
                    |> Element.map toContentMsg
                )
            ]
            [ viewSuccessNotification sharedModel.successNotification |> Element.map toContentMsg
            , viewErrorNotification sharedModel.errorNotification |> Element.map toContentMsg
            , content.element
            ]
    }


viewSuccessNotification : Maybe String -> Element Msg
viewSuccessNotification mbSuccessNotification =
    case mbSuccessNotification of
        Just err ->
            row
                [ Background.color Colors.weirdGreen
                , width fill
                , padding 10
                , spaceEvenly
                ]
                [ text err
                , button [] { onPress = Just CloseSuccessNotification, label = text "x" }
                ]

        Nothing ->
            none


viewErrorNotification : Maybe String -> Element Msg
viewErrorNotification mbErrorNotification =
    case mbErrorNotification of
        Just err ->
            row
                [ Background.color Colors.redOrange
                , width fill
                , padding 10
                , spaceEvenly
                ]
                [ text err
                , Input.button [] { onPress = Just CloseErrorNotification, label = text "x" }
                ]

        Nothing ->
            none
