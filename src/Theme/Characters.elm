module Theme.Characters exposing (view)

import ClientTypes exposing (..)
import Components exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : List Entity -> Html Msg
view characters =
    let
        toImage character =
            div []
                [ img [ src <| Maybe.withDefault "" <| getImage character ] []
                ]
    in
    div [ class "Characters" ] <|
        List.map toImage characters
