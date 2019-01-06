module Story.TheAdventuresOfLaz01.Manifest exposing (characters, items, locations)

import Story.Components exposing (..)



{- Here is where you define your manifest -- all of the items, characters, and locations in your story. You can add what ever components you wish to each entity.  Note that the first argument to `entity` is the id for that entity, which is the id you must refer to in your rules.
   In the current theme, the description in the display info component is only used as a fallback narrative if a rule does not match with a more specific narrative when interacting with that story object.
-}


items : List Entity
items =
    [ entity "continue"
        |> addActionText "Continue"
    , entity "meanwhile"
        |> addActionText "Meanwhile"
    , entity "log"
        |> addActionText "Climb over log"
    , entity "stairs"
        |> addActionText "Take the stairs"
    ]


characters : List Entity
characters =
    [ entity "laz"
        |> addName "Laz"
        |> addImage "img/laz.png?v=1"

    --|> addInteractable
    --|> addActionText "Speak with Laz"
    , entity "sparky"
        |> addName "Sparky"
        |> addImage "img/sparky.png?v=1"
        |> addInteractable
        |> addActionText "Speak with Sparky"
    ]


locations : List Entity
locations =
    [ entity "plains"
        |> addName "The Plains"
        --|> addConnectingLocations [ "forest" ]
        |> addImage "img/plains.png?v=1"
    , entity "forest-start"
        |> addName "The Deep Forest"
        |> addImage "img/forest.png?v=1"
        |> addActionText "Enter the Deep Forest"
    , entity "forest-end"
        |> addName "The Deep Forest"
        |> addImage "img/forest.png?v=1"
        |> addConnectingLocations [ "lighthouse" ]
    , entity "village"
        |> addName "The Village of Light"
        |> addImage "img/village.png?v=1"
        |> addConnectingLocations [ "forest" ]
    , entity "lighthouse"
        |> addName "The Lighthouse"
        |> addImage "img/lighthouse.png"
        |> addActionText "Enter the Lighthouse"
    , entity "lighthouse-outside"
        |> addName "The Lighthouse"
        |> addImage "img/lighthouse.png"
        |> addConnectingLocations [ "bridge" ]
    , entity "bridge"
        |> addName "The Bridge"
        |> addImage "img/bridge.png?v=1"
    ]
