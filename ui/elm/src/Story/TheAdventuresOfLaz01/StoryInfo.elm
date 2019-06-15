module Story.TheAdventuresOfLaz01.StoryInfo exposing (storyInfo)

import Story.Components exposing (..)
import Story.TheAdventuresOfLaz01.Manifest as Manifest
import Story.TheAdventuresOfLaz01.Narrative as Narrative
import Story.TheAdventuresOfLaz01.Rules as Rules


storyInfo : StoryInfo
storyInfo =
    { title = "The Adventures of Laz the Cat 01"
    , slug = "the-adventrues-of-laz-the-cat-01"
    , cover = "img/laz_01_cover.png"
    , manifest =
        { items = Manifest.items
        , characters = Manifest.characters
        , locations = Manifest.locations
        }
    , startingNarrative = Narrative.startingNarrative
    , startingState = Rules.startingState
    , rules = Rules.rules
    , imagesToPreLoad =
        [ "img/bridge.png"
        , "img/forest.png"
        , "img/laz_01_cover.png"
        , "img/laz.png"
        , "img/lighthouse.png"
        , "img/plains.png"
        , "img/sparky.png"
        , "img/village.png"
        ]
    }
