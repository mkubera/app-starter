module Design.Typography exposing (fonts, sizes)

import Element exposing (..)
import Element.Font as Font


type alias Sizes aligned msg =
    { h1 : Attr aligned msg
    , h2 : Attr aligned msg
    , h3 : Attr aligned msg
    , paragraph : Attr aligned msg
    , button : Attr aligned msg
    , logo : Attr aligned msg
    , page :
        { header : Attr aligned msg }
    , basket :
        { buttons : Attr aligned msg
        , item : Attr aligned msg
        , total : Attr aligned msg
        }
    , itemId :
        { name : Attr aligned msg
        , description : Attr aligned msg
        , price : Attr aligned msg
        }
    }


sizes : Sizes aligned msg
sizes =
    { h1 = Font.size 32
    , h2 = Font.size 28
    , h3 = Font.size 24
    , paragraph = Font.size 22
    , button = Font.size 20
    , logo = Font.size 24
    , page =
        { header = Font.size 32 }
    , basket =
        { buttons = Font.size 20
        , item = Font.size 20
        , total = Font.size 26
        }
    , itemId =
        { name = Font.size 26
        , description = Font.size 22
        , price = Font.size 20
        }
    }


type alias Fonts msg msg1 msg2 =
    { logo : Attribute msg
    , primary : Attribute msg1
    , secondary : Attribute msg2
    }


fonts : Fonts msg msg1 msg2
fonts =
    { primary = Font.family [ Font.typeface "Open Sans", Font.sansSerif ]
    , secondary = Font.family [ Font.typeface "Afacad Flux", Font.sansSerif ]
    , logo = Font.family [ Font.typeface "Rubik Mono One", Font.monospace ]
    }
