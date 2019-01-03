module Page.Home exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Route
import Story
import Story.AllStories exposing (..)
import Story.Components exposing (..)



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
    , content = div [] (List.map viewStory model.stories)
    }


viewStory : StoryInfo -> Html Msg
viewStory storyInfo =
    a [ Route.toHref (Route.Story (Story.toStory storyInfo)) ] [ text storyInfo.title ]



-- Update


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )
