module Flags exposing (Flags, decode)

import Json.Decode as Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Story



-- Types


type alias Flags =
    { stories : List Story.Info
    }



-- Decoders


decode : Decoder Flags
decode =
    Decode.succeed Flags
        |> required "library" (list Story.decodeInfo)
