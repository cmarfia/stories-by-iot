module Flags exposing (Flags, StoryInfo, decode)

import Json.Decode as Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode



-- Types


type alias Flags =
    { library : List StoryInfo
    }


type alias StoryInfo =
    { id : String
    , title : String
    , slug : String
    , coverImage : String
    }



-- Decoders


decode : Decoder Flags
decode =
    Decode.succeed Flags
        |> required "library" (list decodeStoryInfo)


decodeStoryInfo : Decoder StoryInfo
decodeStoryInfo =
    Decode.succeed StoryInfo
        |> required "id" string
        |> required "title" string
        |> required "slug" string
        |> required "cover" string
