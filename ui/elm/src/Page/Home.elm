module Page.Home exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Flags exposing (Flags)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port
import Route
import Story
import Url exposing (Url)



-- Model


type alias Model =
    { stories : List Story.Info
    }


init : List Story.Info -> ( Model, Cmd Msg )
init stories =
    let
        loadImagesMsg =
            Port.PreloadImages ("img/logo.png" :: List.map .coverImage stories)
    in
    ( { stories = stories }, Port.toJavaScript (Port.encode loadImagesMsg) )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Stories By Iot"
    , content =
        div [ class "page page__home clearfix" ]
            [ div [ class "container" ]
                [ viewHeader
                , div [ class "row" ]
                    [ div [ class "story__icon story__icon--cogs" ]
                        [ button [ onClick GoToDashboard ] [ i [ class "icon-cogs" ] [] ]
                        ]
                    ]
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


viewStory : Story.Info -> Html Msg
viewStory storyInfo =
    div [ class "one-half column story" ]
        [ img [ src storyInfo.coverImage, alt storyInfo.title, onClick <| SelectedStory storyInfo ] []
        ]



-- Update


type Msg
    = SelectedStory Story.Info
    | GoToDashboard


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        SelectedStory storyInfo ->
            ( model, Nav.pushUrl navKey <| Route.routeToString <| Route.Story storyInfo )

        GoToDashboard ->
            ( model, Nav.pushUrl navKey <| Route.routeToString Route.Dashboard )
