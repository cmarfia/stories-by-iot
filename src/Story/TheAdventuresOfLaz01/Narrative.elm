module Story.TheAdventuresOfLaz01.Narrative exposing
    ( introductionToLaz
    , lazEntersThePlains
    , startingNarrative
    , theEnd
    )

{-| The text that will show when the story first starts, before the player interacts with anythin.
-}

{- Here is where you can write all of your story text, which keeps the Rules.elm file a little cleaner.
   The narrative that you add to a rule will be shown when that rule matches.  If you give a list of strings, each time the rule matches, it will show the next narrative in the list, which is nice for adding variety and texture to your story.
   I sometimes like to write all my narrative content first, then create the rules they correspond to.
   Note that you can use **markdown** in your text!
-}


startingNarrative : { interactableId : String, narrative : String }
startingNarrative =
    { interactableId = ""
    , narrative = """Our journey begins in the grassy plains close to the base of a tall mountain.

The grass is the greenest green that you have ever seen. There is a rocky dirt road that splits the grass in two."""
    }


lazEntersThePlains : String
lazEntersThePlains =
    """A traveler enters the plains from a far away land. The travelers name was <span class="highlight__primary">Laz the Cat</span>.

He was on an endless journey searching for the fabled Castle of Light."""


introductionToLaz : String
introductionToLaz =
    """<span class="highlight__primary">"At last the mountain I have been searching for is in sight!"</span> exclaimed <span class="highlight__primary">Laz</span>."""


theEnd : String
theEnd =
    """To Be Continued..."""
