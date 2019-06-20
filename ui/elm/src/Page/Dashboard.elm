module Page.Dashboard exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Flags exposing (Flags)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port
import Route
import Story



-- MODEL


type alias Model =
    {}


init : List Story.Info -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Not Found | Stories By Iot"
    , content =
        div [ class "page page_dashboard clearfix" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "column" ] [ text "admin dashboard" ]
                    ]
                ]
            , div [ class "clearfix" ]
                [ div [ class "story__icon story__icon--home" ]
                    [ button [ onClick GoHome ] [ i [ class "icon-home" ] [] ]
                    ]
                ]
            , div [ class "clearfix" ]
                [ div [ class "story__icon story__icon--edit" ]
                    [ button [ onClick <| GoToEdit "storyId" ] [ i [ class "icon-edit" ] [] ]
                    ]
                ]
            ]
    }



-- Update


type Msg
    = GoHome
    | GoToEdit String


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        GoToEdit storyId ->
            ( model, Nav.pushUrl navKey <| Route.routeToString <| Route.EditStory storyId )

        GoHome ->
            ( model, Nav.pushUrl navKey <| Route.routeToString Route.Home )
