module Story exposing
    ( Manifest
    , Narrative
    , Story
    , decode
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
import Flags exposing (Flags)
import Json.Decode as Decode exposing (Decoder)
import Story.Components exposing (..)
import Story.Info exposing (Info)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


type Story
    = Story FullStory


decode : Decoder Story
decode =
    Decode.fail "ope"


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


parser : Flags -> Parser (Info -> a) a
parser flags =
    let
        toParser story =
            Parser.map story (s story.slug)
    in
    oneOf (List.map toParser flags.library)


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
