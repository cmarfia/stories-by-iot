port module Port exposing (fromJavaScript, toJavaScript)

import Json.Decode
import Json.Encode


port toJavaScript : Json.Encode.Value -> Cmd msg


port fromJavaScript : (Json.Decode.Value -> msg) -> Sub msg
