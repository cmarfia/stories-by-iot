module Story exposing
    ( Story
    , getManifest
    , getRules
    , getStartingNarrative
    , getStartingState
    , getTitle
    , parser
    , toUrlString
    )

import Dict exposing (Dict)
import Engine exposing (..)
import Story.Components exposing (..)
import Story.HowJaraldandTenzinMet.StoryInfo as HowJaraldandTenzinMet
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


type Story
    = Story StoryInfo


parser : Parser (Story -> a) a
parser =
    oneOf
        [ Parser.map (Story HowJaraldandTenzinMet.storyInfo) (s HowJaraldandTenzinMet.storyInfo.slug)
        ]


toUrlString : Story -> String
toUrlString story =
    case story of
        Story storyInfo ->
            storyInfo.slug


getTitle : Story -> String
getTitle story =
    case story of
        Story { title } ->
            title


getManifest : Story -> Manifest
getManifest story =
    case story of
        Story { manifest } ->
            manifest


getRules : Story -> Dict String Components
getRules story =
    case story of
        Story { rules } ->
            rules


getStartingState : Story -> List Engine.ChangeWorldCommand
getStartingState story =
    case story of
        Story { startingState } ->
            startingState


getStartingNarrative : Story -> Snippet
getStartingNarrative story =
    case story of
        Story { startingNarrative } ->
            startingNarrative
