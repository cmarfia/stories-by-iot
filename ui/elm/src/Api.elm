module API exposing (getStory)

import Json.Decode exposing (Decoder)
import Url exposing (Url)
import Url.Builder exposing (absolute)
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http
import Story as Story exposing (Story)

getStory : String -> (WebData Story -> msg) -> Cmd msg
getStory storyId toMsg =
    get ["stories", storyId] toMsg Story.decode


get : List String -> (WebData a -> msg) -> Decoder a -> Cmd msg
get urlParts toMsg decoder =
    let
        url =
            Url.Builder.absolute ("api" :: "v1" :: urlParts) []
    in
    RemoteData.Http.getWithConfig RemoteData.Http.defaultConfig url toMsg decoder


