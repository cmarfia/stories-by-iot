module Page.Home exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Flags exposing (Flags, StoryInfo)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port
import Route
import Story.Components exposing (..)
import Url exposing (Url)



-- Model


type alias Model =
    { library : List StoryInfo
    }


init : Flags -> ( Model, Cmd Msg )
init { library } =
    let
        loadImagesMsg =
            Port.PreloadImages ("img/logo.png" :: List.map .coverImage library)
    in
    ( { library = library }, Port.toJavaScript (Port.encode loadImagesMsg) )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Stories By Iot"
    , content =
        div [ class "page page__home clearfix" ]
            [ div [ class "container" ]
                [ viewHeader
                , div [ class "row" ] (List.map viewStory model.library)
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
viewStory { coverImage, title, slug } =
    div [ class "one-half column story" ]
        [ img [ src coverImage, alt title, onClick <| SelectedStory slug ] []
        ]



-- Update


type Msg
    = SelectedStory String


update : Nav.Key -> Flags -> Msg -> Model -> ( Model, Cmd Msg )
update navKey _ msg model =
    case msg of
        SelectedStory slug ->
            let
                url =
                    "#/" ++ slug
            in
            ( model, Nav.pushUrl navKey url )
