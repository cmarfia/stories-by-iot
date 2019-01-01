module Narrative exposing (enteringVillage, startingNarrative, theEnd)

import ClientTypes exposing (..)



{- Here is where you can write all of your story text, which keeps the Rules.elm file a little cleaner.
   The narrative that you add to a rule will be shown when that rule matches.  If you give a list of strings, each time the rule matches, it will show the next narrative in the list, which is nice for adding variety and texture to your story.
   I sometimes like to write all my narrative content first, then create the rules they correspond to.
   Note that you can use **markdown** in your text!
-}


{-| The text that will show when the story first starts, before the player interacts with anythin.
-}
startingNarrative : StorySnippet
startingNarrative =
    { interactableName = "Once upon a time..."
    , interactableCssSelector = "opening"
    , narrative = """Once upon a time there was a village of light that thrived far up in the mountains."""
    }


enteringVillage : String
enteringVillage =
    """Unbenounced to the villagers came a wondering traveler"""


theEnd : String
theEnd =
    """This is the ending"""
