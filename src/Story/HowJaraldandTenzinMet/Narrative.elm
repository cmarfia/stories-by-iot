module Story.HowJaraldandTenzinMet.Narrative exposing (entersClearing, jaraldHearsASounds, startingNarrative, tenzinIntro, theEnd, throughTheClearing)

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
    , narrative = """Once upon a time there was a peaceful forest..."""
    }


jaraldHearsASounds : String
jaraldHearsASounds =
    """A giraffe named <span class="highlight__primary">Jarald</span> was walking through that forest on his way to a mightly castle.

Just when everything seems calm Jarald heard a noise. <span class="highlight__primary">"What was that"</span> cried <span class="highlight__primary">Jarald</span>."""


tenzinIntro : String
tenzinIntro =
    """ "It's only me!" said tenzin. 

"Why are you always so scared?"
"""


throughTheClearing : String
throughTheClearing =
    """ "Don't scare me like that Tenzin" said jarald. 

He look we are almost there.
"""


entersClearing : String
entersClearing =
    """ "Wow" they both said.

<span class="highlight__primary">"Should we go inside?"</span> ask Tenzin with much excitement.

<span class="highlight__secondary">"Last one there cooks dinner"</span> Jarald yelled as he took a head start.
"""


theEnd : String
theEnd =
    """To Be Continued..."""
