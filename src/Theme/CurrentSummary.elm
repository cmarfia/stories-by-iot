module Theme.CurrentSummary exposing (view)

import ClientTypes exposing (..)
import Components exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view :
    Entity
    -> List Entity
    -> List Entity
    -> Html Msg
view currentLocation props characters =
    let
        isEmpty =
            List.isEmpty characters && List.isEmpty props

        interactableView msg entity =
            span
                [ class "CurrentSummary__StoryElement u-selectable"
                , onClick <| msg <| Tuple.first entity
                ]
                [ text <| getName entity ]

        format list =
            let
                interactables =
                    if List.length list > 2 then
                        (List.take (List.length list - 1) list
                            |> List.intersperse (text ", ")
                        )
                            ++ text " and "
                            :: List.drop (List.length list - 1) list

                    else
                        List.intersperse (text " and ") list
            in
            interactables ++ [ text "." ]

        charactersList =
            if not <| List.isEmpty characters then
                characters
                    |> List.map (interactableView Interact)
                    |> format
                    |> (::) (text "Characters here: ")
                    |> p []

            else
                span [] []

        interactableViewImage msg entity =
            img
                [ src <| getImage entity
                , onClick <| msg <| Tuple.first entity
                ]
                []

        characterImages =
            if not <| List.isEmpty characters then
                characters
                    |> List.map (interactableViewImage Interact)
                    |> format
                    |> (::) (text "Characters here: ")
                    |> p []

            else
                span [] []

        propsList =
            if not <| List.isEmpty props then
                props
                    |> List.map (interactableView Interact)
                    |> format
                    |> (::) (text "Items here: ")
                    |> p []

            else
                span [] []
    in
    div [ class "CurrentSummary" ] <|
        [ h1 [ class "Current-location" ]
            [ text <| getName currentLocation ]
        ]
            ++ (if isEmpty then
                    [ text "Nothing here." ]

                else
                    [ charactersList, propsList, characterImages ]
               )
