module Story.Info exposing (Info, decode)

import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (required)


type alias Info =
    { id : String
    , title : String
    , slug : String
    , cover : String
    }


decode : Decoder Info
decode = 
    Decode.succeed Info
        |> required "id" string
        |> required "title" string
        |> required "slug" string
        |> required "cover" string
