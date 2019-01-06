module Page.Home exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port
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
    let
        loadImagesMsg =
            Port.PreloadImages ("img/logo.png" :: List.map .cover allStories)
    in
    ( { stories = allStories }, Port.toJavaScript (Port.encode loadImagesMsg) )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Stories By Iot"
    , content =
        div [ class "page page__home" ]
            [ div [ class "container" ]
                [ viewHeader
                , div [ class "row" ] (List.map viewStory model.stories)
                ]
            ]
    }


viewHeader : Html Msg
viewHeader =
    div [ class "row" ]
        [ div [ class "one column" ] []
        , div [ class "ten columns header clearfix" ]
            [ img [ src "img/logo.png", alt "logo" ] []
            , p [] [ text "Stories By Iot" ]
            ]
        , div [ class "one column stories" ] []
        ]


viewStory : StoryInfo -> Html Msg
viewStory storyInfo =
    div [ class "one-half column story" ]
        [ img [ src storyInfo.cover, alt storyInfo.title, onClick <| SelectedStory storyInfo.slug ] []
        ]



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
