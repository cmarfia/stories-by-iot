module Story exposing
    ( Manifest
    , Narrative
    , Story
    , getCover
    , getImagesToPreload
    , getManifest
    , getRules
    , getSlug
    , getStartingNarrative
    , getStartingState
    , getTitle
    , parser
    )

import Dict exposing (Dict)
import Engine exposing (..)
import Story.Components exposing (..)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


type Story
    = Story FullStory


type alias Manifest =
    { items : List Entity
    , characters : List Entity
    , locations : List Entity
    }


type alias FullStory =
    { id : String
    , title : String
    , slug : String
    , cover : String
    , manifest : Manifest
    , startingNarrative : Narrative
    , startingState : List Engine.ChangeWorldCommand
    , rules : Dict String Components
    , imagesToPreLoad : List String
    }


type alias Narrative =
    { interactableId : String
    , narrative : String
    , audio : Maybe String
    }


new : FullStory -> Story
new story =
    Story story


parser : Parser (Story -> a) a
parser =
    let
        toParser story =
            Parser.map (Story story) (s story.slug)
    in
    oneOf (List.map toParser [])


getCover : Story -> String
getCover story =
    case story of
        Story { cover } ->
            cover


getSlug : Story -> String
getSlug story =
    case story of
        Story { slug } ->
            slug


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


getStartingNarrative : Story -> Narrative
getStartingNarrative story =
    case story of
        Story { startingNarrative } ->
            startingNarrative


getImagesToPreload : Story -> List String
getImagesToPreload story =
    case story of
        Story { imagesToPreLoad } ->
            imagesToPreLoad
