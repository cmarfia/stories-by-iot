module Page.Home exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route
import Story
import Story.AllStories exposing (..)
import Story.Components exposing (..)
import Url exposing (Url)



-- Model


type alias Model =
    { stories : List StoryInfo
    }


init : ( Model, Cmd Msg )
init =
    ( { stories = allStories }, Cmd.none )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Story Telling"
    , content =
        div [ class "page page__home" ]
            [ div [ class "story__list" ]
                (List.map viewStory model.stories)
            ]
    }


viewStory : StoryInfo -> Html Msg
viewStory storyInfo =
    div [ class "story__item", onClick <| SelectedStory storyInfo.slug ]
        [ img [ src storyInfo.cover, alt storyInfo.title ] []
        ]



-- a [ Route.toHref (Route.Story (Story.toStory storyInfo)) ] [ text storyInfo.title ]
-- Update


type Msg
    = SelectedStory String


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        SelectedStory slug ->
            let
                url =
                    "#/" ++ slug
            in
            ( model, Nav.pushUrl navKey url )
