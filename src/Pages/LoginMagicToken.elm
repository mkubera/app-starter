module Pages.LoginMagicToken exposing (Model, Msg, page)

import Api.LoginMagicToken exposing (ResponseData)
import Components.Form
import Components.Form.Input exposing (Field(..))
import Components.Form.SubmitBtn
import Components.Page.Header
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
    { magicToken : String
    , magicTokenNotification : Result String String
    , isSubmitting : Bool
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { magicToken = "2MDZQR"
      , magicTokenNotification = Err ""
      , isSubmitting = False
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = SaveMagicToken String
    | Submit
    | ApiResponse (Result Http.Error ResponseData)


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update sharedModel msg model =
    case msg of
        SaveMagicToken string ->
            ( { model
                | magicToken = string
                , magicTokenNotification =
                    if String.length string /= 6 then
                        Err "This does not look like one of our magic tokens."

                    else
                        Ok "Ok 👌"
              }
            , Effect.none
            )

        Submit ->
            ( { model
                | isSubmitting = True
              }
            , Effect.batch
                [ Effect.clearSuccessNotification
                , Effect.clearErrorNotification
                , Api.LoginMagicToken.post
                    { onResponse = ApiResponse
                    , magicToken = model.magicToken
                    , apiUrl = sharedModel.apiUrl
                    }
                ]
            )

        ApiResponse (Ok { token, user }) ->
            ( { model
                | isSubmitting = False
              }
            , Effect.batch
                [ Effect.clearErrorNotification
                , Effect.saveSuccessNotification
                    { successString = "You have successfully logged in. Welcome! 🤝" }
                , Effect.login { token = token, user = user }
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
    { title = "Magic Token Login"
    , attributes = []
    , element =
        column [ centerX, centerY ]
            [ Components.Form.init
                { element = column
                , attributes = [ width (px 600), spacing 10 ]
                , children =
                    [ Components.Page.Header.view "LOGIN (part 2/2)"

                    -- MAGIC TOKEN
                    , Components.Form.Input.init
                        { field = Text
                        , labelText = "magic token"
                        , attributes = []
                        , value = model.magicToken
                        , msg = SaveMagicToken
                        }
                    , Components.Form.viewNotification model.magicTokenNotification

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
