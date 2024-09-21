module Pages.Login exposing (Model, Msg, page)

import Api.Login exposing (ResponseData)
import Components.Form
import Components.Form.Input exposing (Field(..))
import Components.Form.SubmitBtn
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import FlatColors.TurkishPalette as Colors
import Html
import Http
import Layouts
import Page exposing (Page)
import Result exposing (Result)
import Route exposing (Route)
import Shared
import Utils
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page sharedModel route =
    Page.new
        { init = init
        , update = update sharedModel
        , subscriptions = subscriptions
        , view = view
        }
        |> Page.withLayout (\model -> Layouts.Guest {})



-- INIT


type alias Model =
    { email : String
    , password : String
    , emailNotification : Result String String
    , passwordNotification : Result String String
    , errorNotification : Maybe String
    , isSubmitting : Bool
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { email = "user@world.free"
      , password = ""
      , emailNotification = Err ""
      , passwordNotification = Err ""
      , errorNotification = Nothing
      , isSubmitting = False
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = SaveEmail String
    | SavePassword String
    | Submit
    | ApiResponse (Result Http.Error ResponseData)


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update sharedModel msg model =
    case msg of
        SaveEmail string ->
            ( { model
                | email = string
                , emailNotification =
                    if String.contains "@" string && String.contains "." string then
                        Err "Email must contain '@' and '.' characters."

                    else
                        Ok "Ok 👌"
              }
            , Effect.none
            )

        SavePassword string ->
            ( { model
                | password = string
                , passwordNotification =
                    if String.length string < 8 then
                        Err "Password must be at least 8 characters long. Both passwords must be the same."

                    else
                        Ok "Ok 👌"
              }
            , Effect.none
            )

        Submit ->
            ( { model
                | isSubmitting = True
                , errorNotification = Nothing
              }
            , Api.Login.post
                { onResponse = ApiResponse
                , email = model.email
                , apiUrl = sharedModel.apiUrl
                }
            )

        ApiResponse (Ok { token, user }) ->
            ( { model
                | errorNotification = Nothing
                , isSubmitting = False
              }
            , Effect.login { token = token, user = user }
            )

        ApiResponse (Err err) ->
            case err of
                _ ->
                    ( { model
                        | errorNotification = Just "Something went wrong. Please try again."
                        , isSubmitting = False
                      }
                    , Effect.none
                    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Login"
    , attributes = []
    , element =
        column [ centerX, centerY ]
            [ viewErrorNotification model.errorNotification
            , Components.Form.init
                { element = column
                , attributes = [ width (px 600), spacing 10 ]
                , children =
                    [ row
                        [ Font.size 22, centerX, paddingXY 0 0 ]
                        [ text "LOGIN" ]

                    -- USERNAME
                    , Components.Form.Input.init
                        { field = Email
                        , labelText = "email"
                        , attributes = []
                        , value = model.email
                        , msg = SaveEmail
                        }
                    , Components.Form.viewNotification model.emailNotification

                    -- PASSWORD
                    -- , Components.Form.Input.init
                    --     { field = NewPassword
                    --     , labelText = "password"
                    --     , attributes = []
                    --     , value = model.password
                    --     , msg = SavePassword
                    --     }
                    -- , Components.Form.viewNotification model.passwordNotification
                    -- SUBMIT
                    , Components.Form.SubmitBtn.init
                        { labelText = "Continue"
                        , attributes = []
                        , maybeMsg = Just Submit
                        , isSubmitting = model.isSubmitting
                        }
                    ]
                }
            ]
    }


viewErrorNotification : Maybe String -> Element msg
viewErrorNotification mbErrorNotification =
    case mbErrorNotification of
        Just err ->
            row [ Background.color Colors.redOrange, width fill, padding 10 ] [ text err ]

        Nothing ->
            none
