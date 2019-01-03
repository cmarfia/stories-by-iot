module Story.TheAdventuresOfLaz.Rules exposing (rules, startingState)

import Dict exposing (Dict)
import Engine exposing (..)
import Story.Components exposing (..)
import Story.HowJaraldandTenzinMet.Narrative as Narrative


startingState : List Engine.ChangeWorldCommand
startingState =
    [ moveTo "forest"
    , moveItemToLocation "next" "forest"
    ]


{-| All of the rules that govern your story. The first parameter to `rule` is an id for that rule. It must be unique, but generally isn't used directly anywhere else (though it gets returned from `Engine.update`, so you could do some special behavior if a specific rule matches). I like to write a short summary of what the rule is for as the id to help me easily identify them.
Also, order does not matter, but I like to organize the rules by the story objects they are triggered by. This makes it easier to ensure I have set up the correct criteria so the right rule will match at the right time.
Note that the ids used in the rules must match the ids set in `Manifest.elm`.
-}
rules : Dict String Components
rules =
    [ createRule "entering the forest"
        { interaction = with "next"
        , conditions =
            [ currentLocationIs "forest"
            , characterIsNotInLocation "laz" "forest"
            ]
        , changes =
            [ moveCharacterToLocation "laz" "forest"
            ]
        }
        Narrative.jaraldHearsASounds
    , createRule
        "TheEnd"
        { interaction = with "next"
        , conditions =
            [ currentLocationIs "forest"
            , characterIsInLocation "laz" "forest"
            ]
        , changes =
            [ moveItemOffScreen "next" ]
        }
        Narrative.theEnd
    ]
        |> Dict.fromList
