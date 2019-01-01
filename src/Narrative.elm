module Narrative exposing (entersClearing, jaraldHearsASounds, startingNarrative, storyTitle, tenzinIntro, theEnd, throughTheClearing)

import ClientTypes exposing (..)



{- Here is where you can write all of your story text, which keeps the Rules.elm file a little cleaner.
   The narrative that you add to a rule will be shown when that rule matches.  If you give a list of strings, each time the rule matches, it will show the next narrative in the list, which is nice for adding variety and texture to your story.
   I sometimes like to write all my narrative content first, then create the rules they correspond to.
   Note that you can use **markdown** in your text!
-}


storyTitle : String
storyTitle =
    "How Jarald and Tenzin Met"


{-| The text that will show when the story first starts, before the player interacts with anythin.
-}
startingNarrative : StorySnippet
startingNarrative =
    { interactableName = ""
    , interactableCssSelector = "opening"
    , narrative = """Once upon a time there was a peaceful forest..."""
    }


jaraldHearsASounds : String
jaraldHearsASounds =
    """A giraffe named Jarald was walking through that forest on his way to a mightly castle.

Just when everything seems calm Jarald heard a noise. "What was that" cried Jarald."""


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

"Should we go inside?" ask Tenzin with much excitement.

"Last one there cooks dinner" Jarald yelled as he took a head start.
"""


theEnd : String
theEnd =
    """To Be Continued..."""
