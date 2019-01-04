module Story exposing
    ( Story
    , getImagesToPreload
    , getManifest
    , getRules
    , getStartingNarrative
    , getStartingState
    , getTitle
    , parser
    , toStory
    , toUrlString
    )

import Dict exposing (Dict)
import Engine exposing (..)
import Story.AllStories exposing (allStories)
import Story.Components exposing (..)
import Story.HowJaraldandTenzinMet.StoryInfo as HowJaraldandTenzinMet
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


type Story
    = Story StoryInfo


toStory : StoryInfo -> Story
toStory =
    Story


parser : Parser (Story -> a) a
parser =
    let
        toParser storyInfo =
            Parser.map (Story storyInfo) (s storyInfo.slug)
    in
    oneOf (List.map toParser allStories)


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


getImagesToPreload : Story -> List String
getImagesToPreload story =
    case story of
        Story { imagesToPreLoad } ->
            imagesToPreLoad
