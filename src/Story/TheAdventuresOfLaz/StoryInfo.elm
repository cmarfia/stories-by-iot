module Story.TheAdventuresOfLaz.StoryInfo exposing (storyInfo)

import Story.Components exposing (..)
import Story.TheAdventuresOfLaz.Manifest as Manifest
import Story.TheAdventuresOfLaz.Narrative as Narrative
import Story.TheAdventuresOfLaz.Rules as Rules


storyInfo : StoryInfo
storyInfo =
    { title = "The Adventures Of Laz The Cat"
    , slug = "the-adventures-of-laz-the-cat"
    , cover = "/img/the-adventures-of-laz-the-cat-cover.png"
    , manifest =
        { items = Manifest.items
        , characters = Manifest.characters
        , locations = Manifest.locations
        }
    , startingNarrative = Narrative.startingNarrative
    , startingState = Rules.startingState
    , rules = Rules.rules
    }
