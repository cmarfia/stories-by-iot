module Rules exposing (rule, rules, startingState)

import Components exposing (..)
import Dict exposing (Dict)
import Engine exposing (..)
import Narrative


startingState : List Engine.ChangeWorldCommand
startingState =
    [ moveTo "light-village"
    , moveItemToLocation "next" "light-village"
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
    [ rule "back to begining"
        { interaction = with "previous"
        , conditions =
            [ currentLocationIs "light-village"
            , characterIsInLocation "laz" "light-village"
            ]
        , changes =
            [ moveItemOffScreen "previous"
            , moveCharacterOffScreen "laz"
            ]
        }
        Narrative.startingNarrative.narrative

    -- Scene 1
    , rule "entering the village"
        { interaction = with "next"
        , conditions =
            [ currentLocationIs "light-village"
            , characterIsNotInLocation "laz" "light-village"
            ]
        , changes =
            [ moveCharacterToLocation "laz" "light-village"
            , moveItemToLocation "previous" "light-village"
            ]
        }
        Narrative.enteringVillage

    -- Scene End
    , rule "Ending"
        { interaction = with "next"
        , conditions =
            [ currentLocationIs "light-village"
            , characterIsInLocation "laz" "light-village"
            ]
        , changes =
            [ moveItemOffScreen "next", moveItemOffScreen "previous" ]
        }
        Narrative.theEnd
    ]
        |> Dict.fromList
