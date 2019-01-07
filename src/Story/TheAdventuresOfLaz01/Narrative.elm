module Story.TheAdventuresOfLaz01.Narrative exposing
    ( introToSparky
    , introductionToLaz
    , lazEntersThePlains
    , lazWalksTheDirtRoad
    , lazsTravels
    , sparkyLeavesHome
    , sparkyWalksThroughTheForest
    , sparkysDream
    , startingNarrative
    , theEnd
    , toTheVillage
    , whatDoesSparkyWantToBe
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


lazsTravels : String
lazsTravels =
    """<span class="highlight__primary">Laz</span> has traveled for many years in search of this mountain. Once he crosses the great plains he will be one step closer to what he is searching for.

However, <span class="highlight__primary">Laz's</span> travels across the great plains  will take many days"""


lazWalksTheDirtRoad : String
lazWalksTheDirtRoad =
    """"<span class="highlight__primary">Meow! Meow! Meow!"</span> says <span class="highlight__primary">Laz</span> as he waved to each rock on the dirt road."""


toTheVillage : String
toTheVillage =
    """Deep in the forest past the great plains lies a village. This village was known by legend as the village of light. 

Many have come to search for this village throughout the years. It has been said to be the home of the light-bulbs."""


introToSparky : String
introToSparky =
    """One light-bulb aspired to be greater than his village could provide. This eager light-bulb's name was <span class="highlight__secondary">Sparky</span>.

He was the brightest light-bulb in the village. All <span class="highlight__secondary">Sparky</span> only wanted one thing in this world..."""


sparkysDream : String
sparkysDream =
    """<span class="highlight__secondary">"I want to be able to light up the whole mountains"</span> says <span class="highlight__secondary">Sparky</span>"""


whatDoesSparkyWantToBe : String
whatDoesSparkyWantToBe =
    """I wonder what <span class="highlight__secondary">Sparky</span> wants to be?"""


sparkyLeavesHome : String
sparkyLeavesHome =
    """<span class="highlight__secondary">Sparky</span> starts his journey through the forest to the lighthouse. """


sparkyWalksThroughTheForest : String
sparkyWalksThroughTheForest =
    """<span class="highlight__secondary">"If I make my way to the lighthouse I'll be able shine so bright"</span> says <span class="highlight__secondary">Sparky</span>, <span class="highlight__secondary">"the mountains will be so bright"</span>"""


theEnd : String
theEnd =
    """To Be Continued..."""
