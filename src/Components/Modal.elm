module Components.Modal exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FlatColors.TurkishPalette as Colors
import Shared.Model


view :
    { sharedModel : Shared.Model.Model
    , onConfirm : msg
    , onClose : msg
    }
    -> Element msg
view { sharedModel, onConfirm, onClose } =
    case sharedModel.modal of
        Just modal ->
            column
                [ centerX
                , centerY
                , width (px 600)
                , padding 50
                , Background.color Colors.shadowedSteel
                , Font.color (rgb255 255 255 255)
                , Border.rounded 5
                ]
                [ case modal of
                    Shared.Model.PayConfirmation ->
                        column [ centerX, spacing 20 ]
                            [ row [ centerX, Font.size 24 ] [ text "Proceed to checkout?" ]
                            , row [ spacing 5 ]
                                [ Input.button
                                    [ Background.color Colors.weirdGreen
                                    , Font.color Colors.shadowedSteel
                                    , padding 10
                                    , Border.rounded 5
                                    ]
                                    { onPress = Just onConfirm
                                    , label = text "Yes"
                                    }
                                , Input.button
                                    [ Background.color Colors.mandarinSorbet
                                    , Font.color Colors.shadowedSteel
                                    , padding 10
                                    , Border.rounded 5
                                    ]
                                    { onPress = Just onClose
                                    , label = text "No, I want to shop some more"
                                    }
                                ]
                            ]
                    Shared.Model.ClearBasketConfirmation ->
                        column [ centerX, spacing 20 ]
                            [ row [ centerX, Font.size 24 ] [ text "Do you want to empty your Basket?" ]
                            , row [ spacing 5 ]
                                [ Input.button
                                    [ Background.color Colors.weirdGreen
                                    , Font.color Colors.shadowedSteel
                                    , padding 10
                                    , Border.rounded 5
                                    ]
                                    { onPress = Just onConfirm
                                    , label = text "Yes"
                                    }
                                , Input.button
                                    [ Background.color Colors.mandarinSorbet
                                    , Font.color Colors.shadowedSteel
                                    , padding 10
                                    , Border.rounded 5
                                    ]
                                    { onPress = Just onClose
                                    , label = text "No, I want to shop some more"
                                    }
                                ]
                            ]

                -- , Input.button []
                --     { onPress = Just onClose
                --     , label = text "x"
                --     }
                ]

        Nothing ->
            Element.none
