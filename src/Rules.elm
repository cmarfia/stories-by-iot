module Rules exposing (rule, rules, startingState)

import Components exposing (..)
import Dict exposing (Dict)
import Engine exposing (..)
import Narrative


startingState : List Engine.ChangeWorldCommand
startingState =
    [ moveTo "forest"
    , moveItemToLocation "next" "forest"
    ]


rule : String -> Engine.Rule -> String -> Entity
rule id ruleData narrative =
    entity id
        |> addRuleData ruleData
        |> addNarrative narrative


{-| All of the rules that govern your story. The first parameter to `rule` is an id for that rule. It must be unique, but generally isn't used directly anywhere else (though it gets returned from `Engine.update`, so you could do some special behavior if a specific rule matches). I like to write a short summary of what the rule is for as the id to help me easily identify them.
Also, order does not matter, but I like to organize the rules by the story objects they are triggered by. This makes it easier to ensure I have set up the correct criteria so the right rule will match at the right time.
Note that the ids used in the rules must match the ids set in `Manifest.elm`.
-}
rules : Dict String Components
rules =
    [ rule "entering the forest"
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
    , rule
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
    , rule
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
    , rule
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
            ]
        }
        Narrative.entersClearing

    -- Scene End
    , rule "Ending"
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
