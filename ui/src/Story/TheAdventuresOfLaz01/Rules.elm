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
    , createRule "laz's travels"
        { interaction = with "continue"
        , conditions =
            [ currentLocationIs "plains"
            , characterIsInLocation "laz" "plains"
            , hasPreviouslyInteractedWith "laz"
            ]
        , changes =
            [ moveItemOffScreen "continue"
            , moveItemToLocation "meanwhile" "plains"
            ]
        }
        Narrative.lazsTravels
    , createRule "laz walks the dirty road"
        { interaction = with "laz"
        , conditions =
            [ currentLocationIs "plains"
            , characterIsInLocation "laz" "plains"
            , hasPreviouslyInteractedWith "laz"
            ]
        , changes =
            []
        }
        Narrative.lazWalksTheDirtRoad
    , createRule "Meanwhile in the village"
        { interaction = with "meanwhile"
        , conditions =
            [ currentLocationIs "plains"
            , characterIsInLocation "laz" "plains"
            , hasPreviouslyInteractedWith "laz"
            ]
        , changes =
            [ moveTo "village"
            , moveItemToLocation "continue" "village"
            ]
        }
        Narrative.toTheVillage
    , createRule "Intoduction to sparky"
        { interaction = with "continue"
        , conditions =
            [ currentLocationIs "village"
            ]
        , changes =
            [ moveCharacterToLocation "sparky" "village"
            , moveItemOffScreen "continue"
            ]
        }
        Narrative.introToSparky
    , createRule "Sparky's dream"
        { interaction = with "sparky"
        , conditions =
            [ currentLocationIs "village"
            , characterIsInLocation "sparky" "village"
            ]
        , changes =
            [ moveTo "village-exit"
            , moveCharacterToLocation "sparky" "village-exit"
            ]
        }
        Narrative.sparkysDream
    , createRule "sparky leaves the village"
        { interaction = with "forest-start"
        , conditions =
            [ currentLocationIs "village-exit"
            , characterIsInLocation "sparky" "village-exit"
            ]
        , changes =
            [ moveTo "forest-start"
            , moveCharacterToLocation "sparky" "forest-start"
            ]
        }
        Narrative.sparkyLeavesHome
    , createRule "sparky walks through the forest"
        { interaction = with "sparky"
        , conditions =
            [ currentLocationIs "forest-start"
            , characterIsInLocation "sparky" "forest-start"
            ]
        , changes =
            [ moveTo "forest-end"
            , moveCharacterToLocation "sparky" "forest-end"
            ]
        }
        Narrative.sparkyWalksThroughTheForest
    , createRule "sparky in the forest"
        { interaction = with "sparky"
        , conditions =
            [ currentLocationIs "forest-end"
            , characterIsInLocation "sparky" "forest-end"
            ]
        , changes =
            []
        }
        Narrative.sparkyWalksThroughTheForest
    , createRule "sparky enters the lighthouse"
        { interaction = with "lighthouse"
        , conditions =
            [ currentLocationIs "forest-end"
            , characterIsInLocation "sparky" "forest-end"
            , characterIsInLocation "laz" "plains"
            ]
        , changes =
            [ moveTo "lighthouse"
            , moveCharacterToLocation "sparky" "lighthouse"
            , moveItemToLocation "meanwhile" "lighthouse"
            ]
        }
        Narrative.sparkyEntersTheLighthouse
    , createRule "sparky is scared"
        { interaction = with "sparky"
        , conditions =
            [ currentLocationIs "lighthouse"
            , characterIsInLocation "sparky" "lighthouse"
            , characterIsInLocation "laz" "plains"
            ]
        , changes =
            []
        }
        Narrative.sparkyIsScared
    , createRule "laz enters the forest"
        { interaction = with "meanwhile"
        , conditions =
            [ currentLocationIs "lighthouse"
            , characterIsInLocation "sparky" "lighthouse"
            , characterIsInLocation "laz" "plains"
            ]
        , changes =
            [ moveTo "forest-start"
            , moveCharacterToLocation "laz" "forest-start"
            , moveItemToLocation "continue" "forest-start"
            ]
        }
        Narrative.lazEntersTheForest
    , createRule "laz's thoughts of the forest"
        { interaction = with "laz"
        , conditions =
            [ currentLocationIs "forest-start"
            , characterIsInLocation "laz" "forest-start"
            , itemIsNotInLocation "log" "forest-start"
            , hasNotPreviouslyInteractedWith "log"
            ]
        , changes =
            []
        }
        Narrative.lazsThoughtsOfTheForest
    , createRule "laz's thoughts of the forest"
        { interaction = with "continue"
        , conditions =
            [ currentLocationIs "forest-start"
            , characterIsInLocation "laz" "forest-start"
            , itemIsNotInLocation "log" "forest-start"
            , hasNotPreviouslyInteractedWith "log"
            ]
        , changes =
            [ moveItemToLocation "log" "forest-start"
            , moveItemOffScreen "continue"
            ]
        }
        Narrative.lazsFindsTheLog
    , createRule "laz thinks about the log"
        { interaction = with "laz"
        , conditions =
            [ currentLocationIs "forest-start"
            , characterIsInLocation "laz" "forest-start"
            , itemIsInLocation "log" "forest-start"
            ]
        , changes =
            []
        }
        Narrative.lazThoughtsOnTheLog
    , createRule "laz climb the log"
        { interaction = with "log"
        , conditions =
            [ currentLocationIs "forest-start"
            , characterIsInLocation "laz" "forest-start"
            , itemIsInLocation "log" "forest-start"
            ]
        , changes =
            [ moveItemOffScreen "log"
            , moveItemToLocation "meanwhile" "forest-start"
            ]
        }
        Narrative.climbingTheLog
    , createRule "laz was victorious"
        { interaction = with "laz"
        , conditions =
            [ currentLocationIs "forest-start"
            , characterIsInLocation "laz" "forest-start"
            , itemIsNotInLocation "log" "forest-start"
            , hasPreviouslyInteractedWith "log"
            ]
        , changes =
            []
        }
        Narrative.lazWasVictorious
    , createRule "sparky is brave"
        { interaction = with "meanwhile"
        , conditions =
            [ currentLocationIs "forest-start"
            , characterIsInLocation "laz" "forest-start"
            , itemIsNotInLocation "log" "forest-start"
            , hasPreviouslyInteractedWith "log"
            ]
        , changes =
            [ moveTo "lighthouse"
            , moveItemToLocation "stairs" "lighthouse"
            ]
        }
        Narrative.sparkyIsBrave
    , createRule "sparky has to go up the stairs"
        { interaction = with "sparky"
        , conditions =
            [ currentLocationIs "lighthouse"
            , characterIsInLocation "sparky" "lighthouse"
            , itemIsInLocation "stairs" "lighthouse"
            ]
        , changes =
            []
        }
        Narrative.sparkyHasToGoUpTheStairs
    , createRule "sparky climbs the stairs"
        { interaction = with "stairs"
        , conditions =
            [ currentLocationIs "lighthouse"
            , characterIsInLocation "sparky" "lighthouse"
            , itemIsInLocation "stairs" "lighthouse"
            ]
        , changes =
            [ moveItemOffScreen "stairs"
            , moveItemToLocation "meanwhile" "lighthouse"
            ]
        }
        Narrative.sparkyClimbsTheStairs
    , createRule "sparkys thoughts at the top of the lighthouse"
        { interaction = with "sparky"
        , conditions =
            [ currentLocationIs "lighthouse"
            , characterIsInLocation "sparky" "lighthouse"
            , hasPreviouslyInteractedWith "stairs"
            ]
        , changes =
            []
        }
        Narrative.sparkysThoughtsAtTheLighthouse
    , createRule "laz continues through the forest"
        { interaction = with "meanwhile"
        , conditions =
            [ currentLocationIs "lighthouse"
            , characterIsInLocation "sparky" "lighthouse"
            , hasPreviouslyInteractedWith "stairs"
            ]
        , changes =
            [ moveTo "forest-end"
            , moveCharacterToLocation "laz" "forest-end"
            ]
        }
        Narrative.lazContinuesThroughTheForest
    , createRule "laz makes it to the end of the forest"
        { interaction = with "laz"
        , conditions =
            [ currentLocationIs "forest-end"
            , characterIsInLocation "laz" "forest-end"
            ]
        , changes =
            []
        }
        Narrative.lazMakesItToTheEndOfTheForest
    , createRule "laz makes it to the end of the forest"
        { interaction = with "lighthouse"
        , conditions =
            [ currentLocationIs "forest-end"
            , characterIsInLocation "laz" "forest-end"
            ]
        , changes =
            [ moveCharacterToLocation "laz" "lighthouse"
            , moveItemToLocation "continue" "lighthouse"
            , moveCharacterOffScreen "sparky"
            , moveTo "lighthouse"
            ]
        }
        Narrative.lazEntersTheLighthouse

    {-
        1 | Speak with Laz

       I wonder what the bright light is?" Laz said

       2 | Continue

       > move Sparky to lighthouse

       > move stairs to lighthouse

       ""Meow, Meow, Meow a light-bulb" said Laz.

       "Hello there Sparky said"

       "Do you know where the castle of light is Mr. light-bulb" says Laz

       "Mr. light-bulb was my father, call me Sparky. The castle of light is across the bridge and into the mountains." said Sparky

       "Thank you Sparky, off to the mountains."

       1 | Speak with Laz

       "My name is Laz"

       2 | Speak with Sparky

       "I am already helping people with my bright light" thought sparky

       3 | Use the Stairs

       > move to lighthouse outside

       > move laz to lighthouse outside

       "One step closer to the castle" says Laz.

       Laz looked around for the direction Sparky pointed too. Just then Sparky used his light from inside to lighthouse to shine the way to the bridge.

       1 | Speak with Laz

       I guess I will follow Sparky's light to the bridge says Laz

       2 | Go to the bridge

       > move laz to the bridge

       > move to bridge

       Laz approached the bridge with the use of Sparky's light.

       As Laz looked up at the bridge he could not believe his eyes.

       To be continued...


       == End ==
    -}
    , createRule "TheEnd"
        { interaction = with "continue"
        , conditions =
            [ currentLocationIs "bridge"
            , characterIsInLocation "laz" "bridge"
            ]
        , changes =
            []
        }
        Narrative.theEnd
    ]
        |> Dict.fromList
