module Story.TheAdventuresOfLaz01.Narrative exposing
    ( climbingTheLog
    , introToSparky
    , introductionToLaz
    , lazContinuesThroughTheForest
    , lazEntersTheForest
    , lazEntersTheLighthouse
    , lazEntersThePlains
    , lazMakesItToTheEndOfTheForest
    , lazThoughtsOnTheLog
    , lazWalksTheDirtRoad
    , lazWasVictorious
    , lazsFindsTheLog
    , lazsThoughtsOfTheForest
    , lazsTravels
    , sparkyClimbsTheStairs
    , sparkyEntersTheLighthouse
    , sparkyHasToGoUpTheStairs
    , sparkyIsBrave
    , sparkyIsScared
    , sparkyLeavesHome
    , sparkyWalksThroughTheForest
    , sparkysDream
    , sparkysThoughtsAtTheLighthouse
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


sparkyEntersTheLighthouse : String
sparkyEntersTheLighthouse =
    """<span class="highlight__secondary">Sparky</span> arrived at the lighthouse. It appeared that no one has been there for a very long time. He started to look around the outside of the lighthouse. The lighthouse was bright red and white. Inside the lighthouse was a spiral set of stairs.

<span class="highlight__secondary">Sparky</span> was very scared of the empty lighthouse."""


sparkyIsScared : String
sparkyIsScared =
    """<span class="highlight__secondary">"I... I... want to light up the whole mountain, but... this lighthouse is scary"</span> said <span class="highlight__secondary">Sparky</span>"""


lazEntersTheForest : String
lazEntersTheForest =
    """<span class="highlight__primary">Laz the Cat</span> has made it across the great green plains and to the start of the forest.

He had never been in a forest before."""


lazsThoughtsOfTheForest : String
lazsThoughtsOfTheForest =
    """<span class="highlight__primary">"The forest is darker than I thought it would be"</span> said <span class="highlight__primary">Laz</span>."""


lazsFindsTheLog : String
lazsFindsTheLog =
    """As <span class="highlight__primary">Laz</span> worked through the forest he ran into a huge log. It was the biggest.

He couldn't go under the log, couldn't go around the log, Laz had to climb over the log."""


lazThoughtsOnTheLog : String
lazThoughtsOnTheLog =
    """<span class="highlight__primary">"I will have to climb over this log"</span> said <span class="highlight__primary">Laz</span>."""


climbingTheLog : String
climbingTheLog =
    """<span class="highlight__primary">Laz</span> climbed over the log and continued his journey though the deep forest."""


lazWasVictorious : String
lazWasVictorious =
    """<span class="highlight__primary">"That really was the biggest log that could have smashed me up"</span> says <span class="highlight__primary">Laz</span>."""


sparkyIsBrave : String
sparkyIsBrave =
    """<span class="highlight__secondary">Sparky</span> thought about this lighthouse for a long time. He decided to go into the lighthouse."""


sparkyHasToGoUpTheStairs : String
sparkyHasToGoUpTheStairs =
    """<span class="highlight__secondary">"I have to go in the lighthouse if I want to light up the whole mountain"</span> says <span class="highlight__secondary">Sparky</span>."""


sparkyClimbsTheStairs : String
sparkyClimbsTheStairs =
    """<span class="highlight__secondary">Sparky</span> climbed the stairs to the top of the lighthouse. There it could use his bright light to light up the whole mountains.

He was very happy he is able to do what he wanted. He also found that the lighthouse was not scary at all after using his bright light."""


sparkysThoughtsAtTheLighthouse : String
sparkysThoughtsAtTheLighthouse =
    """<span class="highlight__secondary">"I can see the entire mountain from way up here"</span> says <span class="highlight__secondary">Sparky</span>."""


lazContinuesThroughTheForest : String
lazContinuesThroughTheForest =
    """<span class="highlight__secondary">Laz</span> continued his journey through the forest. He sees a bright light peaking through the trees.

<span class="highlight__secondary">"What could that be?"</span> he wondered.

<span class="highlight__secondary">Laz</span> could see a lighthouse in the distance where the bright light was coming from."""


lazMakesItToTheEndOfTheForest : String
lazMakesItToTheEndOfTheForest =
    """<span class="highlight__secondary">"Could this be... have I finally made it..."</span> thought <span class="highlight__secondary">Laz</span>."""


lazEntersTheLighthouse : String
lazEntersTheLighthouse =
    """<span class="highlight__secondary">Laz</span> stood at the base of the lighthouse looking up to the bright light shining from the top.

<span class="highlight__secondary">"It's not the castle" Laz</span> says <span class="highlight__secondary">"I wonder what that light is?"</span>

<span class="highlight__secondary">Laz</span> entered the lighthouse and started climbing the stairs to the top of the lighthouse."""


theEnd : String
theEnd =
    """To Be Continued..."""
