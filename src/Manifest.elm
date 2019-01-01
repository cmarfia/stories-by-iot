module Manifest exposing (items, locations, characters)

import Components exposing (..)


{- Here is where you define your manifest -- all of the items, characters, and locations in your story. You can add what ever components you wish to each entity.  Note that the first argument to `entity` is the id for that entity, which is the id you must refer to in your rules.
   In the current theme, the description in the display info component is only used as a fallback narrative if a rule does not match with a more specific narrative when interacting with that story object.
-}


items : List Entity
items =
    [ entity "pervious"
    , entity "next"
    ]


characters : List Entity
characters =
    [ entity "laz"
        |> addName "Laz The Cat"
        |> addImage "https://via.placeholder.com/250x250?text=Laz%20the%20Cat"
        |> addSpeakingPosition Left
        |> addClassName "speaker--primary"
    , entity "sparky"
        |> addName "Sparky The Lightbulb"
        |> addImage "https://via.placeholder.com/250x250?text=Sparky%20The%20Lightbulb"
        |> addSpeakingPosition Right
        |> addClassName "speaker--secondary"
    ]

 
locations : List Entity
locations =
    [ entity "light-village"
        |> addName "The Village of Light"
        |> addImage "https://via.placeholder.com/800x500?text=light-village"
    , entity "mount-pass"
        |> addName "Mountain Pass"
        |> addImage "https://via.placeholder.com/800x500?text=mountain-pass"
    , entity "lighthouse"
        |> addName "The Lighthouse"
        |> addImage "https://via.placeholder.com/800x500?text=lighthouse"
    ]
