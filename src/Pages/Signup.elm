module Pages.Signup exposing (Model, Msg, page)

import Api.Signup exposing (ResponseData)
import Components.Form
import Components.Form.Input exposing (Field(..))
import Components.Form.SubmitBtn
import Dict
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
import Route exposing (Route)
import Route.Path
import Shared
import Shared.Model
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
    , password2 : String
    , emailNotification : Result String String
    , passwordNotification : Result String String
    , password2Notification : Result String String
    , isSubmitting : Bool
    , errorNotification : Maybe String
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { email = "user@world.free"
      , password = ""
      , password2 = ""
      , emailNotification = Err ""
      , passwordNotification = Err ""
      , password2Notification = Err ""
      , isSubmitting = False
      , errorNotification = Nothing
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = SaveEmail String
      -- | SavePassword String
      -- | SavePassword2 String
    | Submit
    | ApiResponse (Result Http.Error ResponseData)


update : Shared.Model.Model -> Msg -> Model -> ( Model, Effect Msg )
update sharedModel msg model =
    case msg of
        SaveEmail string ->
            ( { model
                | email = string
                , emailNotification =
                    if String.contains "@" string && String.contains "." string then
                        Ok "Ok 👌"

                    else
                        Err "Email must contain '@' and '.' characters."
              }
            , Effect.none
            )

        -- SavePassword string ->
        --     ( { model
        --         | password = string
        --         , passwordNotification =
        --             if
        --                 (String.length string < 8)
        --                     || (string /= model.password2)
        --             then
        --                 Err "Password must be at least 8 characters long. Both passwords must be the same."
        --             else
        --                 Ok "Ok 👌"
        --       }
        --     , Effect.none
        --     )
        -- SavePassword2 string ->
        --     ( { model
        --         | password2 = string
        --         , password2Notification =
        --             if
        --                 (String.length string < 8)
        --                     || (string /= model.password)
        --             then
        --                 Err "Password must be at least 8 characters long. Both passwords must be the same."
        --             else
        --                 Ok "Ok 👌"
        --       }
        --     , Effect.none
        --     )
        Submit ->
            ( { model
                | isSubmitting = True
                , errorNotification = Nothing
              }
            , Api.Signup.post
                { onResponse = ApiResponse
                , email = model.email
                , apiUrl = sharedModel.apiUrl
                }
            )

        ApiResponse (Ok _) ->
            ( { model
                | errorNotification = Nothing
                , isSubmitting = False
              }
            , Effect.pushRoute
                { path = Route.Path.Login
                , query = Dict.empty
                , hash = Nothing
                }
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
    { title = "Signup"
    , attributes = []
    , element =
        column [ centerX, centerY ]
            [ Components.Form.init
                { element = column
                , attributes =
                    [ width (px 600)
                    , spacing 10
                    ]
                , children =
                    [ viewErrorNotification model.errorNotification
                    , row
                        [ Font.size 22
                        , centerX
                        ]
                        [ text "SIGNUP" ]

                    -- , row
                    --     [ centerX
                    --     , Font.color Colors.shadowedSteel
                    --     , Font.italic
                    --     , Font.size 14
                    --     , Utils.paddingBottom 20
                    --     ]
                    --     [ text "Fields marked * are required." ]
                    -- EMAIL
                    , Components.Form.Input.init
                        { field = Email

                        -- , labelText = "email*"
                        , labelText = "email"
                        , attributes = []
                        , value = model.email
                        , msg = SaveEmail
                        }
                    , Components.Form.viewNotification model.emailNotification

                    -- PASSWORD
                    -- , Components.Form.Input.init
                    --     { field = NewPassword
                    --     , labelText = "password*"
                    --     , attributes = []
                    --     , value = model.password
                    --     , msg = SavePassword
                    --     }
                    -- , Components.Form.viewNotification model.passwordNotification
                    -- -- PASSWORD2
                    -- , Components.Form.Input.init
                    --     { field = NewPassword
                    --     , labelText = "password (repeat)*"
                    --     , attributes = []
                    --     , value = model.password2
                    --     , msg = SavePassword2
                    --     }
                    -- , Components.Form.viewNotification model.password2Notification
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
