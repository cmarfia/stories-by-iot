module Flags exposing (Flags, decode)

import Json.Decode as Decode exposing (Decoder, list)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Story.Info exposing (Info)


type alias Flags =
    { library : List Info
    }

 
decode : Decoder Flags
decode =
    Decode.succeed Flags
        |> required "library" (list Story.Info.decode)