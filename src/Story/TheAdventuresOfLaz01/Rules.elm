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

    {-
               1. | Speak with Sparky

       > move to forest-end

       > move sparky to forest-end

       "If I make my way to the lighthouse I'll be able shine so bright" says Sparky, "the mountains will be so bright"

       1 | Speak with Sparky

       "If I make my way to the lighthouse I'll be able shine so bright" says Sparky, "the mountains will be so bright"

       2 | Enter lighthouse

       > move to lighthouse

       > move sparky to lighthouse

       > move meanwhile to lighthouse

       Sparky arrived at the lighthouse. It appeared that no one has been there for a very long time.'

       Sparky started to look around the outside of the lighthouse. The lighthouse was bright red and white. Inside the lighthouse was a spiral set of stairs.

       Sparky was scared of the empty lighthouse.

       1 | Speak to Sparky

       "I... I... want to light up the whole mountain, but... this lighthouse is scary" said sparky

       2 | Meanwhile

       > Move to the forest-start

       > move laz to forest-start

       Laz the Cat has made it across the great green plains and to the start of the forest.

       He had never been in a forest before.

       1 | Speak with Laz

       "The forest is darker than I thought it would be" said Laz.

       2 | Continue

       > move log to forest-start

       As Laz worked through the forest he ran into a huge log. It was the biggest.

       He couldn't go under the log, couldn't go around the log, Laz had to climb over the log.

       1 | Speak to Laz

       "I will have to climb over this log" said Laz.

       2 | Climb over the log

       > move log off screen

       > move meanwhile to forest-start

       Laz climbed over the log and continued his journey though the deep forest.

       1 | Speak with Laz

       "That really was the biggest log that could have smashed me up" says Laz

       2 | Meanwhile

       > move to lighthouse

       > move stairs to lighthouse

       Sparky thought about this lighthouse for a long time. He decided to go into the lighthouse.

       1 | Speak with Sparky

       "I have to go in the lighthouse if I want to light up the whole mountain" says Sparky

       2 | Climb the Stairs

       > move stairs off screen

       > move meanwhile to lighthouse

       Sparky climbed the stairs to the top of the lighthouse. There it could use his bright light to light up the whole mountains.

       Sparky was very happy he is able to do what he wanted. He also found that the lighthouse was not scary at all after using his bright light.

       1 | Speak with Sparky

       "I can see the entire mountain from way up here" says Sparky

       2 | Meanwhile

       > move to forest-end

       > move laz to forest-end

       Laz continued his journey through the forest.

       Just then Laz sees a bright light peaking through the trees.

       "What could that be?" wondered Laz

       Laz could see a lighthouse in the distance where the bright light was coming from.

       1 | Speak with Laz

       "Could this be... have I finally made it..." thought Laz.

       2 | Enter Lighthouse

       > move laz to lighthouse

       > move continue to lighthouse

       > move sparky off screen

       Laz stood at the base of the lighthouse looking up to the bright light shining from the top.

       "It's not the castle" Laz says "I wonder what that light is?"

       Laz entered the lighthouse and started climbing the stairs to the top of the lighthouse.

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
    , createRule "sparky walks through the forest"
        { interaction = with "sparky"
        , conditions =
            [ currentLocationIs "forest-start"
            , characterIsInLocation "sparky" "forest-start"
            ]
        , changes =
            [ moveItemToLocation "continue" "forest-start"
            ]
        }
        Narrative.sparkyWalksThroughTheForest
    , createRule
        "TheEnd"
        { interaction = with "continue"
        , conditions =
            [ currentLocationIs "forest-start"
            , characterIsInLocation "sparky" "forest-start"
            ]
        , changes =
            []
        }
        Narrative.theEnd
    ]
        |> Dict.fromList
