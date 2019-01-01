module Theme.Layout exposing (view)

import ClientTypes exposing (..)
import Components exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Theme.Characters exposing (..)
import Theme.Inventory exposing (..)
import Theme.Storyline exposing (..)


view :
    { currentLocation : Entity
    , itemsInCurrentLocation : List Entity
    , charactersInCurrentLocation : List Entity
    , itemsInInventory : List Entity
    , ending : Maybe String
    , storyLine : List StorySnippet
    }
    -> Html Msg
view displayState =
    div [ class <| "Location Location--" ++ Components.getClassName displayState.currentLocation, style "background-image" ("url(" ++ (Maybe.withDefault "" <| Components.getImage displayState.currentLocation) ++ ")") ]
        [ div [ class "Layout" ]
            [ Theme.Characters.view displayState.charactersInCurrentLocation
            , div [ class "Layout__Main" ] <|
                [ Theme.Storyline.view displayState.storyLine displayState.ending
                , if displayState.ending /= Nothing then
                    h5 [ class "StoryRestart", onClick Restart ] [ text "Restart" ]

                  else
                    h5 [ class "StoryContinue", onClick (Interact "next") ] [ text "Continue" ]
                ]
            ]
        ]
