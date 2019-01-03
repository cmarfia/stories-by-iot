module Story.TheAdventuresOfLaz.StoryInfo exposing (storyInfo)

import Story.Components exposing (..)
import Story.TheAdventuresOfLaz.Manifest as Manifest
import Story.TheAdventuresOfLaz.Narrative as Narrative
import Story.TheAdventuresOfLaz.Rules as Rules


storyInfo : StoryInfo
storyInfo =
    { title = "The Adventures Of Laz The Cat"
    , slug = "the-adventures-of-laz-the-cat"
    , cover = "https://via.placeholder.com/150x200?text=The Adventures of Laz The Cat"
    , manifest =
        { items = Manifest.items
        , characters = Manifest.characters
        , locations = Manifest.locations
        }
    , startingNarrative = Narrative.startingNarrative
    , startingState = Rules.startingState
    , rules = Rules.rules
    }
