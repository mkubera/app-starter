module Components.Calendar exposing (..)


type alias Calendar =
    { jan : Month
    , feb : Month
    , mar : Month
    , apr : Month
    , may : Month
    , jun : Month
    , jul : Month
    , aug : Month
    , sep : Month
    , oct : Month
    , nov : Month
    , dec : Month
    }


type alias Month =
    List Day



-- https://ellie-app.com/sjNHDXzmMd5a1


type alias Day =
    { id : Int
    , slots : List Slot
    }


type alias Slot =
    { id : Int
    }


init : Calendar
init =
    -- year 2024
    { jan = initMonth 31
    , feb = initMonth 29
    , mar = initMonth 31
    , apr = initMonth 30
    , may = initMonth 31
    , jun = initMonth 30
    , jul = initMonth 31
    , aug = initMonth 31
    , sep = initMonth 30
    , oct = initMonth 31
    , nov = initMonth 30
    , dec = initMonth 31
    }


initMonth : Int -> Month
initMonth daysInMonth =
    List.range 1 daysInMonth
        |> List.map initDay


initDay : Int -> Day
initDay day =
    { id = day
    , slots =
        List.range 1 48
            |> List.map initSlot
    }


initSlot : Int -> Slot
initSlot n =
    { id = n }
