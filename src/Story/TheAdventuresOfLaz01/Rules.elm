module Story.TheAdventuresOfLaz01.Rules exposing (rules, startingState)

import Dict exposing (Dict)
import Engine exposing (..)
import Story.Components exposing (..)
import Story.TheAdventuresOfLaz01.Narrative as Narrative


startingState : List Engine.ChangeWorldCommand
startingState =
    [ moveTo "forest"
    , moveItemToLocation "next" "forest"
    , moveItemToLocation "rock" "forest"
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
            , characterIsNotInLocation "jarald" "forest"
            ]
        , changes =
            [ moveCharacterToLocation "jarald" "forest"
            ]
        }
        Narrative.jaraldHearsASounds
    , createRule "interact with rock"
        { interaction = with "rock"
        , conditions = []
        , changes = []
        }
        "You touched the rock"
    , createRule "interact with castle"
        { interaction = with "castle"
        , conditions = []
        , changes = []
        }
        "lets go to the castle"
    , createRule "interact with jarald"
        { interaction = with "jarald"
        , conditions = []
        , changes = []
        }
        "You talked with jarald"
    , createRule
        "Introduction to tenzin"
        { interaction = with "next"
        , conditions =
            [ currentLocationIs "forest"
            , characterIsInLocation "jarald" "forest"
            , characterIsNotInLocation "tenzin" "forest"
            ]
        , changes =
            [ moveCharacterToLocation "tenzin" "forest"
            , moveCharacterOffScreen "jarald"
            ]
        }
        Narrative.tenzinIntro
    , createRule
        "through the clearing"
        { interaction = with "next"
        , conditions =
            [ currentLocationIs "forest"
            , characterIsNotInLocation "jarald" "forest"
            , characterIsInLocation "tenzin" "forest"
            ]
        , changes =
            [ moveCharacterToLocation "jarald" "forest"
            ]
        }
        Narrative.throughTheClearing
    , createRule
        "enters clearing"
        { interaction = with "next"
        , conditions =
            [ currentLocationIs "forest"
            , characterIsInLocation "jarald" "forest"
            , characterIsInLocation "tenzin" "forest"
            ]
        , changes =
            [ moveCharacterToLocation "jarald" "castle"
            , moveCharacterToLocation "tenzin" "castle"
            , moveTo "castle"
            , moveItemToLocation "next" "castle"
            ]
        }
        Narrative.entersClearing

    -- Scene End
    , createRule
        "TheEnd"
        { interaction = with "next"
        , conditions =
            [ currentLocationIs "castle"
            , characterIsInLocation "jarald" "castle"
            , characterIsInLocation "tenzin" "castle"
            ]
        , changes =
            [ moveItemOffScreen "next" ]
        }
        Narrative.theEnd
    ]
        |> Dict.fromList
