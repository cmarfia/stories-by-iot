module Story.TheAdventuresOfLaz.Manifest exposing (characters, items, locations)

import Story.Components exposing (..)



{- Here is where you define your manifest -- all of the items, characters, and locations in your story. You can add what ever components you wish to each entity.  Note that the first argument to `entity` is the id for that entity, which is the id you must refer to in your rules.
   In the current theme, the description in the display info component is only used as a fallback narrative if a rule does not match with a more specific narrative when interacting with that story object.
-}


items : List Entity
items =
    [ entity "next"
    ]


characters : List Entity
characters =
    [ entity "laz"
        |> addName "Lax the Cat"
        |> addImage "img/laz.png"
        |> addNarrative "Default Laz Interaction"
    ]


locations : List Entity
locations =
    [ entity "forest"
        |> addName "The Forest"
        |> addImage "img/forest.png"
    ]
