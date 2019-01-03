module Story.HowJaraldandTenzinMet.StoryInfo exposing (storyInfo)

import Story.Components exposing (..)
import Story.HowJaraldandTenzinMet.Manifest as Manifest
import Story.HowJaraldandTenzinMet.Narrative as Narrative
import Story.HowJaraldandTenzinMet.Rules as Rules


storyInfo : StoryInfo
storyInfo =
    { title = "How Jarald and Tenzin Met"
    , slug = "how-jarald-and-tenzin-met"
    , cover = "/img/how-jarald-and-tenzin-met-cover.png"
    , manifest =
        { items = Manifest.items
        , characters = Manifest.characters
        , locations = Manifest.locations
        }
    , startingNarrative = Narrative.startingNarrative
    , startingState = Rules.startingState
    , rules = Rules.rules
    }
