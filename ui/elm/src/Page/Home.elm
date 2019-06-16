module Page.Home exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port
import Route
import Story exposing (Story)
import Story.Components exposing (..)
import Url exposing (Url)



-- Model


type alias Model =
    { stories : List Story
    }


init : ( Model, Cmd Msg )
init =
    let
        loadImagesMsg =
            Port.PreloadImages ("img/logo.png" :: List.map .cover [])
    in
    ( { stories = [] }, Port.toJavaScript (Port.encode loadImagesMsg) )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Stories By Iot"
    , content =
        div [ class "page page__home clearfix" ]
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


viewStory : Story -> Html Msg
viewStory story =
    div [ class "one-half column story" ]
        [ img
            [ src <| Story.getCover story
            , alt <| Story.getTitle story
            , onClick <| SelectedStory <| Story.getSlug story
            ]
            []
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
