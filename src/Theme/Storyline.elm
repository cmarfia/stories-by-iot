module Theme.Storyline exposing (view)

import ClientTypes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed
import Markdown


view : List StorySnippet -> Maybe String -> Html Msg
view storyLine ending =
    div [ class "StoryLine" ]
        [ case List.head storyLine of
            Just { narrative } ->
                section [] [ Markdown.toHtml [ class "Storyline__Item__Narrative markdown-body" ] narrative ]

            Nothing ->
                text ""
        , if ending /= Nothing then
            h5
                [ class "Storyline__Item__Ending" ]
                [ text <| Maybe.withDefault "The End" ending ]

          else
            text ""
        ]
