module Pages.User.Profile exposing (Model, Msg, page)

import Api.User.Profile exposing (ResponseData)
import Auth
import Components.Form
import Components.Form.Input exposing (Field(..))
import Components.Form.SubmitBtn
import Components.Page.Header
import Effect exposing (Effect)
import Element exposing (..)
import Http
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Shared.Model
import View exposing (View)


page : Auth.User -> Shared.Model -> Route () -> Page Model Msg
page authUser sharedModel route =
    Page.new
        { init = init sharedModel
        , update = update authUser sharedModel
        , subscriptions = subscriptions
        , view = view sharedModel
        }
        |> Page.withLayout (\model -> Layouts.Main_User {})



-- INIT


type alias Model =
    { email : String
    , emailNotification : Result String String
    , isSubmitting : Bool
    }


init : Shared.Model.Model -> () -> ( Model, Effect Msg )
init sharedModel () =
    ( { email =
            sharedModel.user
                |> Maybe.withDefault Shared.dummyUser
                |> .email
      , emailNotification = Err ""
      , isSubmitting = False
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = SaveEmail String
    | Submit
    | ApiResponse (Result Http.Error ResponseData)


update : Auth.User -> Shared.Model.Model -> Msg -> Model -> ( Model, Effect Msg )
update _ sharedModel msg model =
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

        Submit ->
            ( { model
                | isSubmitting = True
              }
            , Api.User.Profile.put
                { onResponse = ApiResponse
                , email = model.email
                , apiUrl = sharedModel.apiUrl
                , token = sharedModel.token |> Maybe.withDefault ""
                }
            )

        ApiResponse (Ok user) ->
            ( { model
                | isSubmitting = False
              }
            , Effect.updateUser { user = user }
            )

        ApiResponse (Err _) ->
            ( { model
                | isSubmitting = False
              }
            , Effect.batch
                [ Effect.clearSuccessNotification
                , Effect.saveErrorNotification
                    { errString = "Something went wrong. Please try again." }
                ]
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model.Model -> Model -> View Msg
view sharedModel model =
    { title = "Profile"
    , attributes = []
    , element =
        viewEdit model
    }


viewEdit model =
    column [ centerX, centerY ]
        [ Components.Form.init
            { element = column
            , attributes =
                [ width (px 600)
                , spacing 10
                ]
            , children =
                [ Components.Page.Header.view "PROFILE"

                -- EMAIL
                , Components.Form.Input.init
                    { field = Email
                    , labelText = "email"
                    , attributes = []
                    , value = model.email
                    , msg = SaveEmail
                    }
                , Components.Form.viewNotification model.emailNotification

                -- SUBMIT
                , Components.Form.SubmitBtn.init
                    { labelText = "Update"
                    , attributes = []
                    , maybeMsg = Just Submit
                    , isSubmitting = model.isSubmitting
                    }
                ]
            }
        ]
