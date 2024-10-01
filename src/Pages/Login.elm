module Pages.Login exposing (Model, Msg, page)

import Api.Login
import Components.Form
import Components.Form.Input exposing (Field(..))
import Components.Form.SubmitBtn
import Components.Page.Header
import Dict
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import FlatColors.TurkishPalette as Colors
import Http
import Layouts
import Page exposing (Page)
import Result exposing (Result)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page sharedModel route =
    Page.new
        { init = init
        , update = update sharedModel
        , subscriptions = subscriptions
        , view = view
        }
        |> Page.withLayout (\model -> Layouts.Main_Guest {})



-- INIT


type alias Model =
    { email : String
    , password : String
    , emailNotification : Result String String
    , passwordNotification : Result String String
    , isSubmitting : Bool
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { email = "user@world.free"
      , password = ""
      , emailNotification = Err ""
      , passwordNotification = Err ""
      , isSubmitting = False
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = SaveEmail String
    | SavePassword String
    | Submit
    | ApiResponse (Result Http.Error ())


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
              }
            , Api.Login.post
                { onResponse = ApiResponse
                , email = model.email
                , apiUrl = sharedModel.apiUrl
                }
            )

        ApiResponse (Ok _) ->
            ( { model
                | isSubmitting = False
              }
            , Effect.batch
                [ Effect.clearErrorNotification
                , Effect.saveSuccessNotification
                    { successString = "A magic token was sent to your email address. Copy it and paste into the field below." }
                , Effect.pushRoute
                    { path = Route.Path.LoginMagicToken
                    , query = Dict.empty
                    , hash = Nothing
                    }
                ]
            )

        ApiResponse (Err err) ->
            case err of
                _ ->
                    ( { model
                        | isSubmitting = False
                      }
                    , Effect.saveErrorNotification
                        { errString = "Something went wrong. Please try again." }
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
        column
            [ centerX
            , centerY
            , width <| maximum 600 fill
            ]
            [ Components.Form.init
                { element = column
                , attributes = [ width <| maximum 600 fill, spacing 10 ]
                , children =
                    [ Components.Page.Header.view "LOGIN (part 1/2)"

                    -- USERNAME
                    , Components.Form.Input.init
                        { field = Email
                        , labelText = "email"
                        , attributes = [ width <| maximum 600 fill ]
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
