port module Port exposing (IncomingMsg(..), OutgoingMsg(..), decode, encode, fromJavaScript, toJavaScript)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required, resolve)
import Json.Encode as Encode


port toJavaScript : Encode.Value -> Cmd msg


port fromJavaScript : (Encode.Value -> msg) -> Sub msg


type OutgoingMsg
    = PreloadImages (List String)
    | Speak String


type IncomingMsg
    = ImagesLoaded
    | VoiceLoaded


encode : OutgoingMsg -> Encode.Value
encode msg =
    case msg of
        PreloadImages images ->
            Encode.object
                [ ( "command", Encode.string "PRELOAD_IMAGES" )
                , ( "data", Encode.list Encode.string images )
                ]
        
        Speak text ->
            Encode.object
                [ ( "command", Encode.string "SPEAK" )
                , ( "data", Encode.string text )
                ]


decode : Decoder IncomingMsg
decode =
    let
        decoder command =
            case command of
                "IMAGES_LOADED" ->
                    Decode.succeed ImagesLoaded
                
                "VOICE_LOADED" ->
                    Decode.succeed VoiceLoaded

                _ ->
                    Decode.fail "Invalid command received"
    in
    Decode.succeed decoder
        |> required "command" Decode.string
        |> resolve
