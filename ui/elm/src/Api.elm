module API exposing (getStoryById)

import Json.Decode exposing (Decoder)
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http exposing (defaultConfig, getWithConfig)
import Story as Story exposing (Story)
import Url exposing (Url)
import Url.Builder exposing (absolute)


getStoryById : String -> (WebData Story -> msg) -> Cmd msg
getStoryById storyId toMsg =
    absolute [ "api", "v1", "stories", storyId ] []
        |> get toMsg Story.decode


get : (WebData a -> msg) -> Decoder a -> String -> Cmd msg
get toMsg decoder url =
    getWithConfig defaultConfig url toMsg decoder
