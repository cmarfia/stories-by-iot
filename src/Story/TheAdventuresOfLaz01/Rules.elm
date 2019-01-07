module Story.TheAdventuresOfLaz01.Rules exposing (rules, startingState)

import Dict exposing (Dict)
import Engine exposing (..)
import Story.Components exposing (..)
import Story.TheAdventuresOfLaz01.Narrative as Narrative


startingState : List Engine.ChangeWorldCommand
startingState =
    [ moveTo "plains", moveItemToLocation "continue" "plains" ]


{-| All of the rules that govern your story. The first parameter to `rule` is an id for that rule. It must be unique, but generally isn't used directly anywhere else (though it gets returned from `Engine.update`, so you could do some special behavior if a specific rule matches). I like to write a short summary of what the rule is for as the id to help me easily identify them.
Also, order does not matter, but I like to organize the rules by the story objects they are triggered by. This makes it easier to ensure I have set up the correct criteria so the right rule will match at the right time.
Note that the ids used in the rules must match the ids set in `Manifest.elm`.
-}
rules : Dict String Components
rules =
    [ createRule "the start"
        { interaction = with "continue"
        , conditions =
            [ currentLocationIs "plains"
            , characterIsNotInLocation "laz" "plains"
            ]
        , changes =
            [ moveCharacterToLocation "laz" "plains"
            , moveItemOffScreen "continue"
            ]
        }
        Narrative.lazEntersThePlains
    , createRule "introduction to laz"
        { interaction = with "laz"
        , conditions =
            [ currentLocationIs "plains"
            , characterIsInLocation "laz" "plains"
            ]
        , changes =
            [ moveItemToLocation "continue" "plains"
            ]
        }
        Narrative.introductionToLaz
    , createRule
        "TheEnd"
        { interaction = with "continue"
        , conditions =
            [ currentLocationIs "plains"
            , characterIsInLocation "laz" "plains"
            ]
        , changes =
            [ moveTo "bridge"
            , moveCharacterToLocation "laz" "bridge"
            ]
        }
        Narrative.theEnd
    ]
        |> Dict.fromList
