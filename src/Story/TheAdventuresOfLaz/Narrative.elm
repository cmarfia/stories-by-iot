module Story.TheAdventuresOfLaz.Narrative exposing (entersLaz, startingNarrative, theEnd)

{-| The text that will show when the story first starts, before the player interacts with anythin.
-}

{- Here is where you can write all of your story text, which keeps the Rules.elm file a little cleaner.
   The narrative that you add to a rule will be shown when that rule matches.  If you give a list of strings, each time the rule matches, it will show the next narrative in the list, which is nice for adding variety and texture to your story.
   I sometimes like to write all my narrative content first, then create the rules they correspond to.
   Note that you can use **markdown** in your text!
-}


startingNarrative : { interactableName : String, interactableCssSelector : String, narrative : String }
startingNarrative =
    { interactableName = ""
    , interactableCssSelector = "opening"
    , narrative = """There once was a cat."""
    }


entersLaz : String
entersLaz =
    """Laz enter the forest"""


theEnd : String
theEnd =
    """To Be Continued..."""
