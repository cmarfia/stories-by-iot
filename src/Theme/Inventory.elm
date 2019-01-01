module Theme.Inventory exposing (view)

import ClientTypes exposing (..)
import Components exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed
import Tuple


view :
    List Entity
    -> Html Msg
view items =
    let
        numItems =
            List.length items

        inventoryItem i entity =
            let
                key =
                    Tuple.first entity ++ (String.fromInt <| numItems - i)
            in
            ( key
            , li
                [ class "Inventory__Item u-selectable"
                , onClick <| Interact <| Tuple.first entity
                ]
                [ text <| getName entity ]
            )
    in
    div [ class "Inventory" ]
        [ h3 [] [ text "Inventory" ]
        , div [ class "Inventory__list" ]
            [ Html.Keyed.ol []
                (List.indexedMap inventoryItem items)
            ]
        ]
